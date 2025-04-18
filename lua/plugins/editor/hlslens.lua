return {
  {
    "kevinhwang91/nvim-hlslens",
    event = { "BufReadPost", "BufNewFile" },
    keys = { "n", "N", "*", "#", "/", "?" },
    dependencies = { "folke/which-key.nvim" },
    opts = {
      calm_down = true, -- Prevent lens jumping
      nearest_only = true, -- Highlight nearest match
      override_lens = function(render, pos_list, nearest, idx, rel_idx)
        local sfw = vim.v.searchforward == 1
        local indicator = string.format("%d/%d", idx, #pos_list)
        local text = string.format("[%s %s]", indicator, nearest and "●" or "○")
        render.set_virt(0, pos_list[idx][1] - 1, pos_list[idx][2], { text = text, hl = sfw and "Search" or "IncSearch" })
      end,
    },
    config = function(_, opts)
      require("hlslens").setup(opts)
      local wk = require("which-key")
      wk.add({
        { "<leader>s", group = "Search", icon = "🔍" },
        { "<leader>sh", ":noh<CR>", desc = "Clear Search Highlight", mode = "n", icon = "🧹" },
      })
    end,
  },
}