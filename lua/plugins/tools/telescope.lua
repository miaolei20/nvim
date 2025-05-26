return {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
            cond = function()
                return vim.fn.executable("make") == 1
            end,
        },
        "nvim-telescope/telescope-file-browser.nvim",
        "debugloop/telescope-undo.nvim",
        "nvim-telescope/telescope-ui-select.nvim",
        { "folke/which-key.nvim", optional = true },
    },
    config = function()
        local telescope = require("telescope")
        local builtin = require("telescope.builtin")
        local pickers = require("telescope.pickers")
        local finders = require("telescope.finders")
        local conf = require("telescope.config").values
        local actions = require("telescope.actions")
        local state = require("telescope.actions.state")
        local themes = require("telescope.themes")

        -- Set diagnostic signs to avoid sign-define deprecation
        vim.diagnostic.config({
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = "✖",
                    [vim.diagnostic.severity.WARN] = "⚠",
                    [vim.diagnostic.severity.INFO] = "ℹ",
                    [vim.diagnostic.severity.HINT] = "➤",
                },
            },
        })

        -- Theme picker function
        local function theme_picker()
            local theme_list = {
                { name = "onedark", cmd = "colorscheme onedark" },
                { name = "catppuccin (dark)", cmd = "colorscheme catppuccin" },
                { name = "catppuccin (light)", cmd = "colorscheme catppuccin-latte" },
                { name = "tokyonight", cmd = "colorscheme tokyonight" },
                { name = "gruvbox", cmd = "colorscheme gruvbox" },
            }
            pickers.new(themes.get_dropdown({ previewer = false }), {
                prompt_title = "Select Theme",
                finder = finders.new_table({
                    results = theme_list,
                    entry_maker = function(entry)
                        return {
                            value = entry,
                            display = entry.name,
                            ordinal = entry.name,
                        }
                    end,
                }),
                sorter = conf.generic_sorter({}),
                attach_mappings = function(prompt_bufnr)
                    actions.select_default:replace(function()
                        local selection = state.get_selected_entry()
                        actions.close(prompt_bufnr)
                        if selection then
                            vim.cmd(selection.value.cmd)
                            vim.g.selected_theme = selection.value.cmd
                            vim.notify("Theme set: " .. selection.value.name, vim.log.levels.INFO)
                        end
                    end)
                    return true
                end,
            }):find()
        end

        -- Telescope setup
        telescope.setup({
            defaults = {
                layout_strategy = "horizontal",
                layout_config = {
                    horizontal = {
                        width = 0.95,
                        height = function(_, _, max_lines)
                            return math.min(max_lines, math.floor(vim.o.lines * 0.85))
                        end,
                        preview_width = 0.6,
                        prompt_position = "top",
                    },
                    vertical = {
                        width = 0.85,
                        height = function(_, _, max_lines)
                            return math.min(max_lines, math.floor(vim.o.lines * 0.85))
                        end,
                        prompt_position = "top",
                    },
                },
                path_display = { "smart" },
                file_ignore_patterns = { "%.git/", "node_modules/", "%.venv/", "%.cache/" },
                mappings = {
                    i = {
                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-k>"] = actions.move_selection_previous,
                        ["<Esc>"] = actions.close,
                        ["<CR>"] = actions.select_default,
                        ["<C-u>"] = actions.preview_scrolling_up,
                        ["<C-d>"] = actions.preview_scrolling_down,
                    },
                    n = {
                        ["q"] = actions.close,
                        ["<Esc>"] = actions.close,
                        ["<CR>"] = actions.select_default,
                    },
                },
                sorting_strategy = "ascending",
                set_env = { ["COLORTERM"] = "truecolor" },
                vimgrep_arguments = {
                    "rg",
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                    "--smart-case",
                    "--hidden",
                    "--glob=!.git/*",
                    "--glob=!node_modules/*",
                    "--glob=!.venv/*",
                    "--max-depth=5",
                },
            },
            pickers = {
                find_files = {
                    hidden = true,
                    no_ignore = false,
                    find_command = vim.fn.executable("fd") == 1 and {
                        "fd",
                        "--type=f",
                        "--strip-cwd-prefix",
                        "--hidden",
                        "--exclude=.git",
                        "--max-depth=5",
                    } or nil,
                },
                diagnostics = {
                    theme = "ivy",
                    layout_config = { height = 0.4 },
                    line_width = 0.8,
                },
                live_grep = {
                    only_sort_text = true,
                    max_results = 3000,
                },
                buffers = {
                    theme = "dropdown",
                    previewer = false,
                    sort_lastused = true,
                    mappings = {
                        i = { ["<C-d>"] = actions.delete_buffer },
                        n = { ["d"] = actions.delete_buffer },
                    },
                },
                oldfiles = {
                    theme = "dropdown",
                    previewer = false,
                    layout_config = { width = 0.8, height = 0.5 },
                },
            },
            extensions = {
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = "smart_case",
                },
                file_browser = {
                    hijack_netrw = true,
                    hidden = true,
                    grouped = true,
                    initial_mode = "normal",
                    path = "%:p:h",
                    respect_gitignore = true,
                    depth = 5,
                },
                ["ui-select"] = themes.get_dropdown({
                    previewer = false,
                    layout_config = { width = 0.8, height = 0.5 },
                }),
                undo = {
                    side_by_side = true,
                    layout_strategy = "vertical",
                    layout_config = { preview_height = 0.7 },
                },
            },
        })

        -- Load extensions with error handling
        local extensions = { "fzf", "file_browser", "undo", "ui-select" }
        for _, ext in ipairs(extensions) do
            local ok, err = pcall(telescope.load_extension, ext)
            if not ok then
                vim.notify("Failed to load Telescope extension: " .. ext .. " (" .. tostring(err) .. ")", vim.log.levels.WARN)
            end
        end

        -- Project files function
        local function project_files()
            local opts = {
                show_untracked = true,
                layout_config = {
                    height = function(_, _, max_lines)
                        return math.min(max_lines, math.max(15, math.floor(vim.o.lines * 0.7)))
                    end,
                },
            }
            local ok, result = pcall(vim.fn.systemlist, { "git", "rev-parse", "--is-inside-work-tree" })
            if ok and result[1] == "true" then
                builtin.git_files(opts)
            else
                builtin.find_files(opts)
            end
        end

        -- Register keybindings with which-key
        local ok, wk = pcall(require, "which-key")
        if ok then
            wk.add({
                { "<leader>s", group = "Search", icon = "🔍" },
                { "<leader>sf", project_files, desc = "Find Files", mode = "n", icon = "📁" },
                { "<leader>sg", builtin.live_grep, desc = "Live Grep", mode = "n", icon = "🔎" },
                { "<leader>sd", builtin.diagnostics, desc = "Diagnostics", mode = "n", icon = "🩺" },
                { "<leader>sb", telescope.extensions.file_browser.file_browser, desc = "File Browser", mode = "n", icon = "📂" },
                { "<leader>su", telescope.extensions.undo.undo, desc = "Undo History", mode = "n", icon = "🔄" },
                { "<leader>sr", builtin.oldfiles, desc = "Recent Files", mode = "n", icon = "🕒" },
                { "<leader>so", builtin.buffers, desc = "Open Buffers", mode = "n", icon = "📋" },
                { "<leader>st", theme_picker, desc = "Select Theme", mode = "n", icon = "🎨" },
            })
        else
            vim.notify("which-key not found, keybindings not registered", vim.log.levels.WARN)
        end
    end,
}
