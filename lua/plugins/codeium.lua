return {
  "Exafunction/codeium.nvim",
  event = "InsertEnter",
  dependencies = { "nvim-cmp" }, -- 添加依赖声明（可选，但推荐）
  build = ":Codeium Auth",
  opts = {
    enable_cmp_source = true, -- 强制启用 cmp 支持
    virtual_text = { enabled = false }, -- 禁用虚拟文本（避免与 cmp 冲突）
  },
}