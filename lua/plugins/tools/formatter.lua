return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    dependencies = { "folke/which-key.nvim", "WhoIsSethDaniel/mason-tool-installer.nvim" },
    opts = {
      formatters_by_ft = {
        c = { "clang_format" },
        cpp = { "clang_format" },
        python = { "black" },
        lua = { "stylua" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        json = { "prettier" },
        yaml = { "prettier" },
      },
      formatters = {
        clang_format = {
          command = "clang-format",
          args = { "--style=Google" }, -- Customize: Google, LLVM, Mozilla, or .clang-format
        },
        black = {
          command = "black",
          args = { "--quiet", "--line-length=88", "-" },
        },
        stylua = {
          command = "stylua",
          args = { "--indent-type", "Spaces", "--indent-width", "2", "-" },
        },
        shfmt = {
          command = "shfmt",
          args = { "-i", "2", "-ci" },
        },
        prettier = {
          command = "prettier",
          args = { "--stdin-filepath", "$FILENAME" },
        },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
    config = function(_, opts)
      require("conform").setup(opts)
      local wk = require("which-key")
      wk.add({
        { "<leader>f", group = "Format", icon = "🧹" },
        { "<leader>ff", function() require("conform").format({ async = true, lsp_fallback = true }) end, desc = "Format Buffer", mode = "n", icon = "📄" },
        { "<leader>ft", function()
          require("conform").format_on_save = not require("conform").format_on_save
          vim.notify("Format on save: " .. (require("conform").format_on_save and "enabled" or "disabled"), vim.log.levels.INFO)
        end, desc = "Toggle Format on Save", mode = "n", icon = "🔄" },
      })
    end,
  },
}