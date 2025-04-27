return {{
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    event = {"BufReadPre", "BufNewFile"},
    dependencies = {"nvim-lua/plenary.nvim", {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
            return vim.fn.executable("make") == 1
        end
    }, "nvim-telescope/telescope-file-browser.nvim", "debugloop/telescope-undo.nvim",
                    "nvim-telescope/telescope-ui-select.nvim", "folke/which-key.nvim"},
    config = function()
        local telescope = require("telescope")
        local builtin = require("telescope.builtin")
        local pickers = require("telescope.pickers")
        local finders = require("telescope.finders")
        local conf = require("telescope.config").values
        local actions = require("telescope.actions")
        local state = require("telescope.actions.state")
        local themes = require("telescope.themes")

        -- 定义主题选择器函数
        local function theme_picker()
            local theme_list = {{
                name = "onedark",
                cmd = "colorscheme onedark"
            }, {
                name = "catppuccin (dark)",
                cmd = "colorscheme catppuccin"
            }, {
                name = "catppuccin (light)",
                cmd = "colorscheme catppuccin-latte"
            }, {
                name = "tokyonight",
                cmd = "colorscheme tokyonight"
            }, {
                name = "gruvbox",
                cmd = "colorscheme gruvbox"
            }}
            pickers.new(themes.get_dropdown({
                previewer = false
            }), {
                prompt_title = "选择主题",
                finder = finders.new_table({
                    results = theme_list,
                    entry_maker = function(entry)
                        return {
                            value = entry,
                            display = entry.name,
                            ordinal = entry.name
                        }
                    end
                }),
                sorter = conf.generic_sorter({}),
                attach_mappings = function(prompt_bufnr)
                    actions.select_default:replace(function()
                        local selection = state.get_selected_entry()
                        actions.close(prompt_bufnr)
                        if selection then
                            vim.cmd(selection.value.cmd)
                            -- 保存选择的主题到文件
                            local selected_theme_file = vim.fn.stdpath("config") .. "/selected_theme.txt"
                            local ok, err = pcall(vim.fn.writefile, {selection.value.cmd}, selected_theme_file)
                            if ok then
                                vim.notify("主题已保存: " .. selection.value.cmd, vim.log.levels.INFO)
                            else
                                vim.notify("保存主题失败: " .. tostring(err), vim.log.levels.ERROR)
                            end
                        end
                    end)
                    return true
                end
            }):find()
        end

        -- Telescope 配置
        telescope.setup({
            defaults = {
                layout_strategy = "horizontal",
                layout_config = {
                    horizontal = {
                        width = 0.95,
                        height = 0.85,
                        preview_width = 0.6,
                        prompt_position = "top"
                    },
                    vertical = {
                        width = 0.85,
                        height = 0.85,
                        prompt_position = "top"
                    }
                },
                path_display = {"smart"},
                file_ignore_patterns = {"^.git/", "^node_modules/", "^.venv/", "^.cache/"},
                mappings = {
                    i = {
                        ["<C-j>"] = "move_selection_next",
                        ["<C-k>"] = "move_selection_previous",
                        ["<Esc>"] = "close",
                        ["<CR>"] = "select_default",
                        ["<C-u>"] = "preview_scrolling_up",
                        ["<C-d>"] = "preview_scrolling_down"
                    },
                    n = {
                        ["q"] = "close",
                        ["<Esc>"] = "close",
                        ["<CR>"] = "select_default"
                    }
                },
                sorting_strategy = "ascending",
                set_env = {
                    ["COLORTERM"] = "truecolor"
                },
                vimgrep_arguments = {"rg", "--color=never", "--no-heading", "--with-filename", "--line-number",
                                     "--column", "--smart-case", "--hidden", "--glob=!.git/*", "--glob=!node_modules/*",
                                     "--glob=!.venv/*", "--max-depth=5", "--threads=0", "--mmap"}
            },
            pickers = {
                find_files = {
                    hidden = true,
                    no_ignore = false,
                    find_command = {"fd", "--type=f", "--strip-cwd-prefix", "--hidden", "--exclude=.git",
                                    "--max-depth=5"}
                },
                diagnostics = {
                    theme = "ivy",
                    layout_config = {
                        height = 0.4
                    },
                    line_width = 0.8
                },
                live_grep = {
                    only_sort_text = true,
                    max_results = 3000
                },
                buffers = {
                    theme = "dropdown",
                    previewer = false,
                    sort_lastused = true,
                    mappings = {
                        i = {
                            ["<C-d>"] = "delete_buffer"
                        },
                        n = {
                            ["d"] = "delete_buffer"
                        }
                    }
                },
                oldfiles = {
                    theme = "dropdown",
                    previewer = false,
                    layout_config = {
                        width = 0.8,
                        height = 0.5
                    }
                }
            },
            extensions = {
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = "smart_case"
                },
                file_browser = {
                    hijack_netrw = true,
                    hidden = true,
                    grouped = true,
                    initial_mode = "normal",
                    path = "%:p:h",
                    respect_gitignore = true,
                    depth = 5
                },
                ["ui-select"] = themes.get_dropdown({
                    previewer = false,
                    layout_config = {
                        width = 0.8,
                        height = 0.5
                    }
                }),
                undo = {
                    side_by_side = true,
                    layout_strategy = "vertical",
                    layout_config = {
                        preview_height = 0.7
                    }
                }
            }
        })

        -- 异步加载扩展
        vim.defer_fn(function()
            local extensions = {"fzf", "file_browser", "undo", "ui-select"}
            for _, ext in ipairs(extensions) do
                local ok, err = pcall(telescope.load_extension, ext)
                if not ok then
                    vim.notify("无法加载 Telescope 扩展: " .. ext .. " (" .. tostring(err) .. ")",
                        vim.log.levels.WARN)
                end
            end
        end, 100)

        -- 项目文件搜索函数
        local is_inside_work_tree = {}
        local function project_files()
            local win_height = vim.api.nvim_win_get_height(0)
            local safe_height = math.max(15, math.floor(win_height * 0.7))
            local opts = {
                show_untracked = true,
                layout_config = {
                    height = safe_height
                }
            }
            local cwd = vim.fn.getcwd()
            if is_inside_work_tree[cwd] ~= nil then
                if is_inside_work_tree[cwd] then
                    builtin.git_files(opts)
                else
                    builtin.find_files(opts)
                end
            else
                vim.system({"git", "rev-parse", "--is-inside-work-tree"}, {
                    text = true
                }, function(obj)
                    is_inside_work_tree[cwd] = obj.code == 0
                    vim.schedule(function()
                        if is_inside_work_tree[cwd] then
                            builtin.git_files(opts)
                        else
                            builtin.find_files(opts)
                        end
                    end)
                end)
            end
        end

        -- 使用 which-key 设置快捷键
        local wk = require("which-key")
        wk.add({{
            "<leader>s",
            group = "搜索",
            icon = "🔍"
        }, {
            "<leader>sf",
            project_files,
            desc = "查找文件",
            mode = "n",
            icon = "📁"
        }, {
            "<leader>sg",
            function()
                builtin.live_grep()
            end,
            desc = "实时搜索",
            mode = "n",
            icon = "🔎"
        }, {
            "<leader>sd",
            function()
                builtin.diagnostics()
            end,
            desc = "诊断",
            mode = "n",
            icon = "🩺"
        }, {
            "<leader>sb",
            function()
                telescope.extensions.file_browser.file_browser()
            end,
            desc = "文件浏览器",
            mode = "n",
            icon = "📂"
        }, {
            "<leader>su",
            function()
                telescope.extensions.undo.undo()
            end,
            desc = "撤销历史",
            mode = "n",
            icon = "🔄"
        }, {
            "<leader>sr",
            function()
                builtin.oldfiles()
            end,
            desc = "最近文件",
            mode = "n",
            icon = "🕒"
        }, {
            "<leader>so",
            function()
                builtin.buffers()
            end,
            desc = "打开缓冲区",
            mode = "n",
            icon = "📋"
        }, {
            "<leader>st",
            theme_picker,
            desc = "选择主题",
            mode = "n",
            icon = "🎨"
        }})
    end
}}
