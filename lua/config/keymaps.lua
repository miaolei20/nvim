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
        vim.notify("无效的调整方向: " .. tostring(direction), vim.log.levels.WARN)
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
    debug_log("设置按键映射")

    -- Window navigation (normal and terminal modes)
    for _, mode in ipairs({"n", "t"}) do
        local mode_opts = vim.tbl_extend("force", opts, {
            desc = mode == "t" and "终端: 移动>左窗口" or "移动>左窗口"
        })
        vim.keymap.set(mode, "<C-h>", mode == "t" and "<C-\\><C-n><C-w>h" or "<C-w>h", mode_opts)
        mode_opts.desc = mode == "t" and "终端: 移动>下窗口" or "移动>下窗口"
        vim.keymap.set(mode, "<C-j>", mode == "t" and "<C-\\><C-n><C-w>j" or "<C-w>j", mode_opts)
        mode_opts.desc = mode == "t" and "终端: 移动>上窗口" or "移动>上窗口"
        vim.keymap.set(mode, "<C-k>", mode == "t" and "<C-\\><C-n><C-w>k" or "<C-w>k", mode_opts)
        mode_opts.desc = mode == "t" and "终端: 移动>右窗口" or "移动>右窗口"
        vim.keymap.set(mode, "<C-l>", mode == "t" and "<C-\\><C-n><C-w>l" or "<C-w>l", mode_opts)
    end

    -- Improved movement for wrapped lines
    vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", {
        noremap = true,
        silent = true,
        expr = true,
        desc = "向下移动（换行）"
    })
    vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", {
        noremap = true,
        silent = true,
        expr = true,
        desc = "向上移动（换行）"
    })

    -- Window management keymaps
    local mappings = {
        { modes = { "n" }, lhs = "<leader>wv", rhs = "<C-w>v", desc = "垂直分割" },
        { modes = { "n" }, lhs = "<leader>ws", rhs = "<C-w>s", desc = "水平分割" },
        { modes = { "n" }, lhs = "<leader>wh", rhs = function() resize_window("h") end, desc = "向左调整" },
        { modes = { "n" }, lhs = "<leader>wj", rhs = function() resize_window("j") end, desc = "向下调整" },
        { modes = { "n" }, lhs = "<leader>wk", rhs = function() resize_window("k") end, desc = "向上调整" },
        { modes = { "n" }, lhs = "<leader>wl", rhs = function() resize_window("l") end, desc = "向右调整" },
        { modes = { "n" }, lhs = "<leader>w[", rhs = "<C-o>", desc = "上一个位置" },
        { modes = { "n" }, lhs = "<leader>w]", rhs = "<C-i>", desc = "下一个位置" },
        { modes = { "n" }, lhs = "<leader>wm", rhs = toggle_maximize_window, desc = "切换最大化" },
    }

    -- Set window management keymaps
    for _, mapping in ipairs(mappings) do
        vim.keymap.set(mapping.modes, mapping.lhs, mapping.rhs, { desc = mapping.desc, noremap = true, silent = true })
    end

    debug_log("按键映射设置成功")
end

-- Initialize on VimEnter
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        debug_log("初始化按键映射模块")
        setup_keymaps()
    end,
    once = true
})

return M