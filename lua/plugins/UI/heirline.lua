return {
  {
    "kyazdani42/nvim-web-devicons",
    lazy = false,
    config = function()
      require("nvim-web-devicons").setup() -- Ensure icons are loaded early
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

      -- Force tabline to always show
      vim.opt.showtabline = 2
      -- Hide command line and suppress all related UI elements
      vim.opt.cmdheight = 0 -- Hide command line
      vim.opt.showcmd = false -- Disable partial commands display
      vim.opt.ruler = false -- Disable ruler
      vim.opt.showmode = false -- Disable mode display (handled by Statusline)

      ------------------------------------------------------------------------------
      -- Colors (AstroNvim-inspired palette)
      ------------------------------------------------------------------------------
      local colors = require("onedarkpro.helpers").get_colors() or {
        bg = "#1e222a",           -- Dark background
        fg = "#abb2bf",           -- Light foreground
        black = "#000000",        -- Black for mode text
        blue = "#61afef",         -- Normal mode, active elements
        green = "#98c379",        -- Insert mode, Git added
        purple = "#c678dd",       -- Visual mode, LSP
        yellow = "#e5c07b",       -- Command mode, warnings, time
        orange = "#d19a66",       -- Select mode
        red = "#e06c75",          -- Replace mode, errors
        gray = "#5c6370",         -- Inactive elements
        dark_bg = "#181c24",      -- Darker background for contrast
        light_bg = "#2a2e38",     -- Lighter background for components
        accent = "#56b6c2",       -- Cyan accent for active elements
        soft_accent = "#7dcfff",  -- Softer cyan for secondary highlights
      }

      ------------------------------------------------------------------------------
      -- Icons (Ultra-modern set with AstroNvim inspiration)
      ------------------------------------------------------------------------------
      local icons = {
        misc = {
          lsp = "󱘖",           -- Ultra-modern LSP icon
          vim = "󱕃",           -- Ultra-modern Vim icon
          branch = "󰙅",       -- Ultra-modern Git branch icon
          default = "󰈙",      -- Ultra-modern default file icon
          clock = "󱑂",        -- Ultra-modern clock icon
          encoding = "󱎸",    -- Ultra-modern encoding icon
          format = "󱎘",      -- Ultra-modern file format icon
          modified = "󱇨",    -- Ultra-modern modified indicator
          -- Bottle icons for different water levels
          bottle_empty = "󱔕", -- Empty bottle (0–10%)
          bottle_low = "󱔓",   -- Low water (10–30%)
          bottle_mid = "󱔔",   -- Medium water (30–70%)
          bottle_high = "󱔒",  -- High water (70–90%)
          bottle_full = "󱔑",  -- Full bottle (90–100%)
        },
        git = {
          added = "󱓞",       -- Ultra-modern Git added icon
          modified = "󱓟",    -- Ultra-modern Git modified icon
          removed = "󱓜",     -- Ultra-modern Git removed icon
        },
        diagnostics = {
          Error = "󱓤",      -- Ultra-modern error icon
          Warn = "󱓦",       -- Ultra-modern warning icon
          Info = "󱓥",       -- Ultra-modern info icon
          Hint = "󱓣",       -- Ultra-modern hint icon
        },
        ui = {
          close = "󱎘",      -- Ultra-modern close icon
          separator = "┋",   -- Ultra-modern, sleek separator
        },
      }

      ------------------------------------------------------------------------------
      -- Highlight Groups (AstroNvim style)
      ------------------------------------------------------------------------------
      local hl = vim.api.nvim_set_hl
      hl(0, "HeirlineBackground", { bg = colors.bg, fg = colors.fg })
      hl(0, "HeirlineDarkBackground", { bg = colors.dark_bg, fg = colors.gray })
      hl(0, "HeirlineLightBackground", { bg = colors.light_bg, fg = colors.fg })
      hl(0, "HeirlineTabLine", { bg = colors.dark_bg, fg = colors.gray })
      hl(0, "HeirlineTabLineSel", { bg = colors.accent, fg = colors.dark_bg, bold = true })
      hl(0, "HeirlineWinBar", { bg = colors.bg, fg = colors.fg })
      hl(0, "HeirlineSeparator", { fg = colors.gray, bg = colors.light_bg })
      hl(0, "HeirlineAccent", { fg = colors.dark_bg, bg = colors.accent, bold = true })
      hl(0, "HeirlineSoftAccent", { fg = colors.dark_bg, bg = colors.soft_accent, bold = true })
      hl(0, "HeirlineCloseButton", { fg = colors.red, bg = nil })

      ------------------------------------------------------------------------------
      -- Utility Components
      ------------------------------------------------------------------------------
      local Space = { provider = " " }
      local Align = { provider = "%=" }

      -- Cached icon retrieval for performance
      local icon_cache = {}
      local function get_icon(filename, filetype, opts)
        local key = (filename or "") .. (filetype or "") .. (opts and opts.default and "default" or "")
        if icon_cache[key] then
          return icon_cache[key].icon, icon_cache[key].color
        end
        local icon, hl = devicons.get_icon(filename, filetype, opts)
        if not icon then
          icon = icons.misc.default
          hl = "HeirlineLightBackground"
        end
        local hl_group = vim.api.nvim_get_hl_by_name(hl, true)
        local icon_color = hl_group.foreground and string.format("#%06x", hl_group.foreground) or colors.fg
        icon_cache[key] = { icon = icon, color = icon_color }
        return icon, icon_color
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
            n = "NORMAL", i = "INSERT", v = "VISUAL", V = "V-LINE", ["\22"] = "V-BLOCK",
            c = "COMMAND", s = "SELECT", S = "S-LINE", ["\19"] = "S-BLOCK",
            R = "REPLACE", r = "REPLACE", ["!"] = "SHELL", t = "TERMINAL",
          },
        },
        provider = function(self)
          return " " .. icons.misc.vim .. " " .. self.mode_names[self.mode] .. " "
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
          self.status = vim.b.gitsigns_status_dict or { head = "unknown" }
        end,
        provider = function(self)
          return " " .. icons.misc.branch .. " " .. self.status.head .. " "
        end,
        hl = { fg = colors.green, bg = colors.light_bg },
        update = { "User", pattern = "GitSignsChanged" },
      }

      ------------------------------------------------------------------------------
      -- File Name Component (Statusline)
      ------------------------------------------------------------------------------
      local FileName = {
        provider = function()
          local name = vim.fn.expand("%:t")
          return " " .. (name ~= "" and name or "[No Name]") .. " "
        end,
        hl = { fg = colors.fg, bg = colors.light_bg, bold = true },
        update = { "BufEnter", "BufModifiedSet" },
      }

      ------------------------------------------------------------------------------
      -- Modified Indicator Component
      ------------------------------------------------------------------------------
      local ModifiedIndicator = {
        condition = function() return vim.bo.modified end,
        provider = function() return " " .. icons.misc.modified .. " " end,
        hl = { fg = colors.orange, bg = colors.light_bg },
        update = { "BufModifiedSet" },
      }

      ------------------------------------------------------------------------------
      -- LSP Clients Component
      ------------------------------------------------------------------------------
      local LSPClients = {
        condition = function() return next(vim.lsp.get_clients({ bufnr = 0 })) ~= nil end,
        init = function(self)
          local clients = vim.lsp.get_clients({ bufnr = 0 })
          self.names = {}
          for _, client in ipairs(clients) do
            if client.name then table.insert(self.names, client.name) end
          end
        end,
        provider = function(self)
          return " " .. icons.misc.lsp .. " " .. (#self.names > 0 and table.concat(self.names, ", ") or "None") .. " "
        end,
        hl = { fg = colors.purple, bg = colors.light_bg },
        update = { "LspAttach", "LspDetach", "BufEnter" },
      }

      ------------------------------------------------------------------------------
      -- Git Diff Component
      ------------------------------------------------------------------------------
      local GitDiff = {
        condition = conditions.is_git_repo,
        init = function(self)
          self.status = vim.b.gitsigns_status_dict or { added = 0, changed = 0, removed = 0 }
        end,
        provider = function(self)
          local parts = {}
          if self.status.added > 0 then table.insert(parts, icons.git.added .. self.status.added) end
          if self.status.changed > 0 then table.insert(parts, icons.git.modified .. self.status.changed) end
          if self.status.removed > 0 then table.insert(parts, icons.git.removed .. self.status.removed) end
          return #parts > 0 and " " .. table.concat(parts, " ") .. " " or ""
        end,
        hl = function(self)
          local fg = self.status.added > 0 and colors.green or
                    self.status.changed > 0 and colors.yellow or
                    self.status.removed > 0 and colors.red or colors.fg
          return { fg = fg, bg = colors.light_bg }
        end,
        update = { "User", pattern = "GitSignsChanged" },
      }

      ------------------------------------------------------------------------------
      -- Diagnostics Component
      ------------------------------------------------------------------------------
      local Diagnostics = {
        condition = conditions.has_diagnostics,
        static = {
          error_icon = icons.diagnostics.Error,
          warn_icon = icons.diagnostics.Warn,
          info_icon = icons.diagnostics.Info,
          hint_icon = icons.diagnostics.Hint,
        },
        init = function(self)
          self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
          self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
          self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
          self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
        end,
        provider = function(self)
          local parts = {}
          if self.errors > 0 then table.insert(parts, self.error_icon .. self.errors) end
          if self.warnings > 0 then table.insert(parts, self.warn_icon .. self.warnings) end
          if self.info > 0 then table.insert(parts, self.info_icon .. self.info) end
          if self.hints > 0 then table.insert(parts, self.hint_icon .. self.hints) end
          return #parts > 0 and " " .. table.concat(parts, " ") .. " " or ""
        end,
        hl = function(self)
          local fg = self.errors > 0 and colors.red or
                    self.warnings > 0 and colors.yellow or
                    self.info > 0 and colors.blue or
                    colors.green
          return { fg = fg, bg = colors.light_bg }
        end,
        update = { "DiagnosticChanged", "BufEnter" },
      }

      ------------------------------------------------------------------------------
      -- File Type Component (Statusline)
      ------------------------------------------------------------------------------
      local FileType = {
        init = function(self)
          self.filetype = vim.bo.filetype
          self.icon, self.icon_color = get_icon(nil, self.filetype, { default = true })
        end,
        provider = function(self)
          return " " .. self.icon .. " " .. (self.filetype ~= "" and self.filetype or "none") .. " "
        end,
        hl = function(self) return { fg = self.icon_color, bg = colors.light_bg } end,
        update = { "BufEnter", "OptionSet", pattern = "filetype" },
      }

      ------------------------------------------------------------------------------
      -- File Encoding Component
      ------------------------------------------------------------------------------
      local FileEncoding = {
        provider = function() return " " .. icons.misc.encoding .. " " .. (vim.bo.fileencoding or "utf-8") .. " " end,
        hl = { fg = colors.blue, bg = colors.light_bg },
        update = { "BufEnter", "OptionSet", pattern = "fileencoding" },
      }

      ------------------------------------------------------------------------------
      -- File Format Component
      ------------------------------------------------------------------------------
      local FileFormat = {
        provider = function() return " " .. icons.misc.format .. " " .. vim.bo.fileformat .. " " end,
        hl = { fg = colors.green, bg = colors.light_bg },
        update = { "BufEnter", "OptionSet", pattern = "fileformat" },
      }

      ------------------------------------------------------------------------------
      -- Location Component (Bottle-and-Water Metaphor)
      ------------------------------------------------------------------------------
      local Location = {
        init = function(self)
          local line = vim.fn.line(".")
          local total_lines = vim.fn.line("$")
          local position = total_lines > 0 and (line / total_lines) or 0
          -- Determine the bottle icon based on the cursor's relative position
          if position <= 0.1 then
            self.bottle_icon = icons.misc.bottle_empty -- Empty (0–10%)
          elseif position <= 0.3 then
            self.bottle_icon = icons.misc.bottle_low   -- Low (10–30%)
          elseif position <= 0.7 then
            self.bottle_icon = icons.misc.bottle_mid   -- Medium (30–70%)
          elseif position <= 0.9 then
            self.bottle_icon = icons.misc.bottle_high  -- High (70–90%)
          else
            self.bottle_icon = icons.misc.bottle_full  -- Full (90–100%)
          end
        end,
        provider = function(self)
          return " " .. self.bottle_icon .. " " .. vim.fn.line(".") .. ":" .. vim.fn.col(".") .. " "
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
          self.modified = vim.bo[self.bufnr].modified and "[+]" or ""
          self.is_active = vim.api.nvim_get_current_buf() == self.bufnr
          self.icon, self.icon_color = get_icon(self.filename, nil, { default = true })
        end,
        {
          provider = icons.ui.separator,
          hl = function(self) return { fg = self.is_active and colors.accent or colors.gray, bg = colors.bg } end,
        },
        {
          provider = function(self)
            return " " .. self.icon .. " " .. (self.filename ~= "" and self.filename or "[No Name]") .. self.modified .. " "
          end,
          hl = function(self)
            local base_hl = self.is_active and "HeirlineTabLineSel" or "HeirlineTabLine"
            return { fg = self.icon_color, bg = vim.api.nvim_get_hl_by_name(base_hl, true).background }
          end,
        },
        {
          provider = icons.ui.close,
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
        update = { "BufEnter", "BufModifiedSet" },
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
            return vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted
          end, vim.api.nvim_list_bufs()) > 1
        end,
        utils.make_buflist(BufferComponent),
      }

      ------------------------------------------------------------------------------
      -- Tab Component (Tabline)
      ------------------------------------------------------------------------------
      local TabComponent = {
        init = function(self)
          self.tabpage = self.tabpage or vim.api.nvim_get_current_tabpage()
          self.is_active = self.tabpage == vim.api.nvim_get_current_tabpage()
        end,
        {
          provider = icons.ui.separator,
          hl = function(self) return { fg = self.is_active and colors.accent or colors.gray, bg = colors.bg } end,
        },
        {
          provider = function(self) return " " .. vim.api.nvim_tabpage_get_number(self.tabpage) .. " " end,
          hl = function(self) return self.is_active and "HeirlineTabLineSel" or "HeirlineTabLine" end,
        },
        {
          provider = icons.ui.close,
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
        provider = " " .. icons.ui.close .. " ",
        hl = { fg = colors.red, bg = colors.dark_bg },
        on_click = { callback = function() vim.cmd.tabclose() end, name = "tab_close" },
      }

      ------------------------------------------------------------------------------
      -- Winbar File Path Component
      ------------------------------------------------------------------------------
      local WinBarFilePath = {
        init = function(self)
          self.bufnr = vim.api.nvim_get_current_buf()
          local full_path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(self.bufnr), ":~:.")
          self.filepath = vim.fn.pathshorten(full_path)
          self.filename = vim.fn.fnamemodify(full_path, ":t")
          self.icon, self.icon_color = get_icon(self.filename, nil, { default = true })
        end,
        provider = function(self)
          return " " .. self.icon .. " " .. (self.filepath ~= "" and self.filepath or "[No Name]") .. " "
        end,
        hl = function(self) return { fg = self.icon_color, bg = colors.light_bg, italic = true } end,
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
      -- Winbar Time Component
      ------------------------------------------------------------------------------
      local WinBarTime = {
        provider = function() return " " .. icons.misc.clock .. " " .. os.date("%H:%M") .. " " end,
        hl = { fg = colors.yellow, bg = colors.light_bg },
        update = { "User", pattern = "HeirlineTimer" },
      }

      -- Timer to update time every 15 minutes
      vim.fn.timer_start(900000, function()
        vim.api.nvim_exec_autocmds("User", { pattern = "HeirlineTimer" })
      end, { ["repeat"] = -1 })

      ------------------------------------------------------------------------------
      -- Winbar Diagnostics Component
      ------------------------------------------------------------------------------
      local WinBarDiagnostics = {
        condition = conditions.has_diagnostics,
        static = {
          error_icon = icons.diagnostics.Error,
          warn_icon = icons.diagnostics.Warn,
          info_icon = icons.diagnostics.Info,
          hint_icon = icons.diagnostics.Hint,
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
          if self.errors > 0 then table.insert(parts, self.error_icon .. self.errors) end
          if self.warnings > 0 then table.insert(parts, self.warn_icon .. self.warnings) end
          if self.info > 0 then table.insert(parts, self.info_icon .. self.info) end
          if self.hints > 0 then table.insert(parts, self.hint_icon .. self.hints) end
          return #parts > 0 and table.concat(parts, " ") .. " " or ""
        end,
        hl = function(self)
          local fg = self.errors > 0 and colors.red or
                    self.warnings > 0 and colors.yellow or
                    self.info > 0 and colors.blue or
                    colors.green
          return { fg = fg }
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
        { provider = "▎", hl = { fg = colors.accent } },
        Space,
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
        { provider = "▎", hl = { fg = colors.accent } },
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

      -- Hide statusline on startup page
      vim.api.nvim_create_autocmd("BufEnter", {
        callback = function()
          vim.opt.laststatus = (vim.fn.bufname() == "" or vim.bo.buftype == "alpha") and 0 or 2
        end,
      })
    end,
  },
}