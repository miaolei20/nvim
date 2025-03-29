return {
  "lewis6991/gitsigns.nvim",
  event = "BufRead",
  opts = {
    signs = {
      add          = { text = "│" },
      change       = { text = "│" },
      delete       = { text = "_" },
      topdelete    = { text = "‾" },
      changedelete = { text = "~" },
    },
    signcolumn = true,
  },
  config = function(_, opts)
    -- 高亮组定义
    local hl = {
      GitSignsAdd          = { fg = "#81b88b" },
      GitSignsChange       = { fg = "#e2c08d" },
      GitSignsDelete       = { fg = "#c74e39" },
      GitSignsTopdelete    = { link = "GitSignsDelete" },
      GitSignsChangedelete = { link = "GitSignsChange" },
    }
    for group, def in pairs(hl) do
      vim.api.nvim_set_hl(0, group, def)
    end
    require("gitsigns").setup(opts)
  end,
}