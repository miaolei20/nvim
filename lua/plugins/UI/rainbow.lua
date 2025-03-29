-- rainbow.lua
return {
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "BufReadPost",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      local colors = require("onedarkpro.helpers").get_colors()
      local rainbow = require("rainbow-delimiters")

      vim.api.nvim_set_hl(0, "RainbowDelimiterRed",    { fg = colors.red })
      vim.api.nvim_set_hl(0, "RainbowDelimiterYellow", { fg = colors.yellow })
      vim.api.nvim_set_hl(0, "RainbowDelimiterBlue",   { fg = colors.blue })
      vim.api.nvim_set_hl(0, "RainbowDelimiterGreen",  { fg = colors.green })
      vim.api.nvim_set_hl(0, "RainbowDelimiterCyan",   { fg = colors.cyan })
      vim.api.nvim_set_hl(0, "RainbowDelimiterViolet", { fg = colors.purple })

      require("rainbow-delimiters.setup").setup({
        strategy = {[""] = rainbow.strategy["global"]},
        query = {[""] = "rainbow-delimiters"},
        highlight = vim.tbl_keys(vim.api.nvim_get_hl(0, {name = "RainbowDelimiterRed"}))
      })
    end
  }
}