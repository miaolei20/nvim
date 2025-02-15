return {
  "rcarriga/nvim-notify",
  event = "VeryLazy",
  opts = {
    timeout = 2000,
    max_width = 80,
    stages = "slide",
    position = "bottom_right",
    background_colour = "#1e222a",
    icons = {
      ERROR = "",
      WARN = "",
      INFO = "",
      DEBUG = "",
      TRACE = "✎"
    },
    render = "wrapped-compact"
  },
  config = function(_, opts)
    require("notify").setup(opts)
    vim.notify = require("notify")
  end
}