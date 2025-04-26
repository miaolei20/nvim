return {{
    "echasnovski/mini.comment",
    event = {"BufReadPre", "BufNewFile"},
    dependencies = {"JoosepAlviste/nvim-ts-context-commentstring"},
    config = function()
        -- 配置 nvim-ts-context-commentstring
        require("ts_context_commentstring").setup({
            enable_autocmd = false
        })

        -- 配置 mini.comment
        require("mini.comment").setup({
            options = {
                custom_commentstring = function()
                    return require("ts_context_commentstring.internal").calculate_commentstring() or
                               vim.bo.commentstring
                end
            },
            mappings = {
                comment = "<C-_>",
                comment_line = "<C-_>",
                comment_visual = "<C-_>",
                textobject = "<C-_>"
            }
        })
    end
}}
