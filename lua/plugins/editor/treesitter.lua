return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "folke/which-key.nvim", "nvim-treesitter/nvim-treesitter-textobjects" },
    opts = {
      ensure_installed = { "c", "cpp", "python", "lua", "bash", "json", "yaml", "vim", "vimdoc", "javascript", "typescript", "tsx", "html", "css", "markdown", "markdown_inline" },
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = { init_selection = "<C-space>", node_incremental = "<C-space>", node_decremental = "<bs>" },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = { query = "@function.outer", desc = "Select outer function" },
            ["if"] = { query = "@function.inner", desc = "Select inner function" },
            ["ac"] = { query = "@class.outer", desc = "Select outer class" },
            ["ic"] = { query = "@class.inner", desc = "Select inner class" },
            ["al"] = { query = "@loop.outer", desc = "Select outer loop" },
            ["il"] = { query = "@loop.inner", desc = "Select inner loop" },
            ["ap"] = { query = "@parameter.outer", desc = "Select outer parameter" },
            ["ip"] = { query = "@parameter.inner", desc = "Select inner parameter" },
            ["ab"] = { query = "@block.outer", desc = "Select outer block" },
            ["ib"] = { query = "@block.inner", desc = "Select inner block" },
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]m"] = { query = "@function.outer", desc = "Next function start" },
            ["]c"] = { query = "@class.outer", desc = "Next class start" },
            ["]l"] = { query = "@loop.outer", desc = "Next loop start" },
          },
          goto_previous_start = {
            ["[m"] = { query = "@function.outer", desc = "Previous function start" },
            ["[c"] = { query = "@class.outer", desc = "Previous class start" },
            ["[l"] = { query = "@loop.outer", desc = "Previous loop start" },
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>ta"] = { query = "@parameter.inner", desc = "Swap with next parameter" },
          },
          swap_previous = {
            ["<leader>tA"] = { query = "@parameter.inner", desc = "Swap with previous parameter" },
          },
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
      local wk = require("which-key")
      wk.add({
        { "<leader>t", group = "Treesitter", icon = "🌳" },
        { "<leader>ts", "<cmd>TSHighlightCapturesUnderCursor<CR>", desc = "Show Highlight", mode = "n", icon = "🔍" },
        { "<leader>ta", group = "Text Objects", icon = "📌" },
        { "<leader>ta", function() vim.api.nvim_feedkeys("vaf", "n", true) end, desc = "Select Function", mode = "n", icon = "🔧" },
        { "<leader>tA", function() vim.api.nvim_feedkeys("vif", "n", true) end, desc = "Select Inner Function", mode = "n", icon = "🔩" },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
}