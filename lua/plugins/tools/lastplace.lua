return {
  {
    "ethanholz/nvim-lastplace",
    event = { "BufReadPost", "FileReadPost" }, -- 更合理的触发时机
    config = function()
      require("nvim-lastplace").setup({
        lastplace_ignore_buftype = {
          "quickfix", "nofile", "help",
          "terminal", "prompt" -- 额外忽略 terminal & prompt
        },
        lastplace_ignore_filetype = {
          "gitcommit", "gitrebase", "svn", "hgcommit",
          "TelescopePrompt", "NvimTree", "alpha",
          "dashboard", "packer", "spectre_panel" -- 适配更多 UI 插件
        },
        lastplace_open_folds = true, -- 自动展开折叠
      })

      -- 额外优化：防止 `lastplace` 在特定 buffer 运行
      vim.api.nvim_create_autocmd("BufWinEnter", {
        callback = function()
          local ignore_buftypes = { "nofile", "prompt", "quickfix" }
          if vim.tbl_contains(ignore_buftypes, vim.bo.buftype) then
            return
          end
          pcall(vim.cmd, "normal! zz") -- 进入文件后居中
        end,
      })
    end,
  },
}
