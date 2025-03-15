return {
  {
    "stevearc/aerial.nvim",
    event = "LspAttach",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-lspconfig",
    },
    config = function()
      if not pcall(require, "aerial") then return end

      require("aerial").setup({
        -- 基础性能优化配置
        close_behavior = "auto",
        link_folds_to_tree = false,
        link_tree_to_folds = false,
        manage_folds = false,

        -- 精简布局配置
        layout = {
          min_width = 24,
          default_direction = "right",
          placement = "edge"
        },

        -- 禁用非必要视觉元素
        show_guides = false,
        highlight_on_hover = false,

        -- 核心功能保留
        on_attach = function(bufnr)
          vim.keymap.set("n", "<leader>o", require("aerial").toggle, {
            buffer = bufnr,
            desc = "Outline"
          })
        end
      })
    end
  }
}