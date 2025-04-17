return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "folke/which-key.nvim" },
    opts = {
      ensure_installed = {
        "bash", "c", "lua", "vim", "vimdoc", "python",
        "javascript", "typescript", "tsx", "html", "css",
        "markdown", "markdown_inline", "json", "yaml", "cpp",
      },
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          node_decremental = "<bs>",
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically select the nearest valid node
          keymaps = {
            ["af"] = { query = "@function.outer", desc = "Around function" },
            ["if"] = { query = "@function.inner", desc = "Inner function" },
            ["ac"] = { query = "@class.outer", desc = "Around class" },
            ["ic"] = { query = "@class.inner", desc = "Inner class" },
            ["al"] = { query = "@loop.outer", desc = "Around loop" },
            ["il"] = { query = "@loop.inner", desc = "Inner loop" },
            ["ab"] = { query = "@block.outer", desc = "Around block" },
            ["ib"] = { query = "@block.inner", desc = "Inner block" },
            ["aa"] = { query = "@parameter.outer", desc = "Around parameter" },
            ["ia"] = { query = "@parameter.inner", desc = "Inner parameter" },
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- Add to jumplist for navigation
          goto_next_start = {
            ["]m"] = { query = "@function.outer", desc = "Next function start" },
            ["]c"] = { query = "@class.outer", desc = "Next class start" },
            ["]l"] = { query = "@loop.outer", desc = "Next loop start" },
          },
          goto_next_end = {
            ["]M"] = { query = "@function.outer", desc = "Next function end" },
            ["]C"] = { query = "@class.outer", desc = "Next class end" },
          },
          goto_previous_start = {
            ["[m"] = { query = "@function.outer", desc = "Previous function start" },
            ["[c"] = { query = "@class.outer", desc = "Previous class start" },
            ["[l"] = { query = "@loop.outer", desc = "Previous loop start" },
          },
          goto_previous_end = {
            ["[M"] = { query = "@function.outer", desc = "Previous function end" },
            ["[C"] = { query = "@class.outer", desc = "Previous class end" },
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>sa"] = { query = "@parameter.inner", desc = "Swap with next parameter" },
          },
          swap_previous = {
            ["<leader>sA"] = { query = "@parameter.inner", desc = "Swap with previous parameter" },
          },
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
      -- Integrate with which-key.nvim
      local wk = require("which-key")
      wk.add({
        { "<leader>t", group = "Treesitter", icon = "🌳" },
        -- Navigation mappings
        { "<leader>tf", group = "Function" },
        { "<leader>tfn", "]m", desc = "Next Function Start", mode = "n" },
        { "<leader>tfp", "[m", desc = "Previous Function Start", mode = "n" },
        { "<leader>tfe", "]M", desc = "Next Function End", mode = "n" },
        { "<leader>tfE", "[M", desc = "Previous Function End", mode = "n" },
        { "<leader>tc", group = "Class" },
        { "<leader>tcn", "]c", desc = "Next Class Start", mode = "n" },
        { "<leader>tcp", "[c", desc = "Previous Class Start", mode = "n" },
        { "<leader>tce", "]C", desc = "Next Class End", mode = "n" },
        { "<leader>tcE", "[C", desc = "Previous Class End", mode = "n" },
        { "<leader>tl", group = "Loop" },
        { "<leader>tln", "]l", desc = "Next Loop Start", mode = "n" },
        { "<leader>tlp", "[l", desc = "Previous Loop Start", mode = "n" },
        -- Swap mappings
        { "<leader>s", group = "Swap" },
        { "<leader>sa", desc = "Swap Next Parameter", mode = "n" },
        { "<leader>sA", desc = "Swap Previous Parameter", mode = "n" },
      })
    end,
  },
}