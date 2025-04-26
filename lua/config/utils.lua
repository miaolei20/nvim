-- lua/config/utils.lua
local M = {}

-- 切换 colorscheme
M.switch_theme = function(theme)
    vim.cmd("colorscheme " .. theme)
    vim.notify("Switched to theme: " .. theme, vim.log.levels.INFO)
end

-- 用 Telescope 弹窗选择 theme
M.pick_theme = function()
    local themes = {"onedark", "tokyonight", "gruvbox", "catppuccin", "rose-pine", "nightfox", "nord", "everforest"}

    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")
    local conf = require("telescope.config").values

    pickers.new({}, {
        prompt_title = "Switch Colorscheme",
        finder = finders.new_table {
            results = themes
        },
        sorter = conf.generic_sorter({}),
        attach_mappings = function(_, map)
            actions.select_default:replace(function()
                actions.close()
                local selection = action_state.get_selected_entry()
                if selection then
                    M.switch_theme(selection[1])
                end
            end)
            return true
        end
    }):find()
end

return M
