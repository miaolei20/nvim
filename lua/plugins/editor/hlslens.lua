return {
    "kevinhwang91/nvim-hlslens",
    event = { "BufReadPost", "BufNewFile" },
    keys = { "n", "N", "*", "#", "/", "?" },
    dependencies = { "folke/which-key.nvim", optional = true },
    opts = {
        calm_down = true, -- Prevent lens jumping
        nearest_only = true, -- Highlight nearest match
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
            vim.notify("Failed to load nvim-hlslens", vim.log.levels.WARN)
            return
        end
        hlslens.setup(opts)

        local wk_ok, wk = pcall(require, "which-key")
        if wk_ok then
            wk.add({
                { "<leader>s", group = "Search", icon = "🔍" },
                { "<leader>sh", "<cmd>noh<CR>", desc = "Clear Search Highlight", mode = "n", icon = "🧹" },
            })
        else
            vim.notify("which-key not found, keybindings not registered", vim.log.levels.WARN)
        end
    end,
}