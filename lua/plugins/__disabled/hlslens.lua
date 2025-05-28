return {
    "kevinhwang91/nvim-hlslens",
    event = { "BufReadPost", "BufNewFile" },
    keys = { "n", "N", "*", "#", "/", "?" },
    opts = {
        calm_down = true, -- 防止镜头跳动
        nearest_only = true, -- 高亮最近的匹配项
        override_lens = function(render, pos_list, nearest, idx, rel_idx)
            local sfw = vim.v.searchforward == 1
            local indicator = string.format("%d/%d", idx, #pos_list)
            local text = string.format("[%s %s]", indicator, nearest and "●" or "○")
            render.set_virt(0, pos_list[idx][1] - 1, pos_list[idx][2], { text = text, hl = sfw and "Search" or "IncSearch" })
        end,
    },
    config = function(_, opts)
        local ok, hlslens = pcall(require, "hlslens")
        if not ok then
            vim.notify("无法加载 nvim-hlslens", vim.log.levels.WARN)
            return
        end
        hlslens.setup(opts)

        -- 定义按键映射
        local mappings = {
            { modes = { "n" }, lhs = "<leader>sh", rhs = "<cmd>noh<CR>", desc = "清除搜索高亮" },
        }

        -- 设置按键映射
        for _, mapping in ipairs(mappings) do
            vim.keymap.set(mapping.modes, mapping.lhs, mapping.rhs, { desc = mapping.desc })
        end
    end
}