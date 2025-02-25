return {
  "Exafunction/codeium.nvim", -- 插件名称
  event = "InsertEnter", -- 在进入插入模式时加载插件
  dependencies = { "nvim-cmp" }, -- 添加依赖声明（可选，但推荐）
  build = ":Codeium Auth", -- 认证 Codeium 的命令
  opts = {
    enable_cmp_source = true,           -- 强制启用 cmp 支持
    virtual_text = { enabled = false }, -- 禁用虚拟文本（避免与 cmp 冲突）
  },
}

