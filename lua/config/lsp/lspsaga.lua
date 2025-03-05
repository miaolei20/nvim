local lspsaga = require("lspsaga")
local keymaps = require("config.lsp.keymaps")

lspsaga.setup({
  symbol_in_winbar = {
    enable = true,
    show_file = true,
    separator = keymaps.icons.symbol.Separator,
    hide_keyword = true,
    color_mode = true,
    file_formatter = function(path)
      local sep = package.config:sub(1, 1)
      local parts = vim.split(path, sep)
      return #parts > 2 and table.concat({ "...", parts[#parts - 1], parts[#parts] }, sep) or path
    end,
  },
  lightbulb = {
    enable = false,
    sign = keymaps.icons.code_action,
    virtual_text = false,
    sign_priority = 20,
  },
  diagnostic = {
    show_code_action = true,
    show_source = true,
    jump_num_shortcut = true,
    diagnostic_prefix = keymaps.icons.diagnostics,
  },
  finder = {
    default = "def+ref+imp",
    keys = {
      shuttle = "<leader>sf",
      toggle_or_open = "o",
      vsplit = "v",
      split = "s",
      tabe = "t",
      quit = "q",
    },
    layout = "float",
    title = " 🕵️ LSP Finder ",
    force_max_height = true,
    max_height = 0.6,
  },
})
