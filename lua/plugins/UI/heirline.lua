return {{
    "kyazdani42/nvim-web-devicons",
    event = {"BufReadPost", "BufNewFile"},
    config = function()
        require("nvim-web-devicons").setup({
            default = true
        })
    end
}, {
    "rebelot/heirline.nvim",
    event = {"BufReadPost", "BufNewFile", "VimEnter"},
    dependencies = {"kyazdani42/nvim-web-devicons"},
    config = function()
        local heirline = require("heirline")
        local conditions = require("heirline.conditions")
        local utils = require("heirline.utils")
        local devicons = require("nvim-web-devicons")

        -- UI Settings
        vim.opt.mouse = "a"
        vim.opt.showtabline = 2
        vim.opt.ruler = false
        vim.opt.showmode = false

        -- Theme Detection
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

        -- Optimized Theme Palettes
        local theme_palettes = {
            onedark = {
                bg = "#282c34", -- Dark background
                fg = "#abb2bf", -- Light text
                bg_alt = "#23272e", -- Slightly lighter inactive
                fg_alt = "#6b7280", -- Muted text
                blue = "#61afef",
                green = "#98c379",
                purple = "#c678dd",
                yellow = "#e5c07b",
                red = "#e06c75",
                accent = "#5fabad", -- Very soft cyan
                border = "#353941" -- Subtle border
            },
            catppuccin = {
                bg = "#1e1e2e", -- Mocha base
                fg = "#cdd6f4", -- Mocha text
                bg_alt = "#1b1b29", -- Slightly lighter crust
                fg_alt = "#6b7280", -- Mocha overlay1
                blue = "#89b4fa",
                green = "#a6e3a1",
                purple = "#f5c2e7",
                yellow = "#f9e2af",
                red = "#f38ba8",
                accent = "#8ac6be", -- Very soft teal
                border = "#262638" -- Subtle border
            },
            ["catppuccin-latte"] = {
                bg = "#eff1f5", -- Latte base
                fg = "#16202f", -- Darker text
                bg_alt = "#d4d8de", -- Slightly darker surface0
                fg_alt = "#64748b", -- Darker overlay1
                blue = "#1e66f5",
                green = "#40a02b",
                purple = "#8839ef",
                yellow = "#df8e1d",
                red = "#d20f39",
                accent = "#5fabad", -- Very soft teal
                border = "#caced6" -- Subtle border
            },
            tokyonight = {
                bg = "#1a1b26", -- Night base
                fg = "#c0caf5", -- Night text
                bg_alt = "#1c1e2a", -- Slightly lighter darker
                fg_alt = "#6b7280", -- Night comment
                blue = "#7aa2f7",
                green = "#9ece6a",
                purple = "#bb9af7",
                yellow = "#e0af68",
                red = "#f7768e",
                accent = "#6ba8d1", -- Very soft cyan
                border = "#272a36" -- Subtle border
            },
            gruvbox = {
                bg = "#282828", -- Dark bg0
                fg = "#ebdbb2", -- Light fg
                bg_alt = "#242424", -- Slightly lighter bg1
                fg_alt = "#6b7280", -- Gray
                blue = "#458588",
                green = "#b8bb26",
                purple = "#b16286",
                yellow = "#fabd2f",
                red = "#cc241d",
                accent = "#769e9e", -- Very soft blue-green
                border = "#363430" -- Subtle border
            }
        }

        -- Get Colors
        local function get_colors()
            local theme = get_current_theme()
            return theme_palettes[theme] or theme_palettes.onedark
        end

        -- Icons
        local icons = {
            mode = "󰀘",
            folder = "󰉋",
            file = "󰈔",
            branch = "󰊢",
            lsp = "󰒋",
            modified = "󰀬",
            separator = "󰿟",
            close = "󰅖",
            diagnostics = {
                error = "󰅚",
                warn = "󰀪",
                info = "󰋽",
                hint = "󰌶"
            }
        }

        -- Highlight Groups
        local function set_highlights()
            local c = get_colors()
            local hl_groups = {
                HeirlineBase = {
                    bg = c.bg,
                    fg = c.fg
                },
                HeirlineInactive = {
                    bg = c.bg,
                    fg = c.fg_alt
                },
                HeirlineActive = {
                    bg = c.border,
                    fg = c.fg,
                    bold = false
                },
                HeirlineTabLine = {
                    bg = c.bg,
                    fg = c.fg_alt
                },
                HeirlineTabLineSel = {
                    bg = c.border,
                    fg = c.fg,
                    bold = false
                },
                HeirlineWinBar = {
                    bg = c.bg,
                    fg = c.fg
                },
                HeirlineAccent = {
                    fg = c.fg,
                    bg = c.accent
                },
                HeirlineCloseButton = {
                    fg = c.red,
                    bg = c.bg
                }
            }
            for group, opts in pairs(hl_groups) do
                pcall(vim.api.nvim_set_hl, 0, group, opts)
            end
        end
        set_highlights()

        -- Refresh on Theme Change
        vim.api.nvim_create_autocmd("ColorScheme", {
            callback = function()
                set_highlights()
                vim.defer_fn(function()
                    pcall(vim.cmd, "redrawstatus")
                    pcall(vim.cmd, "redrawtabline")
                end, 0)
            end
        })

        -- Utilities
        local Space = {
            provider = " "
        }
        local Align = {
            provider = "%="
        }
        local icon_cache = {}

        local function get_icon(filename, filetype, opts)
            local key = (filename or "") .. (filetype or "") .. (opts and opts.default and "default" or "")
            if icon_cache[key] then
                return icon_cache[key].icon, icon_cache[key].color
            end
            local icon, hl_group = devicons.get_icon(filename, filetype, opts)
            icon = icon or icons.file
            local icon_color
            if hl_group then
                local success, hl = pcall(vim.api.nvim_get_hl_by_name, hl_group, true)
                icon_color = success and hl.foreground and string.format("#%06x", hl.foreground)
            end
            icon_color = icon_color or get_colors().fg
            icon_cache[key] = {
                icon = icon,
                color = icon_color
            }
            return icon, icon_color
        end

        local function shorten_path(path)
            if path == "" then
                return ""
            end
            local home = vim.fn.expand("~")
            path = path:gsub("^" .. home, "~")
            local parts = vim.split(path, "/")
            if #parts <= 3 then
                return path
            end
            return table.concat({parts[1], "…", parts[#parts - 1], parts[#parts]}, "/")
        end

        -- Components
        local Mode = {
            init = function(self)
                self.mode = vim.fn.mode(1)
                local c = get_colors()
                self.mode_color = ({
                    n = c.blue,
                    i = c.green,
                    v = c.purple,
                    V = c.purple,
                    ["\22"] = c.purple,
                    c = c.yellow,
                    s = c.yellow,
                    S = c.yellow,
                    ["\19"] = c.yellow,
                    R = c.red,
                    r = c.red,
                    ["!"] = c.red,
                    t = c.red
                })[self.mode] or c.blue
            end,
            static = {
                mode_names = {
                    n = "N",
                    i = "I",
                    v = "V",
                    V = "VL",
                    ["\22"] = "VB",
                    c = "C",
                    s = "S",
                    S = "SL",
                    ["\19"] = "SB",
                    R = "R",
                    r = "R",
                    ["!"] = "SH",
                    t = "T"
                }
            },
            provider = function(self)
                return icons.mode .. " " .. (self.mode_names[self.mode] or "U") .. " "
            end,
            hl = function(self)
                return {
                    fg = self.mode_color,
                    bg = get_colors().border
                }
            end,
            update = {"ModeChanged"}
        }

        local FileName = {
            provider = function()
                local name = vim.fn.expand("%:t")
                return name ~= "" and name or "Dashboard"
            end,
            hl = "HeirlineBase",
            update = {"BufEnter"}
        }

        local AlphaStatusLine = {
            condition = function()
                return vim.bo.buftype == "alpha"
            end,
            hl = {
                bg = get_colors().bg
            },
            Mode,
            Space,
            FileName,
            Align
        }

        local GitBranch = {
            condition = conditions.is_git_repo,
            init = function(self)
                self.status = vim.b.gitsigns_status_dict or {}
            end,
            provider = function(self)
                local head = self.status.head
                return icons.branch .. " " .. (head and head ~= "" and head or "none") .. " "
            end,
            hl = {
                fg = get_colors().green,
                bg = get_colors().bg
            },
            update = {
                "User",
                pattern = "GitSignsChanged"
            }
        }

        local ModifiedIndicator = {
            condition = function()
                return vim.bo.modified
            end,
            provider = icons.modified .. " ",
            hl = {
                fg = get_colors().yellow,
                bg = get_colors().bg
            },
            update = {"BufModifiedSet"}
        }

        local LSPClients = {
            condition = function()
                return next(vim.lsp.get_clients({
                    bufnr = 0
                })) ~= nil
            end,
            provider = function()
                local names = vim.tbl_map(function(c)
                    return c.name
                end, vim.lsp.get_clients({
                    bufnr = 0
                }))
                return icons.lsp .. " " .. (#names > 0 and table.concat(names, ", ") or "none") .. " "
            end,
            hl = {
                fg = get_colors().purple,
                bg = get_colors().bg
            },
            update = {"LspAttach", "LspDetach"}
        }

        local Diagnostics = {
            condition = conditions.has_diagnostics,
            static = {
                icons = icons.diagnostics
            },
            init = function(self)
                self.errors = #vim.diagnostic.get(0, {
                    severity = vim.diagnostic.severity.ERROR
                })
                self.warnings = #vim.diagnostic.get(0, {
                    severity = vim.diagnostic.severity.WARN
                })
                self.info = #vim.diagnostic.get(0, {
                    severity = vim.diagnostic.severity.INFO
                })
                self.hints = #vim.diagnostic.get(0, {
                    severity = vim.diagnostic.severity.HINT
                })
            end,
            provider = function(self)
                local parts = {}
                if self.errors > 0 then
                    table.insert(parts, self.icons.error .. self.errors)
                end
                if self.warnings > 0 then
                    table.insert(parts, self.icons.warn .. self.warnings)
                end
                if self.info > 0 then
                    table.insert(parts, self.icons.info .. self.info)
                end
                if self.hints > 0 then
                    table.insert(parts, self.icons.hint .. self.hints)
                end
                return #parts > 0 and table.concat(parts, " ") .. " " or ""
            end,
            hl = function(self)
                local c = get_colors()
                return {
                    fg = self.errors > 0 and c.red or self.warnings > 0 and c.yellow or self.info > 0 and c.blue or
                        c.green,
                    bg = c.bg
                }
            end,
            update = {"DiagnosticChanged"},
            on_click = {
                callback = function()
                    vim.cmd("Trouble diagnostics toggle")
                end,
                name = "heirline_diagnostics"
            }
        }

        local FileType = {
            init = function(self)
                self.filetype = vim.bo.filetype
                self.icon, self.icon_color = get_icon(nil, self.filetype, {
                    default = true
                })
            end,
            provider = function(self)
                return self.icon .. " " .. (self.filetype ~= "" and self.filetype or "none") .. " "
            end,
            hl = function(self)
                return {
                    fg = self.icon_color,
                    bg = get_colors().bg
                }
            end,
            update = {"BufEnter"}
        }

        local FileInfo = {
            provider = function()
                local enc = (vim.bo.fileencoding ~= "" and vim.bo.fileencoding) or vim.o.encoding
                local size = vim.fn.getfsize(vim.fn.expand("%:p"))
                if size < 0 then
                    return enc:upper() .. " "
                end
                local units = {"B", "KB", "MB", "GB"}
                local i = 1
                while size >= 1024 and i < #units do
                    size = size / 1024
                    i = i + 1
                end
                return string.format("%s %s %.1f%s ", enc:upper(), icons.separator, size, units[i])
            end,
            hl = {
                fg = get_colors().blue,
                bg = get_colors().bg
            },
            update = {"BufEnter", "BufWritePost"}
        }

        local Location = {{
            provider = "󰆌 ",
            hl = {
                fg = get_colors().fg,
                bg = get_colors().border
            }
        }, {
            provider = function()
                return vim.fn.line(".") .. ":" .. vim.fn.col(".") .. " "
            end,
            hl = {
                fg = get_colors().fg,
                bg = get_colors().border
            },
            update = {"CursorMoved"}
        }}

        local BufferComponent = {
            init = function(self)
                self.bufnr = self.bufnr or vim.api.nvim_get_current_buf()
                self.filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(self.bufnr), ":t")
                self.modified = vim.bo[self.bufnr].modified and icons.modified or ""
                self.is_active = vim.api.nvim_get_current_buf() == self.bufnr
                self.icon, self.icon_color = get_icon(self.filename, nil, {
                    default = true
                })
            end,
            {
                provider = icons.separator .. " ",
                hl = function(self)
                    local c = get_colors()
                    return {
                        fg = self.is_active and c.accent or c.fg_alt,
                        bg = c.bg
                    }
                end
            },
            {
                provider = function(self)
                    return
                        self.icon .. " " .. (self.filename ~= "" and self.filename or "[No Name]") .. self.modified ..
                            " "
                end,
                hl = function(self)
                    local c = get_colors()
                    return {
                        fg = self.is_active and c.fg or c.fg_alt,
                        bg = self.is_active and c.border or c.bg
                    }
                end,
                on_click = {
                    callback = function(_, minwid)
                        if vim.api.nvim_buf_is_valid(minwid) then
                            vim.api.nvim_set_current_buf(minwid)
                        end
                    end,
                    name = function(self)
                        return "buf_" .. self.bufnr
                    end,
                    minwid = function(self)
                        return self.bufnr
                    end
                }
            },
            {
                provider = icons.close .. " ",
                hl = function(self)
                    local c = get_colors()
                    return {
                        fg = c.red,
                        bg = self.is_active and c.border or c.bg
                    }
                end,
                on_click = {
                    callback = function(_, minwid)
                        if vim.api.nvim_buf_is_valid(minwid) then
                            vim.api.nvim_buf_delete(minwid, {
                                force = true
                            })
                        end
                    end,
                    name = function(self)
                        return "close_buf_" .. self.bufnr
                    end,
                    minwid = function(self)
                        return self.bufnr
                    end
                }
            },
            update = {"BufEnter", "BufDelete"}
        }

        local Buffers = {
            condition = function()
                return #vim.tbl_filter(function(buf)
                    return vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted
                end, vim.api.nvim_list_bufs()) > 1
            end,
            utils.make_buflist(BufferComponent)
        }

        local TabComponent = {
            init = function(self)
                self.tabpage = self.tabpage or vim.api.nvim_get_current_tabpage()
                self.is_active = self.tabpage == vim.api.nvim_get_current_tabpage()
                self.tabnr = vim.api.nvim_tabpage_get_number(self.tabpage)
            end,
            {
                provider = icons.separator .. " ",
                hl = function(self)
                    local c = get_colors()
                    return {
                        fg = self.is_active and c.accent or c.fg_alt,
                        bg = c.bg
                    }
                end
            },
            {
                provider = function(self)
                    return "󰓩 " .. self.tabnr .. " "
                end,
                hl = function(self)
                    local c = get_colors()
                    return {
                        fg = self.is_active and c.fg or c.fg_alt,
                        bg = self.is_active and c.border or c.bg
                    }
                end,
                on_click = {
                    callback = function(_, minwid)
                        if vim.api.nvim_tabpage_is_valid(minwid) then
                            vim.api.nvim_set_current_tabpage(minwid)
                        end
                    end,
                    name = function(self)
                        return "tab_" .. self.tabpage
                    end,
                    minwid = function(self)
                        return self.tabpage
                    end
                }
            },
            {
                provider = icons.close .. " ",
                hl = function(self)
                    local c = get_colors()
                    return {
                        fg = c.red,
                        bg = self.is_active and c.border or c.bg
                    }
                end,
                on_click = {
                    callback = function(_, minwid)
                        if vim.api.nvim_tabpage_is_valid(minwid) then
                            local tabnr = vim.api.nvim_tabpage_get_number(minwid)
                            vim.cmd("tabclose " .. tabnr)
                        end
                    end,
                    name = function(self)
                        return "close_tab_" .. self.tabpage
                    end,
                    minwid = function(self)
                        return self.tabpage
                    end
                }
            },
            update = {"TabEnter", "TabClosed"}
        }

        local Tabs = {
            condition = function()
                return #vim.api.nvim_list_tabpages() >= 2
            end,
            utils.make_tablist(TabComponent)
        }

        local TabClose = {
            condition = function()
                return #vim.api.nvim_list_tabpages() > 1
            end,
            provider = icons.close .. " ",
            hl = {
                fg = get_colors().red,
                bg = get_colors().bg
            },
            on_click = {
                callback = function()
                    vim.cmd("tabclose")
                end,
                name = "tab_close"
            }
        }

        local WinBarFilePath = {
            init = function(self)
                self.bufnr = vim.api.nvim_get_current_buf()
                local full_path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(self.bufnr), ":~:.")
                self.filepath = shorten_path(full_path)
                self.filename = vim.fn.fnamemodify(full_path, ":t")
                self.icon, self.icon_color = get_icon(self.filename, nil, {
                    default = true
                })
            end,
            provider = function(self)
                return icons.folder .. " " .. (self.filepath ~= "" and self.filepath or "Dashboard") .. " "
            end,
            hl = function(self)
                return {
                    fg = self.icon_color,
                    bg = get_colors().bg,
                    italic = true
                }
            end,
            update = {"BufEnter", "DirChanged"},
            on_click = {
                callback = function(_, minwid)
                    if vim.api.nvim_buf_is_valid(minwid) then
                        vim.api.nvim_set_current_buf(minwid)
                    else
                        vim.notify("Invalid buffer", vim.log.levels.WARN)
                    end
                end,
                name = function(self)
                    return "winbar_buf_" .. self.bufnr
                end,
                minwid = function(self)
                    return self.bufnr
                end
            }
        }

        local WinBar = {
            condition = function()
                return not vim.bo.buftype:match("^(quickfix|nofile|help|terminal|alpha)$")
            end,
            Space,
            WinBarFilePath,
            Align
        }

        local DefaultStatusLine = {
            condition = function()
                return not vim.bo.buftype:match("alpha")
            end,
            hl = {
                bg = get_colors().bg
            },
            Mode,
            Space,
            {
                hl = {
                    bg = get_colors().bg
                },
                GitBranch,
                Space,
                FileName,
                ModifiedIndicator,
                Space,
                LSPClients
            },
            Align,
            {
                hl = {
                    bg = get_colors().bg
                },
                Diagnostics,
                Space,
                FileType,
                Space,
                FileInfo,
                Space,
                Location
            }
        }

        local TabLine = {
            condition = function()
                return not vim.bo.buftype:match("alpha")
            end,
            hl = {
                bg = get_colors().bg
            },
            Space,
            Buffers,
            Align,
            Tabs,
            Space,
            TabClose
        }

        -- Heirline Setup
        heirline.setup({
            statusline = {AlphaStatusLine, DefaultStatusLine},
            tabline = TabLine,
            winbar = WinBar,
            opts = {
                disable_winbar_cb = function(args)
                    local buftype = vim.bo[args.buf].buftype
                    return vim.fn.bufname(args.buf) == "" or buftype == "alpha" or conditions.buffer_matches({
                        buftype = {"quickfix", "nofile", "help", "terminal"}
                    }, args.buf)
                end
            }
        })

        -- Ensure statusline is always shown
        vim.api.nvim_create_autocmd("VimEnter", {
            callback = function()
                vim.opt.laststatus = 2
            end
        })
    end
}}
