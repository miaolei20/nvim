return {
  {
    "kyazdani42/nvim-web-devicons",
    lazy = false,
    config = function()
      require("nvim-web-devicons").setup({ default = true })
    end,
  },
  {
    "rebelot/heirline.nvim",
    event = "VeryLazy",
    dependencies = { "kyazdani42/nvim-web-devicons" },
    config = function()
      local heirline = require("heirline")
      local conditions = require("heirline.conditions")
      local utils = require("heirline.utils")
      local devicons = require("nvim-web-devicons")

      -- UI settings
      vim.opt.showtabline = 2
      vim.opt.cmdheight = 0
      vim.opt.showcmd = false
      vim.opt.ruler = false
      vim.opt.showmode = false

      ------------------------------------------------------------------------------
      -- Colors (Modern IDE-inspired palette)
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
      -- Icons (Simpler, modern set)
      ------------------------------------------------------------------------------
      local icons = {
        mode = "󰣇",          -- Minimal mode indicator
        folder = "󰉓",       -- Simpler folder icon
        file = "󰈤",         -- Clean file icon
        branch = "󰜘",       -- Modern Git branch
        lsp = "󰧑",          -- Sleek LSP icon
        clock = "󰔛",        -- Minimal clock
        encoding = "󰬴",     -- Clean encoding icon
        format = "󰬴",       -- Same for format
        modified = "●",      -- Simple modified dot
        separator = "│",     -- Thin separator
        close = "󰅜",        -- Ultra-clean close
        git = {
          added = "+",      -- Simple Git added
          modified = "~",   -- Simple Git modified
          removed = "-",    -- Simple Git removed
        },
        diagnostics = {
          error = "󰅙",    -- Minimal error
          warn = "󰀦",     -- Minimal warning
          info = "󰋼",     -- Minimal info
          hint = "󰌵",     -- Minimal hint
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
      hl(0, "HeirlineWinBar", { bg = colors.bg, fg = colors.fg })
      hl(0, "HeirlineSeparator", { fg = colors.gray, bg = colors.light_bg })
      hl(0, "HeirlineAccent", { fg = colors.dark_bg, bg = colors.accent, bold = true })
      hl(0, "HeirlineSoftAccent", { fg = colors.dark_bg, bg = colors.soft_accent })
      hl(0, "HeirlineCloseButton", { fg = colors.red, bg = colors.dark_bg })

      ------------------------------------------------------------------------------
      -- Utilities
      ------------------------------------------------------------------------------
      local Space = { provider = " " }
      local Align = { provider = "%=" }

      -- Optimized icon cache
      local icon_cache = {}
      local function get_icon(filename, filetype, opts)
        local key = (filename or "") .. (filetype or "") .. (opts and opts.default and "default" or "")
        if icon_cache[key] then
          return icon_cache[key].icon, icon_cache[key].color
        end
        local icon, hl = devicons.get_icon(filename, filetype, opts)
        icon = icon or icons.file
        local hl_group = vim.api.nvim_get_hl_by_name(hl or "HeirlineLightBackground", true)
        local icon_color = hl_group.foreground and string.format("#%06x", hl_group.foreground) or colors.fg
        icon_cache[key] = { icon = icon, color = icon_color }
        return icon, icon_color
      end

      -- Modern path shortening (IDE-like)
      local function shorten_path(path)
        if path == "" then return "" end
        local home = vim.fn.expand("~")
        path = path:gsub("^" .. home, "~")
        local parts = vim.split(path, "/")
        if #parts <= 3 then return path end
        return table.concat({ parts[1], "…", parts[#parts - 1], parts[#parts] }, "/")
      end

      ------------------------------------------------------------------------------
      -- Mode Component (Full names)
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
            n = "NORMAL", i = "INSERT", v = "VISUAL", V = "VISUAL LINE", ["\22"] = "VISUAL BLOCK",
            c = "COMMAND", s = "SELECT", S = "SELECT LINE", ["\19"] = "SELECT BLOCK",
            R = "REPLACE", r = "REPLACE", ["!"] = "SHELL", t = "TERMINAL",
          },
        },
        provider = function(self)
          return icons.mode .. " " .. self.mode_names[self.mode] .. " "
        end,
        hl = function(self) return { fg = colors.black, bg = self.mode_color, bold = true } end,
        update = { "ModeChanged", pattern = "*:*" },
      }

      ------------------------------------------------------------------------------
      -- Git Branch Component
      ------------------------------------------------------------------------------
      local GitBranch = {
        condition = conditions.is_git_repo,
        init = function(self)
          self.status = vim.b.gitsigns_status_dict or { head = "" }
        end,
        provider = function(self)
          return icons.branch .. " " .. (self.status.head ~= "" and self.status.head or "none") .. " "
        end,
        hl = { fg = colors.green, bg = colors.light_bg },
        update = { "User", pattern = "GitSignsChanged" },
      }

      ------------------------------------------------------------------------------
      -- File Name Component
      ------------------------------------------------------------------------------
      local FileName = {
        provider = function()
          local name = vim.fn.expand("%:t")
          return (name ~= "" and name or "[No Name]") .. " "
        end,
        hl = { fg = colors.fg, bg = colors.light_bg, bold = true },
        update = { "BufEnter", "BufModifiedSet" },
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
          return icons.lsp .. " " .. (#names > 0 and table.concat(names, ", ") or "None") .. " "
        end,
        hl = { fg = colors.purple, bg = colors.light_bg },
        update = { "LspAttach", "LspDetach", "BufEnter" },
      }

      ------------------------------------------------------------------------------
      -- Git Diff (Enhanced to show changes)
      ------------------------------------------------------------------------------
      local GitDiff = {
  condition = conditions.is_git_repo,
  init = function(self)
    self.status = vim.b.gitsigns_status_dict or { added = 0, changed = 0, removed = 0 }
  end,
  provider = function(self)
    local parts = {}
    -- Use `or 0` to default to 0 if the value is nil
    if (self.status.added or 0) > 0 then
      table.insert(parts, icons.git.added .. (self.status.added or 0))
    end
    if (self.status.changed or 0) > 0 then
      table.insert(parts, icons.git.modified .. (self.status.changed or 0))
    end
    if (self.status.removed or 0) > 0 then
      table.insert(parts, icons.git.removed .. (self.status.removed or 0))
    end
    return #parts > 0 and table.concat(parts, " ") .. " " or ""
  end,
  hl = { fg = colors.yellow, bg = colors.light_bg },
  update = { "User", pattern = "GitSignsChanged", "BufEnter" },
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
        update = { "DiagnosticChanged", "BufEnter" },
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
        update = { "BufEnter", "OptionSet", pattern = "filetype" },
      }

      ------------------------------------------------------------------------------
      -- File Encoding
      ------------------------------------------------------------------------------
      local FileEncoding = {
        provider = function() return icons.encoding .. " " .. (vim.bo.fileencoding or "utf-8") .. " " end,
        hl = { fg = colors.blue, bg = colors.light_bg },
        update = { "BufEnter", "OptionSet", pattern = "fileencoding" },
      }

      ------------------------------------------------------------------------------
      -- File Format
      ------------------------------------------------------------------------------
      local FileFormat = {
        provider = function() return icons.format .. " " .. vim.bo.fileformat .. " " end,
        hl = { fg = colors.green, bg = colors.light_bg },
        update = { "BufEnter", "OptionSet", pattern = "fileformat" },
      }

      ------------------------------------------------------------------------------
      -- Location
      ------------------------------------------------------------------------------
      local Location = {
        provider = function()
          return "Ln " .. vim.fn.line(".") .. ", Col " .. vim.fn.col(".") .. " "
        end,
        hl = { fg = colors.dark_bg, bg = colors.soft_accent },
        update = { "CursorMoved", "CursorMovedI", "BufEnter" },
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
          provider = icons.separator,
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
        },
        {
          provider = icons.close,
          hl = function(self) return { fg = colors.red, bg = self.is_active and colors.accent or colors.dark_bg } end,
          on_click = {
            callback = function(self)
              if vim.api.nvim_buf_is_valid(self.bufnr) then
                vim.api.nvim_buf_delete(self.bufnr, { force = true })
              end
            end,
            name = function(self) return "close_buf_" .. self.bufnr end,
          },
        },
        update = { "BufEnter", "BufModifiedSet", "BufDelete", "BufWipeout" },
        on_click = {
          callback = function(self)
            if vim.api.nvim_buf_is_valid(self.bufnr) then
              vim.api.nvim_set_current_buf(self.bufnr)
            end
          end,
          name = function(self) return "buf_" .. self.bufnr end,
        },
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
        end,
        {
          provider = icons.separator,
          hl = function(self) return { fg = self.is_active and colors.accent or colors.gray, bg = colors.bg } end,
        },
        {
          provider = function(self) return "Tab " .. vim.api.nvim_tabpage_get_number(self.tabpage) .. " " end,
          hl = function(self)
            return {
              fg = self.is_active and colors.black or colors.gray,
              bg = self.is_active and colors.accent or colors.dark_bg,
              bold = self.is_active,
            }
          end,
        },
        {
          provider = icons.close,
          hl = function(self) return { fg = colors.red, bg = self.is_active and colors.accent or colors.dark_bg } end,
          on_click = { callback = function() vim.cmd.tabclose() end, name = "tab_close" },
        },
        update = { "TabEnter", "TabNew", "TabClosed" },
        on_click = {
          callback = function(self)
            if vim.api.nvim_tabpage_is_valid(self.tabpage) then
              vim.api.nvim_set_current_tabpage(self.tabpage)
            end
          end,
          name = function(self) return "tab_" .. self.tabpage end,
        },
      }

      local Tabs = {
        condition = function() return #vim.api.nvim_list_tabpages() >= 2 end,
        utils.make_tablist(TabComponent),
      }

      local TabClose = {
        condition = function() return #vim.api.nvim_list_tabpages() > 1 end,
        provider = icons.close .. " ",
        hl = { fg = colors.red, bg = colors.dark_bg },
        on_click = { callback = function() vim.cmd.tabclose() end, name = "tab_close" },
      }

      ------------------------------------------------------------------------------
      -- Winbar File Path (IDE-like)
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
          return icons.folder .. " " .. (self.filepath ~= "" and self.filepath or "[No Name]") .. " "
        end,
        hl = function(self) return { fg = self.icon_color, bg = colors.bg, italic = true } end,
        update = { "BufEnter", "BufModifiedSet", "DirChanged" },
        on_click = {
          callback = function(self)
            if vim.api.nvim_buf_is_valid(self.bufnr) then
              vim.api.nvim_set_current_buf(self.bufnr)
            end
          end,
          name = function(self) return "winbar_buf_" .. self.bufnr end,
        },
      }

      ------------------------------------------------------------------------------
      -- Winbar Time
      ------------------------------------------------------------------------------
      local WinBarTime = {
        provider = function() return icons.clock .. " " .. os.date("%H:%M") .. " " end,
        hl = { fg = colors.yellow, bg = colors.bg },
        update = { "User", pattern = "HeirlineTimer" },
      }

      -- Update time every 15 minutes
      vim.fn.timer_start(900000, function()
        vim.api.nvim_exec_autocmds("User", { pattern = "HeirlineTimer" })
      end, { ["repeat"] = -1 })

      ------------------------------------------------------------------------------
      -- Winbar Diagnostics
      ------------------------------------------------------------------------------
      local WinBarDiagnostics = {
        condition = conditions.has_diagnostics,
        static = {
          icons = icons.diagnostics,
        },
        init = function(self)
          self.bufnr = vim.api.nvim_get_current_buf()
          self.errors = #vim.diagnostic.get(self.bufnr, { severity = vim.diagnostic.severity.ERROR })
          self.warnings = #vim.diagnostic.get(self.bufnr, { severity = vim.diagnostic.severity.WARN })
          self.info = #vim.diagnostic.get(self.bufnr, { severity = vim.diagnostic.severity.INFO })
          self.hints = #vim.diagnostic.get(self.bufnr, { severity = vim.diagnostic.severity.HINT })
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
          }
        end,
        update = { "DiagnosticChanged", "BufEnter" },
      }

      ------------------------------------------------------------------------------
      -- Winbar
      ------------------------------------------------------------------------------
      local WinBar = {
        condition = function()
          return not vim.bo.buftype:match("^(quickfix|nofile|help|terminal|alpha)$")
        end,
        WinBarFilePath,
        Align,
        WinBarDiagnostics,
        Space,
        WinBarTime,
      }

      ------------------------------------------------------------------------------
      -- Statusline
      ------------------------------------------------------------------------------
      local StatusLine = {
        condition = function() return not vim.bo.buftype:match("alpha") end,
        hl = { bg = colors.bg },
        Mode,
        {
          hl = { bg = colors.light_bg },
          Space,
          GitBranch,
          FileName,
          ModifiedIndicator,
          LSPClients,
          GitDiff,
          Diagnostics,
        },
        Align,
        {
          hl = { bg = colors.light_bg },
          FileType,
          FileEncoding,
          FileFormat,
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
        statusline = StatusLine,
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

      -- Hide statusline on startup
      vim.api.nvim_create_autocmd("BufEnter", {
        callback = function()
          vim.opt.laststatus = (vim.fn.bufname() == "" or vim.bo.buftype == "alpha") and 0 or 2
        end,
      })
    end,
  },
}
