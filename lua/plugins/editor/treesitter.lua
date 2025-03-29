local colors = require("onedark.palette").dark

return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = {
        "bash", "c", "lua", "vim", "vimdoc", "python",
        "javascript", "typescript", "tsx", "html", "css",
        "markdown", "markdown_inline", "json", "yaml", "cpp",
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
        custom_captures = {
          ["keyword.function"] = "Function",
        },
      },
      indent = { enable = false },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection   = "<C-space>",
          node_incremental = "<C-space>",
          node_decremental = "<bs>",
        },
      },
      textobjects = {
        move = {
          enable = true,
          goto_next_start     = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
          goto_next_end       = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
          goto_previous_end   = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
        },
        swap = {
          enable = true,
          swap_next     = { ["<leader>a"] = "@parameter.inner" },
          swap_previous = { ["<leader>A"] = "@parameter.inner" },
        },
        select = {
          enable = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
          },
        },
      },
      matchup = {
        enable = true,
        highlight = {
          bg = colors.bg2 or "#282c34",
          fg = colors.yellow or "#E5C07B",
        },
      },
    },
    config = function(_, opts)
      -- 设置自定义高亮组，确保与主题一致
      vim.api.nvim_set_hl(0, "@function",  { fg = colors.blue,   bold = true })
      vim.api.nvim_set_hl(0, "@parameter", { fg = colors.cyan })
      vim.api.nvim_set_hl(0, "@keyword",   { fg = colors.purple, italic = true })

      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
