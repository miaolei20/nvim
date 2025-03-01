-- 在 plugins 配置中确保包含：
return
{
  "ahmedkhalf/project.nvim",
  config = function()
    require("project_nvim").setup()
  end
}