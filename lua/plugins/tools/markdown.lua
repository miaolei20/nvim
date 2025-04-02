return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = "markdown",
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
  opts = {
    performance = {
      debounce = 300,
      max_workers = 2,
      incremental_update = true,
    },
    rendering = {
      syntax_highlight = true,
      code_blocks = true,
      disable = { folds = true },
    },
    styles = {
      border = "none",
      padding = { 1, 2 },
      wrap = true,
      transparency = 0.95,
    },
  },
  config = function(_, opts)
    require("render-markdown").setup(opts)
    vim.api.nvim_set_hl(0, "RenderMarkdownCode", { link = "Comment" })
    vim.api.nvim_set_hl(0, "RenderMarkdownHeading", { bold = true, fg = "#89B4FA" })
  end,
}