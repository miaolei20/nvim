return {
  "nvim-pack/nvim-spectre",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = "Spectre",
  opts = {
    open_cmd = "vsplit",
  },
  init = function()
    require("which-key").add({
      { "<leader>s", group = "Search", icon = "󰮗" },
      { "<leader>sr", "<cmd>Spectre<CR>", desc = "Search/Replace", icon = "󰬉" },
    })
  end,
}
