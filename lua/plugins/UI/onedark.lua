-- onedark.lua
return {{
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
        vim.cmd.colorscheme("onedark")
    end
}}
