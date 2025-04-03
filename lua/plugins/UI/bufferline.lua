-- bufferline.lua
return {
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        termguicolors = true,
        numbers = "ordinal",
        separator_style = "thin",
        show_buffer_close_icons = false,
        always_show_bufferline = false,
        diagnostics = "nvim_lsp",
        offsets = {
          { filetype = "neo-tree", highlight = "Directory", text_align = "center" },
        },
      },
    },
  },
}