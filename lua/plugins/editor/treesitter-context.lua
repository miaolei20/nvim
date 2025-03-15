return {
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      mode = "topline",
      max_lines = 2,
      multiline_threshold = 3,
      separator = "▔",
      zindex = 45,
      trim_scope = "inner",
      on_attach = function(bufnr)
        vim.keymap.set("n", "<leader>ut", function()
          require("treesitter-context").toggle()
        end, { desc = "Toggle Context Window", buffer = bufnr, silent = true })
        vim.keymap.set("n", "[c", function()
          require("treesitter-context").go_to_context()
        end, { desc = "Jump to Context", buffer = bufnr, silent = true })
      end,
    },
    config = function(_, opts)
      local context = require("treesitter-context")

      -- 动态获取高亮颜色
      local function get_hl(group, attr)
        return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(group)), attr) or ""
      end

      -- 设置高亮
      local highlights = {
        TreesitterContext = {
          bg = get_hl("Normal", "bg") ~= "" and get_hl("Normal", "bg") or "#282c34",
          blend = 10,
        },
        TreesitterContextLineNumber = {
          fg = get_hl("LineNr", "fg") ~= "" and get_hl("LineNr", "fg") or "#5c6370",
          italic = true,
        },
        TreesitterContextSeparator = {
          fg = get_hl("Comment", "fg") ~= "" and get_hl("Comment", "fg") or "#5c6370",
          bold = true,
        },
      }

      for group, hl in pairs(highlights) do
        vim.api.nvim_set_hl(0, group, hl)
      end

      -- 配置 Treesitter Context
      context.setup(vim.tbl_deep_extend("force", {
        patterns = {
          c = "function_definition",
          cpp = "function_definition",
          go = "function_declaration",
          lua = "function_definition",
          python = { "function_definition", "class_definition" },
          rust = "function_item",
          javascript = "function_declaration",
          typescript = "function_declaration",
          tsx = "function_declaration",
          ruby = "method_definition",
          java = "method_declaration",
        },
        throttle = true,
        timeout = 80,
        scroll_speed = 50,
        update_events = { "CursorMoved", "BufEnter" },
      }, opts))

      -- 禁用特定文件类型
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "markdown", "help", "NvimTree", "dashboard" },
        group = vim.api.nvim_create_augroup("TSContextDisable", {}),
        callback = function()
          context.disable()
        end,
      })

      -- 延迟启用
      vim.defer_fn(function()
        if not context.enabled then
          context.enable()
        end
      end, 500)
    end,
  },
}