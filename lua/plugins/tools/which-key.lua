return {{
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        preset = "modern",
        delay = 300,
        win = {
            border = "rounded",
            padding = {1, 2},
            height = {
                min = 4,
                max = 25
            },
            width = {
                min = 20,
                max = 50
            },
            title = true,
            title_pos = "center"
        },
        icons = {
            breadcrumb = "»",
            separator = "→",
            group = "+",
            mappings = false
        },
        layout = {
            align = "center",
            spacing = 4
        },
        show_help = true,
        show_keys = true,
        triggers = {{
            "<leader>",
            mode = {"n", "v"}
        }, {
            "<localleader>",
            mode = {"n", "v"}
        }, {
            "g",
            mode = {"n", "v"}
        }, {
            "z",
            mode = "n"
        }, {
            "[",
            mode = "n"
        }, {
            "]",
            mode = "n"
        }}
    },
    config = function(_, opts)
        vim.o.timeout = true
        vim.o.timeoutlen = 500 -- Increased for better key sequence detection
        local wk = require("which-key")
        wk.setup(opts)

    end
}}
