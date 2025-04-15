-- Set global settings before plugins
vim.g.mapleader = " " -- Space as leader
vim.g.maplocalleader = "\\" -- Backslash as localleader
vim.g.python3_host_prog = vim.fn.executable('/usr/bin/python3') and '/usr/bin/python3' or nil -- Validate Python 3 path

-- Load core configuration
pcall(require, "config.options") -- Editor options (e.g., tabstop, mouse)
pcall(require, "config.keymaps") -- Custom keymaps (e.g., <leader>ff, <C-h>)

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.notify("Failed to clone lazy.nvim", vim.log.levels.ERROR)
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- Performance optimization
    { import = "plugins.tools.impatient" }, -- Startup optimization

    -- Theme and UI components
    { import = "plugins.UI.onedark" }, -- onedarkpro theme
    { import = "plugins.UI.heirline" }, -- Statusline and tabline
    { import = "plugins.UI.alpha" }, -- Dashboard
    { import = "plugins.UI.neotree" }, -- File explorer
    { import = "plugins.UI.notify" }, -- Notifications
    { import = "plugins.UI.rainbow" }, -- Rainbow brackets
    { import = "plugins.UI.aerial" }, -- Code outline
    { import = "plugins.UI.indent" }, -- Indentation guides

    -- Editor enhancements
    { import = "plugins.editor.treesitter" }, -- Syntax highlighting
    { import = "plugins.editor.treesitter-context" }, -- Context-aware code
    { import = "plugins.editor.autopairs" }, -- Auto-close brackets
    { import = "plugins.editor.blink" }, -- Completion engine
    { import = "plugins.editor.comment" }, -- Commenting
    { import = "plugins.editor.search" }, -- Search, gitsigns, cursors

    -- LSP and code tools
    { import = "plugins.lsp.mason" }, -- LSP installer
    { import = "plugins.lsp.lsp" }, -- LSP configuration

    -- Navigation and search
    { import = "plugins.tools.telescope" }, -- Fuzzy finder
    { import = "plugins.tools.harpoon" }, -- File bookmarks
    { import = "plugins.tools.spectre" }, -- Search and replace

    -- Git integration
    { import = "plugins.tools.lazygit" }, -- Git UI

    -- Productivity and utilities
    { import = "plugins.tools.which-key" }, -- Keybinding hints
    { import = "plugins.tools.lastplace" }, -- Restore cursor position
    { import = "plugins.tools.copilot" }, -- GitHub Copilot
    { import = "plugins.tools.leetcode" }, -- LeetCode integration
  },
  install = {
    colorscheme = { "onedark", "habamax" }, -- Prefer onedarkpro, fallback to habamax
  },
  checker = {
    enabled = true, -- Auto-check for updates
    notify = false, -- Silent updates
    frequency = 172800, -- Check every 2 days
  },
  performance = {
    cache = { enabled = true }, -- Cache for faster startup
    reset_packpath = false, -- Optimize packpath
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
        "rplugin",
        "editorconfig",
      }, -- Disable unused built-ins
    },
  },
  ui = {
    border = "rounded", -- VSCode-like rounded borders
    title = " Lazy ", -- Custom title for Lazy UI
  },
  diff = {
    cmd = "diffview.nvim", -- Use diffview.nvim if installed
  },
})
