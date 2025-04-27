return {{
    "nvim-treesitter/nvim-treesitter-context",
    event = {"BufReadPost", "BufNewFile"},
    dependencies = {"nvim-treesitter/nvim-treesitter"},
    opts = {
        mode = "topline", -- Show context at top of window
        max_lines = 2, -- Max lines to display
        multiline_threshold = 3, -- Threshold for multiline context
        separator = "▔", -- Separator style
        zindex = 45, -- Z-index for context window
        trim_scope = "inner", -- Trim to inner scope
        patterns = { -- Language-specific context patterns
            c = "function_definition",
            cpp = "function_definition",
            go = "function_declaration",
            lua = "function_definition",
            python = {"function_definition", "class_definition"},
            rust = "function_item",
            javascript = "function_declaration",
            typescript = "function_declaration",
            tsx = "function_declaration",
            ruby = "method_definition",
            java = "method_declaration"
        },
        throttle = true, -- Throttle updates for performance
        timeout = 80, -- Timeout in milliseconds
        scroll_speed = 50, -- Scroll speed for context
        update_events = {"CursorMoved", "BufEnter"} -- Events triggering updates
    },
    config = function(_, opts)
        local status_ok, context = pcall(require, "treesitter-context")
        if not status_ok then
            vim.notify("Failed to load nvim-treesitter-context", vim.log.levels.ERROR)
            return
        end
        context.setup(opts)

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

        -- Theme Palettes (aligned with heirline.lua)
        local theme_palettes = {
            onedark = {
                bg = "#282c34", -- Dark background
                fg = "#abb2bf", -- Light text
                bg_alt = "#21252b", -- Darker inactive
                fg_alt = "#6b7280", -- Muted text
                accent = "#4b8299" -- Softer cyan
            },
            catppuccin = {
                bg = "#1e1e2e", -- Mocha base
                fg = "#cdd6f4", -- Mocha text
                bg_alt = "#181825", -- Mocha crust
                fg_alt = "#6b7280", -- Mocha overlay1
                accent = "#7bc7bd" -- Softer teal
            },
            ["catppuccin-latte"] = {
                bg = "#eff1f5", -- Latte base
                fg = "#1a2535", -- Darker text
                bg_alt = "#d1d5db", -- Latte surface0
                fg_alt = "#6b7280", -- Latte overlay1
                accent = "#4ba3a3" -- Softer teal
            },
            tokyonight = {
                bg = "#1a1b26", -- Night base
                fg = "#c0caf5", -- Night text
                bg_alt = "#16161e", -- Night darker
                fg_alt = "#6b7280", -- Night comment
                accent = "#5e9bc9" -- Softer cyan
            },
            gruvbox = {
                bg = "#282828", -- Dark bg0
                fg = "#ebdbb2", -- Light fg
                bg_alt = "#1d2021", -- Dark bg1
                fg_alt = "#6b7280", -- Gray
                accent = "#6b8e8e" -- Softer blue-green
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
            local highlights = {
                TreesitterContext = {
                    bg = c.bg_alt,
                    blend = 15
                },
                TreesitterContextLineNumber = {
                    fg = c.fg_alt,
                    italic = true
                },
                TreesitterContextSeparator = {
                    fg = c.accent,
                    bold = true
                }
            }
            for group, opts in pairs(highlights) do
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

        -- Key Mappings
        vim.keymap.set("n", "<leader>ut", context.toggle, {
            desc = "Toggle Context Window",
            silent = true
        })
        vim.keymap.set("n", "<leader>uc", function()
            if context.enabled() then
                context.disable()
            else
                context.enable()
            end
        end, {
            desc = "Toggle Context Display",
            silent = true
        })
        vim.keymap.set("n", "[c", context.go_to_context, {
            desc = "Jump to Context",
            silent = true
        })

        -- Disable Context for Specific File Types
        vim.api.nvim_create_autocmd("FileType", {
            pattern = {"markdown", "help", "NvimTree", "dashboard", "alpha"},
            callback = function()
                context.disable()
            end
        })
    end
}}
