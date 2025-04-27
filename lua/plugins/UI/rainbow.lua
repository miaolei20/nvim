return {{
    "HiPhish/rainbow-delimiters.nvim",
    event = {"BufReadPost", "BufNewFile"},
    dependencies = {"nvim-treesitter/nvim-treesitter"},
    config = function()
        local status_ok, rainbow_delimiters = pcall(require, "rainbow-delimiters")
        if not status_ok then
            vim.notify("Failed to load rainbow-delimiters.nvim", vim.log.levels.ERROR)
            return
        end

        -- Theme Detection (aligned with heirline.lua)
        local function get_current_theme()
            local theme = vim.g.colors_name
            if theme then
                return theme
            end
            local selected_theme_file = vim.fn.stdpath("config") .. "/selected_theme.txt"
            if vim.fn.filereadable(selected_theme_file) == 1 then
                local success, lines = pcall(vim.fn.readfile, selected_theme_file)
                if success and lines[1] and lines[1]:match("^colorscheme [%w%-]+$") then
                    return lines[1]:match("^colorscheme (%w+[%w%-]*)$") or "onedark"
                end
            end
            return "onedark"
        end

        -- Theme Palettes (matched with heirline.lua)
        local theme_palettes = {
            onedark = {
                red = "#e06c75",
                yellow = "#e5c07b",
                blue = "#61afef",
                green = "#98c379",
                cyan = "#56b6c2",
                purple = "#c678dd",
                orange = "#d19a66"
            },
            catppuccin = {
                red = "#f38ba8",
                yellow = "#f9e2af",
                blue = "#89b4fa",
                green = "#a6e3a1",
                cyan = "#94e2d5",
                purple = "#f5c2e7",
                orange = "#fab387"
            },
            ["catppuccin-latte"] = {
                red = "#d20f39",
                yellow = "#df8e1d",
                blue = "#1e66f5",
                green = "#40a02b",
                cyan = "#14b8a6",
                purple = "#8839ef",
                orange = "#e64553"
            },
            tokyonight = {
                red = "#f7768e",
                yellow = "#e0af68",
                blue = "#7aa2f7",
                green = "#9ece6a",
                cyan = "#7dcfff",
                purple = "#bb9af7",
                orange = "#ff9e64"
            },
            gruvbox = {
                red = "#cc241d",
                yellow = "#fabd2f",
                blue = "#458588",
                green = "#b8bb26",
                cyan = "#83a598",
                purple = "#b16286",
                orange = "#d65d0e"
            }
        }

        -- Get Colors
        local function get_colors()
            local theme = get_current_theme()
            return theme_palettes[theme] or theme_palettes.onedark
        end

        -- Set Highlight Groups
        local function set_highlights()
            local c = get_colors()
            local highlight_groups = {
                RainbowDelimiterRed = {
                    fg = c.red
                },
                RainbowDelimiterYellow = {
                    fg = c.yellow
                },
                RainbowDelimiterBlue = {
                    fg = c.blue
                },
                RainbowDelimiterGreen = {
                    fg = c.green
                },
                RainbowDelimiterCyan = {
                    fg = c.cyan
                },
                RainbowDelimiterViolet = {
                    fg = c.purple
                },
                RainbowDelimiterOrange = {
                    fg = c.orange
                }
            }
            for group, opts in pairs(highlight_groups) do
                pcall(vim.api.nvim_set_hl, 0, group, opts)
            end
        end
        set_highlights()

        -- Refresh on Theme Change
        vim.api.nvim_create_autocmd("ColorScheme", {
            callback = function()
                set_highlights()
            end
        })

        -- Setup rainbow-delimiters
        vim.g.rainbow_delimiters = {
            strategy = {
                [""] = rainbow_delimiters.strategy["global"],
                vim = rainbow_delimiters.strategy["local"],
                lua = rainbow_delimiters.strategy["local"],
                python = rainbow_delimiters.strategy["local"]
            },
            query = {
                [""] = "rainbow-delimiters",
                javascript = "rainbow-parens",
                tsx = "rainbow-parens"
            },
            highlight = {"RainbowDelimiterRed", "RainbowDelimiterYellow", "RainbowDelimiterBlue",
                         "RainbowDelimiterGreen", "RainbowDelimiterCyan", "RainbowDelimiterViolet",
                         "RainbowDelimiterOrange"},
            blacklist = {"html"}
        }
    end
}}
