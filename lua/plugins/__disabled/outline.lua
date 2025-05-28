return {{
    "hedyhli/outline.nvim",
    event = "LspAttach",
    dependencies = {"nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons"},
    keys = {{
        "<leader>lo",
        "<cmd>Outline<CR>",
        desc = "Toggle Outline"
    }},
    opts = {
        outline_window = {
            position = "right",
            width = 30
        },
        symbols = {
            filter = {"Class", "Constructor", "Enum", "Function", "Interface", "Method", "Struct"},
            symbol_icons = true -- Enables icons if nvim-web-devicons is available
        }
    }
}}
