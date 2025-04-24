return {{
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = {"BufReadPost", "BufNewFile"},
    dependencies = {"folke/which-key.nvim"},
    opts = {
        ensure_installed = {"lua", "vim", "vimdoc", "c", "cpp", "markdown", "markdown_inline", "python"}, -- 仅保留常用语言
        highlight = {
            enable = true
        },
        indent = {
            enable = true
        },
        incremental_selection = {
            enable = false -- 禁用增量选择
        }
    },
    config = function(_, opts)
        require("nvim-treesitter.configs").setup(opts)
        local wk = require("which-key")
        wk.add({{
            "<leader>t",
            group = "Treesitter",
            icon = "🌳"
        }, {
            "<leader>ts",
            "<cmd>TSHighlightCapturesUnderCursor<CR>",
            desc = "Show Highlight",
            mode = "n",
            icon = "🔍"
        }})
    end
}}
