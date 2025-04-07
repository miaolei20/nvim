-- lua/plugins/leetcode.lua
return {
  {
    "kawre/leetcode.nvim",
    cmd = { "Leet","LeetCode", "LeetCodeBuild" }, -- 仅在调用命令时加载插件
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    build = ":TSUpdateSync html",
    cond = function()
      -- 仅在 nvim-treesitter 可用时加载
      return pcall(require, "nvim-treesitter")
    end,
    opts = {
      lang = "c",
      cn = { enabled = true },
      storage = {
        home = vim.fn.stdpath("data") .. "/leetcode",
        cache = vim.fn.stdpath("cache") .. "/leetcode",
      },
      console = {
        open_on_runcode = true,
        size = { width = "90%", height = "75%" },
      },
      description = {
        position = "left",
        width = "40%",
      },
      keys = {
        toggle = "q",
        confirm = "<CR>",
        reset_testcases = "r",
        use_testcase = "U",
        focus_testcases = "H",
        focus_result = "L",
      },
    },
    config = function(_, opts)
      require("leetcode").setup(opts)
      -- 添加手动构建命令，便于在需要时更新 HTML parser
      vim.api.nvim_create_user_command("LeetCodeBuild", ":TSUpdateSync html", {
        desc = "Manually update LeetCode HTML parser",
      })
    end,
  },
}
