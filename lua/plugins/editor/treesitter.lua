return {{
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = {"BufReadPost", "BufNewFile"},
    dependencies = {"folke/which-key.nvim", "JoosepAlviste/nvim-ts-context-commentstring"},
    config = function()
        vim.g.skip_ts_context_commentstring_module = true
        require("ts_context_commentstring").setup({
            enable_autocmd = false
        })
        require("nvim-treesitter.configs").setup({
            ensure_installed = {"lua", "vim", "vimdoc", "c", "cpp", "markdown", "markdown_inline", "python"},
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false
            },
            indent = {
                enable = true
            },
            incremental_selection = {
                enable = false
            },
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner"
                    }
                },
                move = {
                    enable = true,
                    set_jumps = true,
                    goto_next_start = {
                        ["]m"] = "@function.outer",
                        ["]]"] = "@class.outer"
                    },
                    goto_previous_start = {
                        ["[m"] = "@function.outer",
                        ["[["] = "@class.outer"
                    }
                }
            }
        })
        require("which-key").add({{
            "<leader>t",
            group = "Treesitter",
            icon = "🌳"
        }, {
            "<leader>ts",
            "<cmd>TSHighlightCapturesUnderCursor<CR>",
            desc = "Show Highlight",
            mode = "n",
            icon = "🔍"
        }, {
            "<leader>tc",
            "<cmd>TSContextToggle<CR>",
            desc = "Toggle Context",
            mode = "n",
            icon = "📜"
        }})
    end
}}
