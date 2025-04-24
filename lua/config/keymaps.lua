local M = {}

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Keymap options
local opts = { noremap = true, silent = true }

-- Debug logging
local function debug_log(msg)
  vim.notify("[Keymaps] " .. msg, vim.log.levels.DEBUG)
end

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", vim.tbl_extend("force", opts, { desc = "Move to Left Window" }))
vim.keymap.set("n", "<C-j>", "<C-w>j", vim.tbl_extend("force", opts, { desc = "Move to Lower Window" }))
vim.keymap.set("n", "<C-k>", "<C-w>k", vim.tbl_extend("force", opts, { desc = "Move to Upper Window" }))
vim.keymap.set("n", "<C-l>", "<C-w>l", vim.tbl_extend("force", opts, { desc = "Move to Right Window" }))

-- Dynamic window resizing
local function resize(direction)
  local step = vim.v.count1 * 2
  local win = vim.api.nvim_get_current_win()
  local actions = {
    h = function() vim.api.nvim_win_set_width(win, vim.api.nvim_win_get_width(win) - step) end,
    l = function() vim.api.nvim_win_set_width(win, vim.api.nvim_win_get_width(win) + step) end,
    j = function() vim.api.nvim_win_set_height(win, vim.api.nvim_win_get_height(win) + step) end,
    k = function() vim.api.nvim_win_set_height(win, vim.api.nvim_win_get_height(win) - step) end,
  }
  if actions[direction] then
    actions[direction]()
  else
    vim.notify("Invalid resize direction: " .. tostring(direction), vim.log.levels.WARN)
  end
end

-- Define keymaps
local window_keymaps = {
  { lhs = "<leader>wv", rhs = "<C-w>v", desc = "Split Vertically", icon = "🪓" },
  { lhs = "<leader>ws", rhs = "<C-w>s", desc = "Split Horizontally", icon = "🪚" },
  { lhs = "<leader>wh", rhs = function() resize("h") end, desc = "Resize Left", icon = "⬅️" },
  { lhs = "<leader>wj", rhs = function() resize("j") end, desc = "Resize Down", icon = "⬇️" },
  { lhs = "<leader>wk", rhs = function() resize("k") end, desc = "Resize Up", icon = "⬆️" },
  { lhs = "<leader>wl", rhs = function() resize("l") end, desc = "Resize Right", icon = "➡️" },
  { lhs = "<leader>w[", rhs = "<C-o>", desc = "Previous Location", icon = "⏮️" },
  { lhs = "<leader>w]", rhs = "<C-i>", desc = "Next Location", icon = "⏭️" },
}

-- Setup keymaps
local function setup_keymaps()
  debug_log("Setting up keymaps")
  -- Register fallback keymaps
  for _, km in ipairs(window_keymaps) do
    vim.keymap.set("n", km.lhs, km.rhs, vim.tbl_extend("force", opts, { desc = km.desc }))
    debug_log("Registered fallback keymap: " .. km.lhs)
  end

  -- Register with which-key
  local ok, wk = pcall(require, "which-key")
  if not ok then
    vim.notify("which-key not found, using fallback keymaps only", vim.log.levels.WARN)
    return
  end

  local wk_mappings = {
    { "<leader>w", group = "Window", icon = "🪟" },
  }
  for _, km in ipairs(window_keymaps) do
    table.insert(wk_mappings, {
      km.lhs,
      km.rhs,
      desc = km.desc,
      mode = "n",
      icon = km.icon,
    })
  end

  local success, err = pcall(function()
    wk.add(wk_mappings)
  end)
  if success then
    debug_log("Which-key keymaps registered successfully")
  else
    vim.notify("Which-key setup failed: " .. tostring(err), vim.log.levels.ERROR)
  end
end

-- Improved movement for wrapped lines
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { noremap = true, silent = true, expr = true, desc = "Move Down" })
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { noremap = true, silent = true, expr = true, desc = "Move Up" })

-- Initialize on VimEnter
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    debug_log("Initializing keymaps module")
    setup_keymaps()
  end,
  once = true,
})


return M