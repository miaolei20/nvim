-- 自定义诊断图标（需安装支持 Nerd Fonts 的字体）
local signs = {
    Error = " ",
    Warn  = " ",
    Hint  = "󰌵",
    Info  = " ",
  }
  
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end
  
  -- 美化诊断信息的显示
  vim.diagnostic.config({
    virtual_text = {
      prefix = "",  -- 使用图标作为虚拟文本前缀
      spacing = 4,   -- 调整间距
    },
    signs = true,             -- 启用左侧图标
    underline = true,         -- 下划线提示
    update_in_insert = false, -- 插入模式下不自动更新
    severity_sort = true,     -- 根据严重程度排序
    float = {
      border = "rounded",     -- 浮窗边框圆角
      source = "always",      -- 总是显示诊断来源
      header = "",            -- 浮窗标题为空
      prefix = "",            -- 浮窗前缀为空
    },
  })
  