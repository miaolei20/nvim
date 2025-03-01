return {
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
}
