return {
  {
    "kawre/leetcode.nvim",
    event = "VeryLazy", -- Changed to VeryLazy for better startup performance
    build = ":TSUpdate html",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      arg = "leetcode.nvim",
      lang = "c", -- Default language set to C
      cn = {
        enabled = true, -- Enable leetcode.cn support
      },
      storage = {
        home = vim.fn.stdpath("data") .. "/leetcode",
        cache = vim.fn.stdpath("cache") .. "/leetcode",
      },
      console = {
        open_on_runcode = true,
        dir = "row",
        size = { width = "90%", height = "75%" },
        result = { size = "60%" },
        testcase = { virt_text = true, size = "40%" },
      },
      description = {
        position = "left",
        width = "40%",
        show_stats = true,
      },
      keys = {
        toggle = "q",
        confirm = "<CR>",
        reset_testcases = "r",
        use_testcase = "U",
        focus_testcases = "H",
        focus_result = "L",
      },
      logging = false, -- Disable logging for performance
      cache = { update_interval = 60 * 60 * 24 * 7 }, -- Weekly cache update
      image_support = false, -- Disable image support for simplicity
    },
  },
}