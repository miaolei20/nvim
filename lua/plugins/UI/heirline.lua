return {
  "rebelot/heirline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local heirline = require("heirline")
    local devicons = require("nvim-web-devicons")

    -- Define color palettes for different themes
    local function get_color_palette()
      local theme = vim.g.colors_name or ""
      theme = theme:lower()
      if theme:match("catppuccin") then
        return {
          bg = "#1e1e2e",
          fg = "#cdd6f4",
          red = "#f38ba8",
          green = "#a6e3a1",
          blue = "#89b4fa",
          yellow = "#f9e2af",
          orange = "#fab387",
          purple = "#cba6f7",
          gray = "#585b70",
        }
      elseif theme:match("tokyonight") then
        return {
          bg = "#1a1b26",
          fg = "#a9b1d6",
          red = "#f7768e",
          green = "#9ece6a",
          blue = "#7aa2f7",
          yellow = "#e0af68",
          orange = "#ff9e64",
          purple = "#9d7cd8",
          gray = "#444b6a",
        }
      else
        -- Default palette
        return {
          bg = "#2e3440",
          fg = "#d8dee9",
          red = "#bf616a",
          green = "#a3be8c",
          blue = "#81a1c1",
          yellow = "#ebcb8b",
          orange = "#d08770",
          purple = "#b48ead",
          gray = "#4c566a",
        }
      end
    end

    local colors = get_color_palette()

    -- Setup highlight groups using nvim_set_hl
    vim.api.nvim_set_hl(0, "HeirlineModeNormal",   { fg = colors.blue,   bg = colors.bg, bold = true })
    vim.api.nvim_set_hl(0, "HeirlineModeInsert",   { fg = colors.green,  bg = colors.bg, bold = true })
    vim.api.nvim_set_hl(0, "HeirlineModeVisual",   { fg = colors.purple, bg = colors.bg, bold = true })
    vim.api.nvim_set_hl(0, "HeirlineModeReplace",  { fg = colors.red,    bg = colors.bg, bold = true })
    vim.api.nvim_set_hl(0, "HeirlineModeCommand",  { fg = colors.orange, bg = colors.bg, bold = true })

    vim.api.nvim_set_hl(0, "HeirlineFileName",     { fg = colors.yellow, bg = colors.bg })
    vim.api.nvim_set_hl(0, "HeirlineBranch",       { fg = colors.purple, bg = colors.bg })

    vim.api.nvim_set_hl(0, "HeirlineDiffAdd",      { fg = colors.green,  bg = colors.bg })
    vim.api.nvim_set_hl(0, "HeirlineDiffChange",   { fg = colors.blue,   bg = colors.bg })
    vim.api.nvim_set_hl(0, "HeirlineDiffDelete",   { fg = colors.red,    bg = colors.bg })

    vim.api.nvim_set_hl(0, "HeirlineDiagnosticError",   { fg = colors.red,    bg = colors.bg })
    vim.api.nvim_set_hl(0, "HeirlineDiagnosticWarn",    { fg = colors.yellow, bg = colors.bg })
    vim.api.nvim_set_hl(0, "HeirlineDiagnosticInfo",    { fg = colors.blue,   bg = colors.bg })
    vim.api.nvim_set_hl(0, "HeirlineDiagnosticHint",    { fg = colors.gray,   bg = colors.bg })

    vim.api.nvim_set_hl(0, "HeirlineLSP",         { fg = colors.orange, bg = colors.bg })

    vim.api.nvim_set_hl(0, "HeirlineTabSelected", { fg = colors.fg, bg = colors.blue, bold = true })
    vim.api.nvim_set_hl(0, "HeirlineTabNormal",   { fg = colors.gray, bg = colors.bg })
    vim.api.nvim_set_hl(0, "HeirlineTabFill",     { fg = colors.bg,   bg = colors.bg })

    -- Mode component
    local Mode = {
      init = function(self) self.mode = vim.fn.mode(1) end,
      static = {
        mode_names = {
          n = "NORMAL", i = "INSERT", v = "VISUAL",
          V = "V-LINE", ["\22"] = "V-BLOCK",
          R = "REPLACE", c = "COMMAND", s = "SELECT",
          S = "S-LINE", [""] = "S-BLOCK", t = "TERMINAL"
        },
      },
      provider = function(self)
        local name = self.mode_names[self.mode] or self.mode
        return " " .. name .. " "
      end,
      hl = function(self)
        local m = self.mode
        if m == "n" then
          return "HeirlineModeNormal"
        elseif m == "i" then
          return "HeirlineModeInsert"
        elseif m == "v" or m == "V" or m == "\22" then
          return "HeirlineModeVisual"
        elseif m == "R" or m == "Rv" then
          return "HeirlineModeReplace"
        elseif m == "c" then
          return "HeirlineModeCommand"
        else
          return "HeirlineModeNormal"
        end
      end,
    }

    -- FileName component with devicons
    local FileName = {
      provider = function()
        local filename = vim.api.nvim_buf_get_name(0)
        filename = vim.fn.fnamemodify(filename, ":t")
        if filename == "" then
          return "[No Name]"
        end
        local icon, icon_highlight = devicons.get_icon(
          vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t"),
          vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":e"),
          { default = true }
        )
        if icon then
          return icon .. " " .. filename .. " "
        else
          return filename .. " "
        end
      end,
      hl = "HeirlineFileName",
    }

    -- GitBranch component
    local GitBranch = {
      condition = function()
        return vim.b.gitsigns_head or (vim.fn.exists("*FugitiveHead") == 1)
      end,
      provider = function()
        local branch = vim.b.gitsigns_head
        if not branch then
          local ok, res = pcall(vim.fn.FugitiveHead)
          if ok then branch = res end
        end
        return branch and (" " .. branch .. " ") or ""
      end,
      hl = "HeirlineBranch",
    }

    -- GitDiff component (using gitsigns data)
    local GitDiff = {
      condition = function() return vim.b.gitsigns_status_dict ~= nil end,
      init = function(self)
        local status = vim.b.gitsigns_status_dict
        self.added = status.added or 0
        self.changed = status.changed or 0
        self.removed = status.removed or 0
      end,
      {
        provider = function(self)
          return (self.added > 0) and ("+" .. self.added .. " ") or ""
        end,
        hl = "HeirlineDiffAdd",
      },
      {
        provider = function(self)
          return (self.changed > 0) and ("~" .. self.changed .. " ") or ""
        end,
        hl = "HeirlineDiffChange",
      },
      {
        provider = function(self)
          return (self.removed > 0) and ("-" .. self.removed .. " ") or ""
        end,
        hl = "HeirlineDiffDelete",
      },
    }

    -- Diagnostics component
    local Diagnostics = {
      condition = function() return next(vim.diagnostic.get(0)) ~= nil end,
      init = function(self)
        local errs = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
        local warns = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
        local infos = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
        local hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
        self.errors = errs
        self.warnings = warns
        self.info = infos
        self.hints = hints
      end,
      update = { "DiagnosticChanged", "BufEnter", "BufWritePost" },
      {
        provider = function(self)
          return (self.errors > 0) and (" " .. self.errors .. " ") or ""
        end,
        hl = "HeirlineDiagnosticError",
      },
      {
        provider = function(self)
          return (self.warnings > 0) and (" " .. self.warnings .. " ") or ""
        end,
        hl = "HeirlineDiagnosticWarn",
      },
      {
        provider = function(self)
          return (self.info > 0) and (" " .. self.info .. " ") or ""
        end,
        hl = "HeirlineDiagnosticInfo",
      },
      {
        provider = function(self)
          return (self.hints > 0) and (" " .. self.hints .. " ") or ""
        end,
        hl = "HeirlineDiagnosticHint",
      },
    }

    -- LSP client names component
    local LSP = {
      condition = function() return #vim.lsp.get_clients({ bufnr = 0 }) > 0 end,
      provider = function()
        local names = {}
        for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
          table.insert(names, client.name)
        end
        local s = table.concat(names, ", ")
        return s ~= "" and (" " .. s) or ""
      end,
      hl = "HeirlineLSP",
    }

    -- Ruler component (line:col and percentage)
    local Ruler = {
      provider = function()
        local line = vim.fn.line(".")
        local col = vim.fn.col(".")
        local total = vim.fn.line("$")
        local pct = math.floor((line / total) * 100)
        return string.format(" %d:%d (%d%%%%)", line, col, pct)
      end,
    }

    -- Alignment spacer
    local Align = { provider = "%=" }
    local Space = { provider = " " }

    -- Assemble statusline components
    local StatusLine = {
      Mode,
      Space,
      FileName,
      Space,
      GitBranch,
      GitDiff,
      Space,
      Diagnostics,
      Align,
      LSP,
      Space,
      Ruler,
    }

    -- WinBar components (show path and file name)
    local WinBarPath = {
      provider = function()
        local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":~:.:h")
        return path ~= "" and (path .. "/") or ""
      end,
      hl = { fg = colors.gray },
    }
    local WinBarFile = {
      provider = function()
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t")
        if filename == "" then return "" end
        local icon, _ = devicons.get_icon(filename, vim.fn.fnamemodify(filename, ":e"), { default = true })
        return (icon and (icon .. " ") or "") .. filename
      end,
      hl = "HeirlineFileName",
    }
    local WinBar = {
      condition = function() return vim.api.nvim_buf_get_name(0) ~= "" end,
      WinBarPath,
      WinBarFile,
    }

    -- TabLine: show tab pages
    local TabLine = {
      condition = function() return #vim.api.nvim_list_tabpages() > 1 end,
      init = function(self) self.tabs = vim.api.nvim_list_tabpages() end,
      provider = function(self)
        local s = ""
        for _, tab in ipairs(self.tabs) do
          local tabnr = vim.api.nvim_tabpage_get_number(tab)
          if tab == vim.api.nvim_get_current_tabpage() then
            s = s .. "%#HeirlineTabSelected# TAB" .. tabnr .. " %#HeirlineTabFill#"
          else
            s = s .. "%#HeirlineTabNormal# TAB" .. tabnr .. " %#HeirlineTabFill#"
          end
        end
        return s
      end,
      on_click = {
        callback = function(self, minwid)
          vim.api.nvim_set_current_tabpage(minwid)
        end,
        name = "heirline_tabline_tab_callback",
      },
    }

    -- Setup heirline
    heirline.setup({
      statusline = StatusLine,
      winbar = WinBar,
      tabline = TabLine,
    })

    -- Reapply highlight groups on ColorScheme change
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("HeirlineColors", { clear = true }),
      callback = function()
        colors = get_color_palette()
        vim.api.nvim_set_hl(0, "HeirlineModeNormal",   { fg = colors.blue,   bg = colors.bg, bold = true })
        vim.api.nvim_set_hl(0, "HeirlineModeInsert",   { fg = colors.green,  bg = colors.bg, bold = true })
        vim.api.nvim_set_hl(0, "HeirlineModeVisual",   { fg = colors.purple, bg = colors.bg, bold = true })
        vim.api.nvim_set_hl(0, "HeirlineModeReplace",  { fg = colors.red,    bg = colors.bg, bold = true })
        vim.api.nvim_set_hl(0, "HeirlineModeCommand",  { fg = colors.orange, bg = colors.bg, bold = true })
        vim.api.nvim_set_hl(0, "HeirlineFileName",     { fg = colors.yellow, bg = colors.bg })
        vim.api.nvim_set_hl(0, "HeirlineBranch",       { fg = colors.purple, bg = colors.bg })
        vim.api.nvim_set_hl(0, "HeirlineDiffAdd",      { fg = colors.green,  bg = colors.bg })
        vim.api.nvim_set_hl(0, "HeirlineDiffChange",   { fg = colors.blue,   bg = colors.bg })
        vim.api.nvim_set_hl(0, "HeirlineDiffDelete",   { fg = colors.red,    bg = colors.bg })
        vim.api.nvim_set_hl(0, "HeirlineDiagnosticError",   { fg = colors.red,    bg = colors.bg })
        vim.api.nvim_set_hl(0, "HeirlineDiagnosticWarn",    { fg = colors.yellow, bg = colors.bg })
        vim.api.nvim_set_hl(0, "HeirlineDiagnosticInfo",    { fg = colors.blue,   bg = colors.bg })
        vim.api.nvim_set_hl(0, "HeirlineDiagnosticHint",    { fg = colors.gray,   bg = colors.bg })
        vim.api.nvim_set_hl(0, "HeirlineLSP",         { fg = colors.orange, bg = colors.bg })
        vim.api.nvim_set_hl(0, "HeirlineTabSelected", { fg = colors.fg, bg = colors.blue, bold = true })
        vim.api.nvim_set_hl(0, "HeirlineTabNormal",   { fg = colors.gray, bg = colors.bg })
        vim.api.nvim_set_hl(0, "HeirlineTabFill",     { fg = colors.bg,   bg = colors.bg })
      end,
    })
  end,
}
