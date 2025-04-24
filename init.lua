-- Set global settings before plugins
vim.g.mapleader = " " -- Space as leader
vim.g.maplocalleader = "\\" -- Backslash as localleader
vim.g.python3_host_prog = vim.fn.executable("/usr/bin/python3") and "/usr/bin/python3" or nil -- Validate Python path

-- Load core configuration with error handling
local ok, _ = pcall(require, "config.options") -- Editor options (e.g., tabstop, mouse)
if not ok then
  vim.notify("Failed to load config.options", vim.log.levels.WARN)
end
ok, _ = pcall(require, "config.keymaps") -- Custom keymaps (e.g., <leader>ff, <C-h>)
if not ok then
  vim.notify("Failed to load config.keymaps", vim.log.levels.WARN)
end

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.notify("Failed to clone lazy.nvim:\n" .. out, vim.log.levels.ERROR)
    vim.fn.input("Press Enter to exit...")
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {

    -- Theme and UI
    { import = "plugins.UI.onedark" }, -- onedarkpro theme
    { import = "plugins.UI.heirline" }, -- Statusline and tabline
    { import = "plugins.UI.alpha" }, -- Dashboard
    { import = "plugins.UI.neotree" }, -- File explorer
    { import = "plugins.UI.rainbow" }, -- Rainbow brackets
    { import = "plugins.UI.aerial" }, -- Code outline
    { import = "plugins.UI.indent" }, -- Indentation guides

    -- Editor enhancements
    { import = "plugins.editor.treesitter" }, -- Syntax highlighting
    { import = "plugins.editor.treesitter-context" }, -- Context-aware code
    -- { import = "plugins.editor.blink" }, -- Completion engine
    { import = "plugins.editor.cmp"},
    { import = "plugins.editor.comment" }, -- Commenting
    { import = "plugins.editor.gitsigns" },
    { import = "plugins.editor.hlslens" },
    { import = "plugins.editor.scrollbar" },
    { import = "plugins.editor.visual-multi" },

    -- LSP and code tools
    { import = "plugins.lsp.mason" }, -- LSP installer
    { import = "plugins.lsp.lsp" }, -- LSP configuration
    { import = "plugins.tools.formatter" },
    { import = "plugins.editor.lint" },

    -- Navigation and search
    { import = "plugins.tools.telescope" }, -- Fuzzy finder
    { import = "plugins.tools.harpoon" }, -- File bookmarks

    -- Git integration
    { import = "plugins.tools.lazygit" }, -- Git UI

    -- Productivity and utilities
    { import = "plugins.tools.which-key" }, -- Keybinding hints
    { import = "plugins.tools.lastplace" }, -- Restore cursor position
    { import = "plugins.tools.copilot" }, -- GitHub Copilot
    { import = "plugins.tools.leetcode" }, -- LeetCode integration
  },
  install = {
    colorscheme = { "onedark", "habamax" }, -- Prefer onedarkpro
  },
  checker = {
    enabled = true, -- Auto-check updates
    notify = false, -- Silent updates
    frequency = 259200, -- Check every 3 days
  },
  performance = {
    cache = { enabled = true }, -- Faster startup
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
        "spellfile",
      }, -- Disable unused built-ins
    },
  },
  ui = {
    border = "rounded", -- VSCode-like rounded borders
    title = "Lazy", -- Minimal Lazy UI title
    pills = true, -- Modern UI tabs
  },
  diff = {
    cmd = "diffview.nvim", -- Support diffview.nvim
  },
  profiling = {
    loader = false, -- Disable loader profiling by default
    require = false, -- Disable require profiling
  },
})
