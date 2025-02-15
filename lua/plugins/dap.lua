return {
  -- DAP 核心插件
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio"
    },
    config = function()
      require("config.dap").setup()
      require("config.dap.ui").setup()
      require("lang.cpp-dap").setup() -- 加载 C++ 专用配置
    end
  },

  -- DAP UI 增强
  {
    "rcarriga/nvim-dap-ui",
    keys = {
      { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle Debug UI" }
    }
  },

  -- 虚拟文本显示
  {
    "theHamsta/nvim-dap-virtual-text",
    opts = { commented = true }
  }
}
