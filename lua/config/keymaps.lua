-- Leader key
vim.g.mapleader = " "

-- Keymap options
local opts = { noremap = true, silent = true }

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", opts)
vim.keymap.set("n", "<C-j>", "<C-w>j", opts)
vim.keymap.set("n", "<C-k>", "<C-w>k", opts)
vim.keymap.set("n", "<C-l>", "<C-w>l", opts)

-- Window splitting
vim.keymap.set("n", "<leader>vv", "<C-w>v", opts) -- Vertical split
vim.keymap.set("n", "<leader>ss", "<C-w>s", opts) -- Horizontal split

-- Jump history
vim.keymap.set("n", "<leader>[", "<C-o>", opts) -- Previous location
vim.keymap.set("n", "<leader>]", "<C-i>", opts) -- Next location

-- Improved movement (handles wrapped lines)
vim.keymap.set("n", "j", [[v:count ? 'j' : 'gj']], { noremap = true, expr = true })
vim.keymap.set("n", "k", [[v:count ? 'k' : 'gk']], { noremap = true, expr = true })

-- Dynamic window resizing
local function resize(direction)
  local step = vim.v.count1
  local cmds = {
    h = "vertical resize -" .. step,
    l = "vertical resize +" .. step,
    j = "resize +" .. step,
    k = "resize -" .. step,
  }
  vim.cmd(cmds[direction])
end

vim.keymap.set("n", "<M-h>", function() resize("h") end, opts)
vim.keymap.set("n", "<M-j>", function() resize("j") end, opts)
vim.keymap.set("n", "<M-k>", function() resize("k") end, opts)
vim.keymap.set("n", "<M-l>", function() resize("l") end, opts)
