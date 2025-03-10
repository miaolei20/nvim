return {
  'romgrk/barbar.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons', -- 可选：用于文件图标
    'lewis6991/gitsigns.nvim',      -- 可选：用于 Git 状态
  },
  init = function()
    -- 禁用 lazy.nvim 的自动设置，以便我们自定义配置
    vim.g.barbar_auto_setup = false
  end,
  opts = {
    -- 设置 barbar.nvim 的选项
    animation = true,                -- 启用标签切换动画
    insert_at_start = true,          -- 在标签栏开始处插入新标签
    insert_at_end = false,           -- 在标签栏结束处插入新标签
    auto_hide = false,               -- 不自动隐藏标签栏
    clickable = true,                -- 启用点击标签切换缓冲区
    icons = {
      filetype = { enabled = true },  -- 启用文件类型图标
      pinned = { filename = true, buffer_index = true }, -- 固定标签显示文件名和缓冲区索引
      diagnostics = { { enabled = true } }, -- 启用诊断图标
    },
  },
  event = 'BufRead', -- 设置插件在读取缓冲区时加载
}
