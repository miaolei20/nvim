return {
    {
      "kawre/leetcode.nvim",
      event = "BufReadPost",
      build = function()
        pcall(vim.cmd, "TSUpdate html")
      end,
      dependencies = {
        "nvim-telescope/telescope.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
      },
      opts = {
        arg = "leetcode.nvim",
        lang = "cpp",
        cn = {
            enabled = true,             -- 开启 leetcode.cn 支持
            translator = true,         -- 根据需要启用或关闭翻译功能（建议关闭以优化性能）
            translate_problems = true, -- 同上
          },          
        storage = {
          home = vim.fn.stdpath("data") .. "/leetcode",
          cache = vim.fn.stdpath("cache") .. "/leetcode",
        },
        plugins = {
          non_standalone = false,
        },
        logging = false,
        injector = {},
        cache = {
          update_interval = 60 * 60 * 24 * 7,
        },
        console = {
          open_on_runcode = true,
          dir = "row",
          size = {
            width = "90%",
            height = "75%",
          },
          result = {
            size = "60%",
          },
          testcase = {
            virt_text = true,
            size = "40%",
          },
        },
        description = {
          position = "left",
          width = "40%",
          show_stats = true,
        },
        picker = {
          provider = nil,
        },
        hooks = {
          ["enter"] = {},
          ["question_enter"] = {},
          ["leave"] = {},
        },
        keys = {
          toggle = { "q" },
          confirm = { "<CR>" },
          reset_testcases = "r",
          use_testcase = "U",
          focus_testcases = "H",
          focus_result = "L",
        },
        theme = {},
        image_support = false,
      },
    },
  }
  