-- Set global settings before plugins
vim.g.mapleader = " " -- Space as leader
vim.g.maplocalleader = "\\" -- Backslash as localleader
vim.g.python3_host_prog = vim.fn.executable('/usr/bin/python3') and '/usr/bin/python3' or nil -- Validate Python 3 path

-- Load core configuration
require("config.options") -- Editor options (e.g., tabstop, mouse)
require("config.keymaps") -- Custom keymaps (e.g., <leader>ff, <C-h>)

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- Performance optimization
    { import = "plugins.tools.impatient" }, -- Speed up startup

    -- Theme and UI
    { import = "plugins.UI.onedark" }, -- onedarkpro theme (priority)
    { import = "plugins.UI.alpha" }, -- Dashboard
    { import = "plugins.UI.heirline" }, -- Statusline and tabline
    { import = "plugins.UI.neotree" }, -- File explorer
    { import = "plugins.UI.rainbow" }, -- Rainbow brackets
    { import = "plugins.UI.aerial" }, -- Code outline
    { import = "plugins.UI.notify" }, -- Notifications
    { import = "plugins.UI.indent" }, -- Indentation guides

    -- Editor enhancements
    { import = "plugins.editor.treesitter" }, -- Syntax highlighting
    { import = "plugins.editor.treesitter-context" }, -- Context-aware code
    { import = "plugins.editor.autopairs" }, -- Auto-close brackets
    { import = "plugins.editor.blink" }, -- Completion engine
    { import = "plugins.editor.comment" }, -- Commenting
    { import = "plugins.editor.search" }, -- Search, gitsigns, cursors
    { import = "plugins.editor.guess"}, -- Guess indentation

    -- LSP and code tools
    { import = "plugins.lsp.mason" }, -- LSP installer
    { import = "plugins.lsp.lsp" }, -- LSP configuration

    -- Navigation and search
    { import = "plugins.tools.telescope" }, -- Fuzzy finder

    -- Git and debugging
    { import = "plugins.tools.lazygit" }, -- Git integration

    -- Productivity tools
    { import = "plugins.tools.leetcode" }, -- LeetCode
    { import = "plugins.tools.which-key" }, -- Keybinding hints
    { import = "plugins.tools.lastplace" }, -- Restore cursor position
    { import = "plugins.tools.copilot" }, -- GitHub Copilot
  },
  install = {
    colorscheme = { "onedark", "habamax" }, -- Prefer onedarkpro, fallback to habamax
  },
  checker = {
    enabled = true, -- Auto-check updates
    notify = false, -- Silent updates
    frequency = 86400, -- Check daily
  },
  performance = {
    cache = { enabled = true }, -- Cache for faster startup
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrw",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      }, -- Disable unused built-ins
    },
  },
  ui = {
    border = "rounded", -- Match onedarkpro’s VSCode-like style
  },
})
