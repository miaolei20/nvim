return {{
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim"
    },
    cmd = { "Neotree" },
    event = { "BufEnter", "VimEnter" },
    opts = {
        close_if_last_window = true,
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,
        window = {
            position = "left",
            width = 40
        },
        filesystem = {
            filtered_items = {
                visible = false,
                hide_dotfiles = true,
                hide_gitignored = true
            }
        }
    },
    config = function(_, opts)
        -- Debug logging
        local function debug_log(msg)
            if vim.g.debug_neotree then
                vim.notify("[Neo-tree] " .. msg, vim.log.levels.DEBUG)
            end
        end

        -- Setup Neo-tree
        require("neo-tree").setup(opts)
        debug_log("Neo-tree setup complete")

        -- Automatically open Neo-tree on startup (if configured)
        if opts.open_on_setup then
            vim.api.nvim_create_autocmd("VimEnter", {
                callback = function()
                    if vim.fn.argc() == 0 then
                        vim.cmd("Neotree show left")
                        debug_log("Neo-tree opened on startup")
                    end
                end,
                once = true
            })
        end

        -- Global keymaps
        local map = vim.keymap.set
        local opts_silent = { noremap = true, silent = true }

        map("n", "<leader>et", "<cmd>Neotree toggle left<CR>", opts_silent)
        map("n", "<leader>ef", "<cmd>Neotree focus left<CR>", opts_silent)
        map("n", "<leader>eg", "<cmd>Neotree git_status left<CR>", opts_silent)
        map("n", "<leader>eb", "<cmd>Neotree buffers left<CR>", opts_silent)

        debug_log("Global explorer mappings registered")

        -- Neo-tree buffer-local mappings
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "neo-tree",
            callback = function(args)
                local bmap = function(lhs, rhs, desc)
                    map("n", lhs, function()
                        vim.cmd("Neotree action=" .. rhs)
                    end, { buffer = args.buf, desc = desc, noremap = true, silent = true })
                end

                bmap("et", "toggle_node", "Toggle Node")
                bmap("eo", "open", "Open")
                bmap("ew", "open_with_window_picker", "Open in Window")
                bmap("ep", "toggle_preview", "Toggle Preview")
                bmap("ea", "add", "Add File")
                bmap("eA", "add_directory", "Add Directory")
                bmap("ed", "delete", "Delete")
                bmap("er", "rename", "Rename")
                bmap("ey", "copy_to_clipboard", "Copy to Clipboard")
                bmap("ex", "cut_to_clipboard", "Cut to Clipboard")
                bmap("es", "paste_from_clipboard", "Paste from Clipboard")
                bmap("ec", "copy", "Copy File")
                bmap("em", "move", "Move File")
                bmap("eq", "close_window", "Close Explorer")
                bmap("eR", "refresh", "Refresh")
                bmap("e?", "show_help", "Show Help")
                bmap("eh", "toggle_hidden", "Toggle Hidden")

                debug_log("Neo-tree buffer mappings registered for buffer " .. args.buf)
            end
        })
    end
}}

