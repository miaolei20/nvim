-- 设置键映射选项：不递归和静默
local opt = { noremap = true, silent = true }

-- 设置leader键为空格
vim.g.mapleader = " "

-- 窗口导航快捷键映射
vim.keymap.set("n", "<C-l>", "<C-w>l", opt)  -- Ctrl+l 切换到右侧窗口
vim.keymap.set("n", "<C-h>", "<C-w>h", opt)  -- Ctrl+h 切换到左侧窗口
vim.keymap.set("n", "<C-j>", "<C-w>j", opt)  -- Ctrl+j 切换到下方窗口
vim.keymap.set("n", "<C-k>", "<C-w>k", opt)  -- Ctrl+k 切换到上方窗口

-- 分屏快捷键映射
vim.keymap.set("n", "<Leader>v", "<C-w>v", opt)  -- Leader+v 垂直分屏
vim.keymap.set("n", "<Leader>s", "<C-w>s", opt)  -- Leader+s 水平分屏

-- 跳转历史记录快捷键映射
vim.keymap.set("n", "<Leader>[", "<C-o>", opt)  -- Leader+[ 跳转到上一个位置
vim.keymap.set("n", "<Leader>]", "<C-i>", opt)  -- Leader+] 跳转到下一个位置

-- 改进的上下移动快捷键映射，避免长行折行问题
vim.keymap.set("n", "j", [[v:count ? 'j' : 'gj']], { noremap = true, expr = true })  -- j 键
vim.keymap.set("n", "k", [[v:count ? 'k' : 'gk']], { noremap = true, expr = true })  -- k 键

-- 动态调整窗口大小的函数
local function dynamic_resize(direction)
  local step = vim.v.count1  -- 支持数字前缀
  local cmd_map = {
    h = string.format("vertical resize -%d", step),  -- 向左调整
    l = string.format("vertical resize +%d", step),  -- 向右调整
    j = string.format("resize +%d", step),  -- 向下调整
    k = string.format("resize -%d", step)   -- 向上调整
  }
  vim.cmd(cmd_map[direction])
end

-- 动态调整窗口大小的快捷键映射（支持数字加速）
vim.keymap.set("n", "<M-h>", function() dynamic_resize("h") end)  -- Alt+h 向左调整
vim.keymap.set("n", "<M-l>", function() dynamic_resize("l") end)  -- Alt+l 向右调整
vim.keymap.set("n", "<M-j>", function() dynamic_resize("j") end)  -- Alt+j 向下调整
vim.keymap.set("n", "<M-k>", function() dynamic_resize("k") end)  -- Alt+k 向上调整

-- 定义快捷键映射函数和选项
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- LSP相关快捷键映射
map("n", "<leader>lf", "<cmd>Format<cr>", opts)  -- Leader+lf 格式化代码
map("n", "gd", vim.lsp.buf.definition, opts)  -- gd 跳转到定义
map("n", "K", vim.lsp.buf.hover, opts)  -- K 显示悬停信息
