-- 定义需要应用缩进可视化的文件类型
local filetypes = { 'c', 'cpp', 'python', 'lua' }

-- 创建自动命令组，确保配置整洁并避免重复定义
vim.api.nvim_create_augroup('indent_guides', { clear = true })

-- 为指定文件类型设置缩进可视化和相关选项
for _, ft in ipairs(filetypes) do
  vim.api.nvim_create_autocmd('FileType', {
    group = 'indent_guides', -- 自动命令组
    pattern = ft,            -- 匹配文件类型
    callback = function()
      -- 启用 list 模式以显示不可见字符
      vim.opt_local.list = true
      -- 设置 listchars，将空格显示为点号（·）
      vim.opt.listchars = 'space:·'
      -- 设置缩进大小为 4 空格
      vim.opt_local.tabstop = 4
      vim.opt_local.shiftwidth = 4
    end,
  })
end