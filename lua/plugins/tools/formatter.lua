return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    dependencies = { "WhoIsSethDaniel/mason-tool-installer.nvim" }, -- 移除 which-key.nvim
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
          args = { "--style=Google" }, -- 可改为: Google, LLVM, Mozilla 等
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
      local conform = require("conform")
      conform.setup(opts)

      -- 保留原快捷键映射功能，不使用 which-key
      vim.keymap.set("n", "<leader>ff", function()
        conform.format({ async = true, lsp_fallback = true })
      end, { desc = "Format Buffer" })

      vim.keymap.set("n", "<leader>ft", function()
        -- 开关格式化保存功能（注意：此处修改 opts 变量无效，需修改 conform 实例）
        conform.format_on_save = not conform.format_on_save
        vim.notify("Format on save: " .. (conform.format_on_save and "enabled" or "disabled"), vim.log.levels.INFO)
      end, { desc = "Toggle Format on Save" })
    end,
  },
}
