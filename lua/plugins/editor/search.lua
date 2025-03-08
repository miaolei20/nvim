return {
  {
    "kevinhwang91/nvim-hlslens",
    config = function()
      -- 设置高亮组，采用现代配色方案
      vim.api.nvim_set_hl(0, "HlSearchLens", {
        fg = "#61afef",  -- onedark 蓝色
        bg = "#31353f",  -- 深灰背景
        bold = true,
      })

      local hlslens = require("hlslens")
      hlslens.setup()

      -- 使用 expr 映射保证数字提示优化（计数为 1 时不显示数字）
      local expr_opts = { noremap = true, silent = true, expr = true }
      vim.keymap.set("n", "n", function()
        local count = vim.v.count1
        vim.schedule(function() hlslens.start() end)
        return count == 1 and "n" or tostring(count) .. "n"
      end, expr_opts)

      vim.keymap.set("n", "N", function()
        local count = vim.v.count1
        vim.schedule(function() hlslens.start() end)
        return count == 1 and "N" or tostring(count) .. "N"
      end, expr_opts)

      local opts = { noremap = true, silent = true }
      vim.keymap.set("n", "*", "*<Cmd>lua require('hlslens').start()<CR>", opts)
      vim.keymap.set("n", "#", "#<Cmd>lua require('hlslens').start()<CR>", opts)
      vim.keymap.set("n", "g*", "g*<Cmd>lua require('hlslens').start()<CR>", opts)
      vim.keymap.set("n", "g#", "g#<Cmd>lua require('hlslens').start()<CR>", opts)
      vim.keymap.set("n", "<Leader>l", "<Cmd>noh<CR>", opts)
    end,
  },
  {
    "mg979/vim-visual-multi",
    event = "VeryLazy",
    init = function()
      -- 基础配置：设置主题及部分键映射
      vim.g.VM_theme = "purplegray"
      vim.g.VM_maps = {
        ["Find Under"] = "<C-n>",
        ["Find Subword Under"] = "<C-n>",
      }
      -- 与 hlslens 联动：在多光标模式启动时也启动 hlslens
      vim.api.nvim_create_autocmd("User", {
        pattern = "visual_multi_start",
        callback = function()
          require("hlslens").start()
        end,
      })
    end,
    keys = {
      { "<Leader>m", "<Plug>(VM-Find-Under)", desc = "Multi Cursor" },
      { "<C-d>", "<Plug>(VM-Add-Cursor-Down)", desc = "Add Cursor Down" },
      { "<C-u>", "<Plug>(VM-Add-Cursor-Up)", desc = "Add Cursor Up" },
    },
  },
}
