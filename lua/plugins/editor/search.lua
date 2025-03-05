return {{
  "kevinhwang91/nvim-hlslens",
  config = function()
    -- 设置 HlSearchLens 高亮组，使用你提供的颜色
    vim.api.nvim_set_hl(0, "HlSearchLens", {
      fg = "#61afef",  -- onedark 蓝色
      bg = "#31353f",  -- 深灰色背景
      bold = true,
    })

    -- 初始化 hlslens 插件
    require("hlslens").setup()

    -- 定义快捷键选项
    local opts = { noremap = true, silent = true }

    -- 设置键映射，使用 execute 动态计算计数
    vim.keymap.set("n", "n",
      [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
      opts
    )
    vim.keymap.set("n", "N",
      [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
      opts
    )
    vim.keymap.set("n", "*", [[*<Cmd>lua require('hlslens').start()<CR>]], opts)
    vim.keymap.set("n", "#", [[#<Cmd>lua require('hlslens').start()<CR>]], opts)
    vim.keymap.set("n", "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]], opts)
    vim.keymap.set("n", "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]], opts)

    -- 清除搜索高亮
    vim.keymap.set("n", "<Leader>l", "<Cmd>noh<CR>", opts)
  end,
},
{
    "mg979/vim-visual-multi",
    event = "VeryLazy",
    init = function()
      -- 基础配置
      vim.g.VM_theme = 'purplegray'      -- 多光标主题色
      vim.g.VM_maps = {                  -- 禁用默认部分冲突键
        ['Find Under'] = '<C-n>',        -- 保持默认 <C-n> 选择下个匹配
        ['Find Subword Under'] = '<C-n>' -- 避免与搜索冲突
      }

      -- 与 hlslens 联动：在多光标模式下保持搜索高亮
      vim.cmd([[
        function! VM_Start(...)
          lua require('hlslens').start()
        endfunction
        autocmd User visual_multi_start call VM_Start()
      ]])
    end,
    keys = {
      -- 自定义多光标快捷键（与搜索键互补）
      { "<Leader>m", "<Plug>(VM-Find-Under)", desc = "Multi Cursor" },
      { "<C-d>",     "<Plug>(VM-Add-Cursor-Down)", desc = "Add Cursor Down" },
      { "<C-u>",     "<Plug>(VM-Add-Cursor-Up)", desc = "Add Cursor Up" }
    }
  }
}