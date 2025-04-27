return { -- Onedarkpro
{
    "olimorris/onedarkpro.nvim",
    priority = 1000,
    config = function()
        require("onedarkpro").setup({
            styles = {
                comments = "italic",
                functions = "bold",
                keywords = "bold"
            },
            options = {
                cursorline = true,
                terminal_colors = true
            }
        })
    end
}, -- Catppuccin (including latte for light theme)
{
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 999,
    config = function()
        require("catppuccin").setup({
            flavour = "mocha", -- Default dark theme
            integrations = {
                treesitter = true,
                telescope = true,
                mason = true,
                which_key = true
            },
            term_colors = true,
            styles = {
                comments = {"italic"},
                functions = {"bold"},
                keywords = {"bold"}
            }
        })
    end
}, -- Tokyonight
{
    "folke/tokyonight.nvim",
    priority = 998,
    config = function()
        require("tokyonight").setup({
            terminal_colors = true,
            styles = {
                comments = {
                    italic = true
                },
                keywords = {
                    bold = true
                },
                functions = {
                    bold = true
                }
            },
            integrations = {
                treesitter = true,
                telescope = true,
                mason = true,
                which_key = true
            }
        })
    end
}, -- Gruvbox
{
    "ellisonleao/gruvbox.nvim",
    priority = 997,
    config = function()
        require("gruvbox").setup({
            italic = {
                comments = true,
                keywords = true,
                functions = true
            },
            bold = true,
            terminal_colors = true
        })
    end
}}
