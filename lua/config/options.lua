-- 显示行号
vim.opt.number = true
-- 显示相对行号
vim.opt.relativenumber = true
-- 将 Tab 转换为空格
vim.opt.expandtab = true
-- Tab 显示为 4 空格
vim.opt.tabstop = 4
-- 自动缩进时每级缩进 4 空格
vim.opt.shiftwidth = 4
-- 智能缩进
vim.opt.smartindent = true
-- 启用终端真彩色
vim.opt.termguicolors = true
-- 忽略大小写
vim.opt.ignorecase = true
-- 智能大小写
vim.opt.smartcase = true
-- 使用系统剪贴板
vim.opt.clipboard = "unnamedplus"
-- 启用终端真彩色（重复设置，保留以防止遗漏）
vim.opt.termguicolors = true
-- 不显示模式（因为 lualine 已经显示模式）
vim.opt.showmode = false
-- 补全选项
vim.opt.completeopt = { "menu", "menuone", "noselect" }
-- 缩短消息显示时间
vim.opt.shortmess:append("c")
-- 设置更新间隔为 300 毫秒
vim.opt.updatetime = 300

-- 创建自动命令，在文本复制后高亮显示
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight yanked text", -- 添加描述（最佳实践）
  group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }), -- 创建独立组
  callback = function()
    vim.highlight.on_yank { timeout = 300 } -- 高亮显示复制的文本，持续 300 毫秒
  end
})

vim.g.clipboard = {
  name = "win32yank-wsl",
  copy = {
    ["+"] = "win32yank.exe -i --crlf",
    ["*"] = "win32yank.exe -i --crlf"
  },
  paste = {
    ["+"] = "win32yank.exe -o --crlf",
    ["*"] = "win32yank.exe -o --crlf"
  },
  cache_enable = 0,
}

-- 一键运行
-- 定义一个编译并运行当前 C/C++ 文件的函数
local function compile_and_run()
  -- 获取当前文件名、无后缀文件名和文件扩展名
  local file = vim.fn.expand('%')
  local file_no_ext = vim.fn.expand('%:r')
  local ext = vim.fn.expand('%:e')
  local cmd = nil

  if ext == "c" then
    -- 对于 C 文件，使用 gcc 编译
    cmd = string.format("gcc %s -o %s && ./%s", file, file_no_ext, file_no_ext)
  elseif ext == "cpp" then
    -- 对于 C++ 文件，使用 g++ 编译
    cmd = string.format("g++ %s -o %s && ./%s", file, file_no_ext, file_no_ext)
  else
    -- 如果文件不是 C/C++ 文件，打印提示信息
    print("当前文件不是 C/C++ 文件！")
    return
  end

  -- 在下方拆分窗口打开终端，并运行命令
  vim.cmd("botright split | resize 10 | terminal " .. cmd)
end

-- 创建一个用户命令 RunCode 调用上面的函数
vim.api.nvim_create_user_command("RunCode", compile_and_run, {})

-- 绑定快捷键 F5 运行代码
vim.keymap.set("n", "<F5>", ":RunCode<CR>", { noremap = true, silent = true, desc = "运行代码" })
