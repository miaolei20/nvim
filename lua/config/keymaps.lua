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
    debug_log("Setting up keymaps")

    -- Window navigation (normal and terminal modes)
    for _, mode in ipairs({"n", "t"}) do
        local mode_opts = vim.tbl_extend("force", opts, {
            desc = mode == "t" and "Terminal: Move>Left Window" or "Move>Left Window"
        })
        vim.keymap.set(mode, "<C-h>", mode == "t" and "<C-\\><C-n><C-w>h" or "<C-w>h", mode_opts)
        mode_opts.desc = mode == "t" and "Terminal: Move>Lower Window" or "Move>Lower Window"
        vim.keymap.set(mode, "<C-j>", mode == "t" and "<C-\\><C-n><C-w>j" or "<C-w>j", mode_opts)
        mode_opts.desc = mode == "t" and "Terminal: Move>Upper Window" or "Move>Upper Window"
        vim.keymap.set(mode, "<C-k>", mode == "t" and "<C-\\><C-n><C-w>k" or "<C-w>k", mode_opts)
        mode_opts.desc = mode == "t" and "Terminal: Move>Right Window" or "Move>Right Window"
        vim.keymap.set(mode, "<C-l>", mode == "t" and "<C-\\><C-n><C-w>l" or "<C-w>l", mode_opts)
    end

    -- Improved movement for wrapped lines
    vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", {
        noremap = true,
        silent = true,
        expr = true,
        desc = "Move Down (Wrap)"
    })
    vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", {
        noremap = true,
        silent = true,
        expr = true,
        desc = "Move Up (Wrap)"
    })

    -- Window management keymaps with which-key
    local ok, wk = pcall(require, "which-key")
    if not ok then
        vim.notify("which-key not found, using minimal keymaps", vim.log.levels.WARN)
        -- Fallback keymaps
        vim.keymap.set("n", "<leader>wv", "<C-w>v", vim.tbl_extend("force", opts, {
            desc = "Split Vertically"
        }))
        vim.keymap.set("n", "<leader>ws", "<C-w>s", vim.tbl_extend("force", opts, {
            desc = "Split Horizontally"
        }))
        return
    end

    -- Define window keymaps directly with which-key
    wk.add({{
        "<leader>w",
        group = "Window",
        icon = "🪟"
    }, {
        "<leader>wv",
        "<C-w>v",
        desc = "Split Vertically",
        mode = "n",
        icon = "🪓"
    }, {
        "<leader>ws",
        "<C-w>s",
        desc = "Split Horizontally",
        mode = "n",
        icon = "🪚"
    }, {
        "<leader>wh",
        function()
            resize_window("h")
        end,
        desc = "Resize Left",
        mode = "n",
        icon = "⬅️"
    }, {
        "<leader>wj",
        function()
            resize_window("j")
        end,
        desc = "Resize Down",
        mode = "n",
        icon = "⬇️"
    }, {
        "<leader>wk",
        function()
            resize_window("k")
        end,
        desc = "Resize Up",
        mode = "n",
        icon = "⬆️"
    }, {
        "<leader>wl",
        function()
            resize_window("l")
        end,
        desc = "Resize Right",
        mode = "n",
        icon = "➡️"
    }, {
        "<leader>w[",
        "<C-o>",
        desc = "Previous Location",
        mode = "n",
        icon = "⏮️"
    }, {
        "<leader>w]",
        "<C-i>",
        desc = "Next Location",
        mode = "n",
        icon = "⏭️"
    }, {
        "<leader>wm",
        toggle_maximize_window,
        desc = "Toggle Maximize",
        mode = "n",
        icon = "↔️"
    }})
    debug_log("Keymaps registered successfully with which-key")
end

-- Initialize on VimEnter
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        debug_log("Initializing keymaps module")
        setup_keymaps()
    end,
    once = true
})

return M
