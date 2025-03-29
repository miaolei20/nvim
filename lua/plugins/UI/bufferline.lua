-- bufferline.lua
return {
  {
    "akinsho/bufferline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local colors = require("onedarkpro.helpers").get_colors()

      require("bufferline").setup({
        options = {
          numbers = "ordinal",
          separator_style = "thin",
          show_buffer_close_icons = false,
          always_show_bufferline = false,
          diagnostics = "nvim_lsp",
          offsets = {{
            filetype = "neo-tree",
            highlight = "Directory",
            text_align = "center",
          }}
        },
        highlights = {
          buffer_selected = { bold = true, italic = false },
          indicator_selected = { fg = colors.purple },
        }
      })
    end
  }
}