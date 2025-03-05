return {
  "lewis6991/impatient.nvim",
  config = function()
    require("impatient").enable_profile()
  end,
  priority = 1000  -- 确保最先加载
}