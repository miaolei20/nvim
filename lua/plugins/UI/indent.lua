return {{
    "lukas-reineke/indent-blankline.nvim",
    event = {"BufReadPost", "BufNewFile"},
    main = "ibl",
    config = function()
        local ibl = require("ibl")
        local hooks = require("ibl.hooks")

        local function set_highlight()
            local colors = vim.api.nvim_get_hl(0, {
                name = "Comment"
            })
            vim.api.nvim_set_hl(0, "IblIndent", {
                fg = colors.fg or "#4B5263",
                nocombine = true
            })
        end

        set_highlight()

        ibl.setup({
            indent = {
                char = "┆",
                highlight = "IblIndent"
            },
            scope = {
                enabled = false
            },
            exclude = {
                filetypes = {"help", "dashboard", "neo-tree", "Trouble", "lazy", "terminal"}
            }
        })

        hooks.register(hooks.type.HIGHLIGHT_SETUP, set_highlight)
    end
}}
