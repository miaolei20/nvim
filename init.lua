-- Global settings
vim.g.mapleader = " "       -- Set leader key to space
vim.g.maplocalleader = "\\" -- Set local leader key to backslash
vim.g.python3_host_prog = vim.fn.executable("/usr/bin/python3") and "/usr/bin/python3" or nil

-- Load core configs and handle errors
for _, module in ipairs({ "config.options", "config.keymaps" }) do
  local ok, err = pcall(require, module)
  if not ok then
    vim.notify(string.format("Failed to load %s: %s", module, err), vim.log.levels.WARN)
  end
end

-- Install lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath
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
    { import = "plugins.UI.theme" },
    { import = "plugins.UI.heirline" },
    { import = "plugins.UI.alpha" },
    { import = "plugins.UI.neotree" },
    { import = "plugins.UI.rainbow" },
    { import = "plugins.UI.indent" },
    { import = "plugins.UI.ui" },
    { import = "plugins.editor.treesitter" },
    { import = "plugins.editor.treesitter-context" },
    { import = "plugins.editor.cmp" },
    { import = "plugins.editor.comment" },
    { import = "plugins.editor.gitsigns" },
    { import = "plugins.editor.avante" },
    { import = "plugins.lsp.mason" },
    { import = "plugins.lsp.lsp" },
    { import = "plugins.tools.formatter" },
    { import = "plugins.editor.lint" },
    { import = "plugins.tools.telescope" },
    { import = "plugins.tools.lastplace" },
    { import = "plugins.tools.surround" },
    -- { import = "plugins/__disabled/leetcode" },
    { import = "plugins/__disabled/markdown-preview" },

  },
  install = {
    colorscheme = {
      "onedark", "catppuccin", "catppuccin-latte",
      "tokyonight", "gruvbox", "habamax"
    }
  },
  checker = {
    enabled = true,
    notify = false,
    frequency = 259200, -- Check for updates every 3 days
  },
  performance = {
    cache = { enabled = true },
    reset_packpath = false,
    rtp = {
      disabled_plugins = {
        "gzip", "matchit", "matchparen", "netrw", "netrwPlugin",
        "tarPlugin", "tohtml", "tutor", "zipPlugin", "rplugin",
        "editorconfig", "spellfile"
      }
    }
  },
  ui = {
    border = "rounded",
    title = "Lazy",
    pills = true
  },
  diff = { cmd = "diffview.nvim" },
  profiling = {
    loader = false,
    require = false
  }
})

pcall(dofile, vim.fn.stdpath("config") .. "/lua/theme_persist.lua")
