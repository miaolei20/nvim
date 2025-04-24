return {
  {
    "kyazdani42/nvim-web-devicons",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-web-devicons").setup({ default = true })
    end,
  },
  {
    "rebelot/heirline.nvim",
    event = { "BufReadPost", "BufNewFile", "VimEnter" },
    dependencies = { "kyazdani42/nvim-web-devicons" },
    config = function()
      local heirline = require("heirline")
      local conditions = require("heirline.conditions")
      local utils = require("heirline.utils")
      local devicons = require("nvim-web-devicons")

      -- Enable mouse support
      vim.opt.mouse = "a" -- 确保鼠标支持已启用

      -- UI settings
      vim.opt.showtabline = 2
      -- vim.opt.cmdheight = 0
      -- vim.opt.showcmd = false
      vim.opt.ruler = false
      vim.opt.showmode = false

      ------------------------------------------------------------------------------
      -- Colors
      ------------------------------------------------------------------------------
      local colors = require("onedarkpro.helpers").get_colors() or {
        bg = "#1e222a",
        fg = "#abb2bf",
        black = "#000000",
        blue = "#61afef",
        green = "#98c379",
        purple = "#c678dd",
        yellow = "#e5c07b",
        orange = "#d19a66",
        red = "#e06c75",
        gray = "#5c6370",
        dark_bg = "#181c24",
        light_bg = "#2a2e38",
        accent = "#56b6c2",
        soft_accent = "#7dcfff",
      }

      ------------------------------------------------------------------------------
      -- Icons (Using Nerd Fonts for a Modern Look)
      ------------------------------------------------------------------------------
      local icons = {
        mode = "󰀘", -- nf-md-alpha_circle
        folder = "󰉋", -- nf-md-folder
        file = "󰈔", -- nf-md-file
        branch = "󰊢", -- nf-md-git
        lsp = "󰒋", -- nf-md-server
        modified = "󰀬", -- nf-md-circle_medium
        separator = "󰿟", -- nf-md-pipe
        close = "󰅖", -- nf-md-close
        diagnostics = {
          error = "󰅚", -- nf-md-close_circle
          warn = "󰀪", -- nf-md-alert
          info = "󰋽", -- nf-md-information
          hint = "󰌶", -- nf-md-lightbulb
        },
      }

      ------------------------------------------------------------------------------
      -- Highlight Groups
      ------------------------------------------------------------------------------
      local hl = vim.api.nvim_set_hl
      hl(0, "HeirlineBackground", { bg = colors.bg, fg = colors.fg })
      hl(0, "HeirlineDarkBackground", { bg = colors.dark_bg, fg = colors.gray })
      hl(0, "HeirlineLightBackground", { bg = colors.light_bg, fg = colors.fg })
      hl(0, "HeirlineTabLine", { bg = colors.dark_bg, fg = colors.gray })
      hl(0, "HeirlineTabLineSel", { bg = colors.accent, fg = colors.black, bold = true })
      hl(0, "HeirlineWinBar", { bg = colors.dark_bg, fg = colors.fg })
      hl(0, "HeirlineSeparator", { fg = colors.gray, bg = colors.light_bg })
      hl(0, "HeirlineAccent", { fg = colors.dark_bg, bg = colors.accent, bold = true })
      hl(0, "HeirlineSoftAccent", { fg = colors.dark_bg, bg = colors.soft_accent })
      hl(0, "HeirlineCloseButton", { fg = colors.red, bg = colors.dark_bg })

      ------------------------------------------------------------------------------
      -- Utilities
      ------------------------------------------------------------------------------
      local Space = { provider = "  " }
      local Align = { provider = "%=" }

      -- Icon cache for performance
      local icon_cache = {}
      local function get_icon(filename, filetype, opts)
        local key = (filename or "") .. (filetype or "") .. (opts and opts.default and "default" or "")
        if icon_cache[key] then
          return icon_cache[key].icon, icon_cache[key].color
        end
        local icon, hl_group = devicons.get_icon(filename, filetype, opts)
        icon = icon or icons.file
        local hl = vim.api.nvim_get_hl_by_name(hl_group or "HeirlineLightBackground", true)
        local icon_color = hl.foreground and string.format("#%06x", hl.foreground) or colors.fg
        icon_cache[key] = { icon = icon, color = icon_color }
        return icon, icon_color
      end

      -- Path shortening
      local function shorten_path(path)
        if path == "" then return "" end
        local home = vim.fn.expand("~")
        path = path:gsub("^" .. home, "~")
        local parts = vim.split(path, "/")
        if #parts <= 3 then return path end
        return table.concat({ parts[1], "…", parts[#parts - 1], parts[#parts] }, "/")
      end

      ------------------------------------------------------------------------------
      -- Mode Component
      ------------------------------------------------------------------------------
      local Mode = {
        init = function(self)
          self.mode = vim.fn.mode(1)
          self.mode_color = ({
            n = colors.blue, i = colors.green, v = colors.purple, V = colors.purple,
            ["\22"] = colors.purple, c = colors.yellow, s = colors.orange, S = colors.orange,
            ["\19"] = colors.orange, R = colors.red, r = colors.red, ["!"] = colors.red,
            t = colors.red,
          })[self.mode] or colors.blue
        end,
        static = {
          mode_names = {
            n = "N", i = "I", v = "V", V = "VL", ["\22"] = "VB",
            c = "C", s = "S", S = "SL", ["\19"] = "SB",
            R = "R", r = "R", ["!"] = "SH", t = "T",
          },
        },
        provider = function(self)
          return icons.mode .. " " .. (self.mode_names[self.mode] or "U") .. " "
        end,
        hl = function(self) return { fg = colors.black, bg = self.mode_color, bold = true } end,
        update = { "ModeChanged" },
      }

      ------------------------------------------------------------------------------
      -- File Name Component
      ------------------------------------------------------------------------------
      local FileName = {
        provider = function()
          local name = vim.fn.expand("%:t")
          return name ~= "" and name or "Dashboard"
        end,
        hl = { fg = colors.fg, bg = colors.light_bg, bold = true },
        update = { "BufEnter" },
      }

      ------------------------------------------------------------------------------
      -- Alpha-specific Statusline
      ------------------------------------------------------------------------------
      local AlphaStatusLine = {
        condition = function() return vim.bo.buftype == "alpha" end,
        hl = { bg = colors.bg },
        Mode,
        Space,
        {
          hl = { bg = colors.light_bg },
          FileName,
        },
        Align,
      }

      ------------------------------------------------------------------------------
      -- Git Branch Component
      ------------------------------------------------------------------------------
      local GitBranch = {
        condition = conditions.is_git_repo,
        init = function(self)
          self.status = vim.b.gitsigns_status_dict or {}
        end,
        provider = function(self)
          local head = self.status.head
          return icons.branch .. " " .. (head and head ~= "" and head or "none") .. " "
        end,
        hl = { fg = colors.green, bg = colors.light_bg },
        update = { "User", pattern = "GitSignsChanged" },
      }

      ------------------------------------------------------------------------------
      -- Modified Indicator
      ------------------------------------------------------------------------------
      local ModifiedIndicator = {
        condition = function() return vim.bo.modified end,
        provider = icons.modified .. " ",
        hl = { fg = colors.orange, bg = colors.light_bg },
        update = { "BufModifiedSet" },
      }

      ------------------------------------------------------------------------------
      -- LSP Clients
      ------------------------------------------------------------------------------
      local LSPClients = {
        condition = function() return next(vim.lsp.get_clients({ bufnr = 0 })) ~= nil end,
        provider = function()
          local names = vim.tbl_map(function(c) return c.name end, vim.lsp.get_clients({ bufnr = 0 }))
          return icons.lsp .. " " .. (#names > 0 and table.concat(names, ", ") or "none") .. " "
        end,
        hl = { fg = colors.purple, bg = colors.light_bg },
        update = { "LspAttach", "LspDetach" },
      }

      ------------------------------------------------------------------------------
      -- Diagnostics
      ------------------------------------------------------------------------------
      local Diagnostics = {
        condition = conditions.has_diagnostics,
        static = {
          icons = icons.diagnostics,
        },
        init = function(self)
          self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
          self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
          self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
          self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
        end,
        provider = function(self)
          local parts = {}
          if self.errors > 0 then table.insert(parts, self.icons.error .. self.errors) end
          if self.warnings > 0 then table.insert(parts, self.icons.warn .. self.warnings) end
          if self.info > 0 then table.insert(parts, self.icons.info .. self.info) end
          if self.hints > 0 then table.insert(parts, self.icons.hint .. self.hints) end
          return #parts > 0 and table.concat(parts, " ") .. " " or ""
        end,
        hl = function(self)
          return {
            fg = self.errors > 0 and colors.red or
                 self.warnings > 0 and colors.yellow or
                 self.info > 0 and colors.blue or
                 colors.green,
            bg = colors.light_bg,
          }
        end,
        update = { "DiagnosticChanged" },
        on_click = {
          callback = function() vim.cmd("Trouble diagnostics toggle") end,
          name = "heirline_diagnostics",
        },
      }

      ------------------------------------------------------------------------------
      -- File Type
      ------------------------------------------------------------------------------
      local FileType = {
        init = function(self)
          self.filetype = vim.bo.filetype
          self.icon, self.icon_color = get_icon(nil, self.filetype, { default = true })
        end,
        provider = function(self)
          return self.icon .. " " .. (self.filetype ~= "" and self.filetype or "none") .. " "
        end,
        hl = function(self) return { fg = self.icon_color, bg = colors.light_bg } end,
        update = { "BufEnter" },
      }

      ------------------------------------------------------------------------------
      -- File Info
      ------------------------------------------------------------------------------
      local FileInfo = {
        provider = function()
          local enc = (vim.bo.fileencoding ~= "" and vim.bo.fileencoding) or vim.o.encoding
          local size = vim.fn.getfsize(vim.fn.expand("%:p"))
          if size < 0 then return enc:upper() .. " " end
          local units = { "B", "KB", "MB", "GB" }
          local i = 1
          while size >= 1024 and i < #units do
            size = size / 1024
            i = i + 1
          end
          return string.format("%s %s %.1f%s ", enc:upper(), icons.separator, size, units[i])
        end,
        hl = { fg = colors.blue, bg = colors.light_bg },
        update = { "BufEnter", "BufWritePost" },
      }

      ------------------------------------------------------------------------------
      -- Location
      ------------------------------------------------------------------------------
      local Location = {
        {
          provider = "󰆌 ", -- nf-md-cursor
          hl = { fg = colors.dark_bg, bg = colors.soft_accent },
        },
        {
          provider = function()
            return vim.fn.line(".") .. ":" .. vim.fn.col(".") .. " "
          end,
          hl = { fg = colors.dark_bg, bg = colors.soft_accent },
          update = { "CursorMoved" },
        },
      }

      ------------------------------------------------------------------------------
      -- Buffer Component (Tabline)
      ------------------------------------------------------------------------------
      local BufferComponent = {
        init = function(self)
          self.bufnr = self.bufnr or vim.api.nvim_get_current_buf()
          self.filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(self.bufnr), ":t")
          self.modified = vim.bo[self.bufnr].modified and icons.modified or ""
          self.is_active = vim.api.nvim_get_current_buf() == self.bufnr
          self.icon, self.icon_color = get_icon(self.filename, nil, { default = true })
        end,
        {
          provider = icons.separator .. " ",
          hl = function(self) return { fg = self.is_active and colors.accent or colors.gray, bg = colors.bg } end,
        },
        {
          provider = function(self)
            return self.icon .. " " .. (self.filename ~= "" and self.filename or "[No Name]") .. self.modified .. " "
          end,
          hl = function(self)
            local base_hl = self.is_active and "HeirlineTabLineSel" or "HeirlineTabLine"
            return { fg = self.is_active and self.icon_color or colors.gray, bg = vim.api.nvim_get_hl_by_name(base_hl, true).background }
          end,
          on_click = {
            callback = function(_, minwid, _, _)
              print("Switching to buffer: " .. minwid) -- 调试日志
              if vim.api.nvim_buf_is_valid(minwid) then
                vim.api.nvim_set_current_buf(minwid)
              else
                print("Invalid buffer: " .. minwid)
              end
            end,
            name = function(self) return "buf_" .. self.bufnr end,
            minwid = function(self) return self.bufnr end, -- 使用 minwid 传递 bufnr
          },
        },
        {
          provider = icons.close .. " ",
          hl = function(self) return { fg = colors.red, bg = self.is_active and colors.accent or colors.dark_bg } end,
          on_click = {
            callback = function(_, minwid, _, _)
              print("Closing buffer: " .. minwid) -- 调试日志
              if vim.api.nvim_buf_is_valid(minwid) then
                vim.api.nvim_buf_delete(minwid, { force = true })
              else
                print("Invalid buffer to close: " .. minwid)
              end
            end,
            name = function(self) return "close_buf_" .. self.bufnr end,
            minwid = function(self) return self.bufnr end, -- 使用 minwid 传递 bufnr
          },
        },
        update = { "BufEnter", "BufDelete" },
      }

      local Buffers = {
        condition = function()
          return #vim.tbl_filter(function(buf)
            return vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted
          end, vim.api.nvim_list_bufs()) > 1
        end,
        utils.make_buflist(BufferComponent),
      }

      ------------------------------------------------------------------------------
      -- Tab Component
      ------------------------------------------------------------------------------
      local TabComponent = {
        init = function(self)
          self.tabpage = self.tabpage or vim.api.nvim_get_current_tabpage()
          self.is_active = self.tabpage == vim.api.nvim_get_current_tabpage()
          self.tabnr = vim.api.nvim_tabpage_get_number(self.tabpage)
        end,
        {
          provider = icons.separator .. " ",
          hl = function(self) return { fg = self.is_active and colors.accent or colors.gray, bg = colors.bg } end,
        },
        {
          provider = function(self) return "󰓩 " .. self.tabnr .. " " end, -- nf-md-tab
          hl = function(self)
            return {
              fg = self.is_active and colors.black or colors.gray,
              bg = self.is_active and colors.accent or colors.dark_bg,
              bold = self.is_active,
            }
          end,
          on_click = {
            callback = function(_, minwid, _, _)
              print("Switching to tab: " .. minwid) -- 调试日志
              if vim.api.nvim_tabpage_is_valid(minwid) then
                vim.api.nvim_set_current_tabpage(minwid)
              else
                print("Invalid tab: " .. minwid)
              end
            end,
            name = function(self) return "tab_" .. self.tabpage end,
            minwid = function(self) return self.tabpage end, -- 使用 minwid 传递 tabpage
          },
        },
        {
          provider = icons.close .. " ",
          hl = function(self) return { fg = colors.red, bg = self.is_active and colors.accent or colors.dark_bg } end,
          on_click = {
            callback = function(_, minwid, _, _)
              print("Closing tab: " .. minwid) -- 调试日志
              local tabnr = vim.api.nvim_tabpage_get_number(minwid)
              if vim.api.nvim_tabpage_is_valid(minwid) then
                vim.cmd("tabclose " .. tabnr)
              else
                print("Invalid tab to close: " .. minwid)
              end
            end,
            name = function(self) return "close_tab_" .. self.tabpage end,
            minwid = function(self) return self.tabpage end, -- 使用 minwid 传递 tabpage
          },
        },
        update = { "TabEnter", "TabClosed" }, -- 移除 TabNew，减少不必要更新
      }

      local Tabs = {
        condition = function() return #vim.api.nvim_list_tabpages() >= 2 end,
        utils.make_tablist(NumberedTabComponent),
      }

      local TabClose = {
        condition = function() return #vim.api.nvim_list_tabpages() > 1 end,
        provider = icons.close .. " ",
        hl = { fg = colors.red, bg = colors.dark_bg },
        on_click = {
          callback = function()
            print("Closing current tab") -- 调试日志
            vim.cmd("tabclose")
          end,
          name = "tab_close",
        },
      }

      ------------------------------------------------------------------------------
      -- Winbar File Path
      ------------------------------------------------------------------------------
      local WinBarFilePath = {
        init = function(self)
          self.bufnr = vim.api.nvim_get_current_buf()
          local full_path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(self.bufnr), ":~:.")
          self.filepath = shorten_path(full_path)
          self.filename = vim.fn.fnamemodify(full_path, ":t")
          self.icon, self.icon_color = get_icon(self.filename, nil, { default = true })
        end,
        provider = function(self)
          return icons.folder .. " " .. (self.filepath ~= "" and self.filepath or "Dashboard") .. " "
        end,
        hl = function(self) return { fg = self.icon_color, bg = colors.dark_bg, italic = true } end,
        update = { "BufEnter", "DirChanged" },
        on_click = {
          callback = function(_, minwid, _, _)
            print("Switching to buffer (winbar): " .. minwid) -- 调试日志
            if vim.api.nvim_buf_is_valid(minwid) then
              vim.api.nvim_set_current_buf(minwid)
            else
              print("Invalid buffer (winbar): " .. minwid)
            end
          end,
          name = function(self) return "winbar_buf_" .. self.bufnr end,
          minwid = function(self) return self.bufnr end,
        },
      }

      ------------------------------------------------------------------------------
      -- Winbar
      ------------------------------------------------------------------------------
      local WinBar = {
        condition = function()
          return not vim.bo.buftype:match("^(quickfix|nofile|help|terminal|alpha)$")
        end,
        Space,
        WinBarFilePath,
        Align,
      }

      ------------------------------------------------------------------------------
      -- Statusline for Non-Alpha Buffers
      ------------------------------------------------------------------------------
      local DefaultStatusLine = {
        condition = function() return not vim.bo.buftype:match("alpha") end,
        hl = { bg = colors.bg },
        Mode,
        Space,
        {
          hl = { bg = colors.light_bg },
          GitBranch,
          Space,
          FileName,
          ModifiedIndicator,
          Space,
          LSPClients,
        },
        Align,
        {
          hl = { bg = colors.light_bg },
          Diagnostics,
          Space,
          FileType,
          Space,
          FileInfo,
          Space,
          Location,
        },
      }

      ------------------------------------------------------------------------------
      -- Tabline
      ------------------------------------------------------------------------------
      local TabLine = {
        condition = function() return not vim.bo.buftype:match("alpha") end,
        hl = { bg = colors.bg },
        Space,
        Buffers,
        Align,
        Tabs,
        Space,
        TabClose,
      }

      ------------------------------------------------------------------------------
      -- Heirline Setup
      ------------------------------------------------------------------------------
      heirline.setup({
        statusline = { AlphaStatusLine, DefaultStatusLine },
        tabline = TabLine,
        winbar = WinBar,
        opts = {
          disable_winbar_cb = function(args)
            local buftype = vim.bo[args.buf].buftype
            return vim.fn.bufname(args.buf) == "" or
                   buftype == "alpha" or
                   conditions.buffer_matches({ buftype = { "quickfix", "nofile", "help", "terminal" } }, args.buf)
          end,
        },
      })

      -- Always show statusline
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          vim.opt.laststatus = 2
        end,
      })
    end,
  },
}