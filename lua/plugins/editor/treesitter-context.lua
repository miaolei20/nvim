return {{
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
        mode = "topline",
        max_lines = 2,
        multiline_threshold = 3,
        separator = "▔",
        zindex = 45,
        trim_scope = "inner",
        patterns = {
            c = "function_definition",
            cpp = "function_definition",
            lua = "function_definition",
            python = { "function_definition", "class_definition" },
        },
        throttle = true,
        timeout = 80,
        scroll_speed = 50,
        update_events = { "CursorMoved", "BufEnter" },
    },
    config = function(_, opts)
        local ok, context = pcall(require, "treesitter-context")
        if not ok then
            vim.notify("Failed to load nvim-treesitter-context", vim.log.levels.ERROR)
            return
        end

        -- Merge user opts with defaults for safety
        local default_opts = vim.tbl_deep_extend("force", {}, opts or {})
        context.setup(default_opts)

        -- Theme name detection
        local function get_current_theme()
            local theme = vim.g.colors_name
            if theme then return theme end
            local path = vim.fn.stdpath("config") .. "/selected_theme.txt"
            if vim.fn.filereadable(path) == 1 then
                local ok, lines = pcall(vim.fn.readfile, path)
                if ok and lines[1] then
                    return lines[1]:match("^colorscheme%s+([%w%-_]+)$") or "onedark"
                end
            end
            return "onedark"
        end

        -- Theme palettes
        local theme_palettes = {
            onedark = {
                bg = "#282c34",
                fg = "#abb2bf",
                bg_alt = "#21252b",
                fg_alt = "#6b7280",
                accent = "#4b8299",
            },
            catppuccin = {
                bg = "#1e1e2e",
                fg = "#cdd6f4",
                bg_alt = "#181825",
                fg_alt = "#6b7280",
                accent = "#7bc7bd",
            },
            ["catppuccin-latte"] = {
                bg = "#eff1f5",
                fg = "#1a2535",
                bg_alt = "#d1d5db",
                fg_alt = "#6b7280",
                accent = "#4ba3a3",
            },
            tokyonight = {
                bg = "#1a1b26",
                fg = "#c0caf5",
                bg_alt = "#16161e",
                fg_alt = "#6b7280",
                accent = "#5e9bc9",
            },
            gruvbox = {
                bg = "#282828",
                fg = "#ebdbb2",
                bg_alt = "#1d2021",
                fg_alt = "#6b7280",
                accent = "#6b8e8e",
            },
        }

        local function get_colors()
            local theme = get_current_theme()
            return theme_palettes[theme] or theme_palettes.onedark
        end

        -- Highlight setup
        local function set_highlights()
            local c = get_colors()
            local highlights = {
                TreesitterContext = { bg = c.bg_alt, blend = 15 },
                TreesitterContextLineNumber = { fg = c.fg_alt, italic = true },
                TreesitterContextSeparator = { fg = c.accent, bold = true },
            }
            for group, opts in pairs(highlights) do
                pcall(vim.api.nvim_set_hl, 0, group, vim.tbl_extend("force", opts, { default = false }))
            end
        end
        set_highlights()

        vim.api.nvim_create_augroup("TSContextHighlight", { clear = true })
        vim.api.nvim_create_autocmd("ColorScheme", {
            group = "TSContextHighlight",
            callback = set_highlights,
        })

        vim.api.nvim_create_augroup("TSContextDisable", { clear = true })
        vim.api.nvim_create_autocmd("FileType", {
            group = "TSContextDisable",
            pattern = { "markdown", "help", "NvimTree", "dashboard", "alpha" },
            callback = function()
                pcall(context.disable)
            end,
        })

        -- Keymaps with pcall
        vim.keymap.set("n", "<leader>ut", function()
            pcall(context.toggle)
        end, { desc = "Toggle Context Window", silent = true })

        vim.keymap.set("n", "<leader>uc", function()
            if context.enabled() then
                pcall(context.disable)
            else
                pcall(context.enable)
            end
        end, { desc = "Toggle Context Display", silent = true })

        vim.keymap.set("n", "[c", function()
            pcall(context.go_to_context)
        end, { desc = "Jump to Context", silent = true })
    end,
}}
