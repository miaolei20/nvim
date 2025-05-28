return {
    -- 🟦 OneDarkPro
    {
        "olimorris/onedarkpro.nvim",
        name = "onedarkpro",
        priority = 1000,
        lazy = false,
        config = function()
            require("onedarkpro").setup({
                styles = {
                    comments = "italic",
                    functions = "bold",
                    keywords = "bold",
                },
                options = {
                    cursorline = true,
                    terminal_colors = true,
                },
            })
        end,
    },

    -- 🟪 Catppuccin (mocha 默认深色风格，支持 latte 浅色)
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 999,
        lazy = false,
        config = function()
            require("catppuccin").setup({
                flavour = "mocha",
                transparent_background = false,
                term_colors = true,
                integrations = {
                    treesitter = true,
                    telescope = true,
                    mason = true,
                    which_key = true,
                },
                styles = {
                    comments = { "italic" },
                    functions = { "bold" },
                    keywords = { "bold" },
                },
            })
        end,
    },

    -- 🟩 TokyoNight（推荐 style = "storm"）
    {
        "folke/tokyonight.nvim",
        name = "tokyonight",
        priority = 998,
        lazy = false,
        config = function()
            require("tokyonight").setup({
                style = "storm",
                terminal_colors = true,
                styles = {
                    comments = { italic = true },
                    keywords = { bold = true },
                    functions = { bold = true },
                },
                integrations = {
                    treesitter = true,
                    telescope = true,
                    mason = true,
                    which_key = true,
                },
            })
        end,
    },

    -- 🟫 Gruvbox
    {
        "ellisonleao/gruvbox.nvim",
        name = "gruvbox",
        priority = 997,
        lazy = false,
        config = function()
            require("gruvbox").setup({
                terminal_colors = true,
                bold = true,
                italic = {
                    comments = true,
                    keywords = true,
                    functions = true,
                },
            })
        end,
    },{
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 996,
    lazy = false,
    config = function()
        require("rose-pine").setup({
            dark_variant = "main", -- 可选：main / moon / dawn
            disable_background = false,
            styles = {
                bold = true,
                italic = true,
                transparency = false,
            },
        })
    end,
},
{
    "sainnhe/everforest",
    name = "everforest",
    priority = 995,
    lazy = false,
    config = function()
        vim.g.everforest_background = "hard" -- 可选：soft, medium, hard
        vim.g.everforest_enable_italic = 1
        vim.g.everforest_enable_bold = 1
        vim.g.everforest_transparent_background = 0
    end,
},

}
