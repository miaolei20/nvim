local M = {}

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Keymap options
local opts = {
    noremap = true,
    silent = true
}

-- Debug logging (conditional)
local function debug_log(msg)
    if vim.g.debug_keymaps then
        vim.notify("[Keymaps] " .. msg, vim.log.levels.DEBUG)
    end
end

-- Window resize function
local function resize_window(direction, step)
    step = vim.v.count1 * (step or 2) -- Default step is 2 if not specified
    local win = vim.api.nvim_get_current_win()
    local actions = {
        h = {
            func = vim.api.nvim_win_set_width,
            get = vim.api.nvim_win_get_width,
            delta = -step
        },
        l = {
            func = vim.api.nvim_win_set_width,
            get = vim.api.nvim_win_get_width,
            delta = step
        },
        j = {
            func = vim.api.nvim_win_set_height,
            get = vim.api.nvim_win_get_height,
            delta = step
        },
        k = {
            func = vim.api.nvim_win_set_height,
            get = vim.api.nvim_win_get_height,
            delta = -step
        }
    }
    local action = actions[direction]
    if action then
        local current_size = action.get(win) -- Get current width or height
        action.func(win, current_size + action.delta) -- Set new size
    else
        vim.notify("Invalid resize direction: " .. tostring(direction), vim.log.levels.WARN)
    end
end

-- Toggle window maximize
local function toggle_maximize_window()
    local win = vim.api.nvim_get_current_win()
    if vim.w[win].maximized then
        vim.api.nvim_win_set_height(win, vim.w[win].maximized.height)
        vim.api.nvim_win_set_width(win, vim.w[win].maximized.width)
        vim.w[win].maximized = nil
    else
        vim.w[win].maximized = {
            height = vim.api.nvim_win_get_height(win),
            width = vim.api.nvim_win_get_width(win)
        }
        vim.api.nvim_win_set_height(win, vim.o.lines - 2)
        vim.api.nvim_win_set_width(win, vim.o.columns - 2)
    end
end

-- Setup keymaps
local function setup_keymaps()
    debug_log("Setting keymaps")

    -- Window navigation (normal and terminal modes)
    for _, mode in ipairs({"n", "t"}) do
        local mode_opts = vim.tbl_extend("force", opts, {
            desc = mode == "t" and "Terminal: Move to left window" or "Move to left window"
        })
        vim.keymap.set(mode, "<C-h>", mode == "t" and "<C-\\><C-n><C-w>h" or "<C-w>h", mode_opts)
        mode_opts.desc = mode == "t" and "Terminal: Move to lower window" or "Move to lower window"
        vim.keymap.set(mode, "<C-j>", mode == "t" and "<C-\\><C-n><C-w>j" or "<C-w>j", mode_opts)
        mode_opts.desc = mode == "t" and "Terminal: Move to upper window" or "Move to upper window"
        vim.keymap.set(mode, "<C-k>", mode == "t" and "<C-\\><C-n><C-w>k" or "<C-w>k", mode_opts)
        mode_opts.desc = mode == "t" and "Terminal: Move to right window" or "Move to right window"
        vim.keymap.set(mode, "<C-l>", mode == "t" and "<C-\\><C-n><C-w>l" or "<C-w>l", mode_opts)
    end

    -- Improved movement for wrapped lines
    vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", {
        noremap = true,
        silent = true,
        expr = true,
        desc = "Move down (wrapped line)"
    })
    vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", {
        noremap = true,
        silent = true,
        expr = true,
        desc = "Move up (wrapped line)"
    })

    -- Window management keymaps
    local mappings = {
        { modes = { "n" }, lhs = "<leader>wv", rhs = "<C-w>v", desc = "Vertical split" },
        { modes = { "n" }, lhs = "<leader>ws", rhs = "<C-w>s", desc = "Horizontal split" },
        { modes = { "n" }, lhs = "<leader>wh", rhs = function() resize_window("h") end, desc = "Resize left" },
        { modes = { "n" }, lhs = "<leader>wj", rhs = function() resize_window("j") end, desc = "Resize down" },
        { modes = { "n" }, lhs = "<leader>wk", rhs = function() resize_window("k") end, desc = "Resize up" },
        { modes = { "n" }, lhs = "<leader>wl", rhs = function() resize_window("l") end, desc = "Resize right" },
        { modes = { "n" }, lhs = "<leader>w[", rhs = "<C-o>", desc = "Previous location" },
        { modes = { "n" }, lhs = "<leader>w]", rhs = "<C-i>", desc = "Next location" },
        { modes = { "n" }, lhs = "<leader>wm", rhs = toggle_maximize_window, desc = "Toggle maximize" },
    }

    -- Set window management keymaps
    for _, mapping in ipairs(mappings) do
        vim.keymap.set(mapping.modes, mapping.lhs, mapping.rhs, { desc = mapping.desc, noremap = true, silent = true })
    end

    debug_log("Keymaps set successfully")
end

-- Initialize on VimEnter
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        debug_log("Initialize keymaps module")
        setup_keymaps()
    end,
    once = true
})

return M