local M = {}

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Keymap options
local opts = { noremap = true, silent = true }

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", vim.tbl_extend("force", opts, { desc = "Move to Left Window" }))
vim.keymap.set("n", "<C-j>", "<C-w>j", vim.tbl_extend("force", opts, { desc = "Move to Lower Window" }))
vim.keymap.set("n", "<C-k>", "<C-w>k", vim.tbl_extend("force", opts, { desc = "Move to Upper Window" }))
vim.keymap.set("n", "<C-l>", "<C-w>l", vim.tbl_extend("force", opts, { desc = "Move to Right Window" }))

-- Dynamic window resizing
local function resize(direction)
  local step = vim.v.count1 * 2 -- Scale step for faster resizing
  local win = vim.api.nvim_get_current_win()
  if direction == "h" then
    vim.api.nvim_win_set_width(win, vim.api.nvim_win_get_width(win) - step)
  elseif direction == "l" then
    vim.api.nvim_win_set_width(win, vim.api.nvim_win_get_width(win) + step)
  elseif direction == "j" then
    vim.api.nvim_win_set_height(win, vim.api.nvim_win_get_height(win) + step)
  elseif direction == "k" then
    vim.api.nvim_win_set_height(win, vim.api.nvim_win_get_height(win) - step)
  end
end

-- Setup keymaps with which-key
local function setup_keymaps()
  local wk = require("which-key")
  wk.add({
    { "<leader>w", group = "Window", icon = "🪟" },
    { "<leader>wv", "<C-w>v", desc = "Split Vertically", mode = "n", icon = "🪓" },
    { "<leader>ws", "<C-w>s", desc = "Split Horizontally", mode = "n", icon = "🪚" },
    { "<leader>wh", function() resize("h") end, desc = "Resize Left", mode = "n", icon = "⬅️" },
    { "<leader>wj", function() resize("j") end, desc = "Resize Down", mode = "n", icon = "⬇️" },
    { "<leader>wk", function() resize("k") end, desc = "Resize Up", mode = "n", icon = "⬆️" },
    { "<leader>wl", function() resize("l") end, desc = "Resize Right", mode = "n", icon = "➡️" },
    { "<leader>w[", "<C-o>", desc = "Previous Location", mode = "n", icon = "⏮️" },
    { "<leader>w]", "<C-i>", desc = "Next Location", mode = "n", icon = "⏭️" },
  })
end

-- Improved movement for wrapped lines
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { noremap = true, silent = true, expr = true, desc = "Move Down" })
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { noremap = true, silent = true, expr = true, desc = "Move Up" })

-- Initialize
function M.setup()
  setup_keymaps()
end

return M