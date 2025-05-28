return {
    "numToStr/Comment.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "JoosepAlviste/nvim-ts-context-commentstring"
    },
    config = function()
        require("ts_context_commentstring").setup({ enable_autocmd = false })

        require("Comment").setup({
            pre_hook = function(ctx)
                local U = require("Comment.utils")

                -- ts-context-commentstring hook
                if ctx.ctype == U.ctype.block then
                    return require("ts_context_commentstring.internal").calculate_commentstring({
                        key = "ts_context_commentstring",
                        location = ctx.range and {
                            ctx.range.srow,
                            ctx.range.scol,
                        } or nil,
                    }) or vim.bo.commentstring
                end
            end
        })
    end,
}
