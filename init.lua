-- Set global settings before loading plugins
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.python3_host_prog = '/usr/bin/python3' -- Set Python 3 host program

-- Load configuration options and keymaps
require("config.options")
require("config.keymaps")

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
    -- Base and performance optimization
    { import = "plugins.tools.impatient" }, -- Performance optimization plugin first

    -- Theme and visual base
    { import = "plugins.UI.onedark" }, -- Theme loaded first

    -- Editor enhancements
    { import = "plugins.editor.treesitter" },         -- Syntax highlighting
    { import = "plugins.editor.treesitter-context" }, -- Depends on treesitter
    { import = "plugins.editor.autopairs" },          -- Auto pairs
    { import = "plugins.editor.blink" },              -- Completion (replacing cmp)
    { import = "plugins.editor.comment" },            -- Commenting
    { import = "plugins.editor.search" },             -- Search, gitsigns, multiple cursors

    -- LSP and code tools
    { import = "plugins.lsp.mason" },    -- LSP package manager
    { import = "plugins.lsp.lsp" },      -- LSP core

    -- Core UI components
    { import = "plugins.UI.alpha" },      -- Dashboard
    { import = "plugins.UI.lualine" },    -- Statusline and tabline
    { import = "plugins.UI.nvimtree" },   -- File tree
    { import = "plugins.UI.rainbow" },    -- Rainbow brackets
    { import = "plugins.UI.aerial" },     -- Code outline
    { import = "plugins.UI.notify" },     -- Notifications
    { import = "plugins.UI.indent" },     -- Indentation guides

    -- Navigation and search
    { import = "plugins.tools.telescope" },    -- Fuzzy finder

    -- Debugging and tools
    { import = "plugins.tools.lazygit" }, -- Git integration
    { import = "plugins.tools.leetcode" }, -- LeetCode plugin

    -- Utilities
    { import = "plugins.tools.which-key" }, -- Keybinding hints
    { import = "plugins.tools.lastplace" }, -- Restore last position
    { import = "plugins.tools.copilot" },   -- GitHub Copilot
  },
  -- Configure Lazy.nvim settings
  install = { colorscheme = { "habamax" } }, -- Colorscheme for plugin installation
  checker = { enabled = true },              -- Automatically check for updates
  performance = {
    rtp = {
      disabled_plugins = {
        "netrw", "netrwPlugin", "netrwSettings", "netrwFileHandlers"
      },
    },
  },
})