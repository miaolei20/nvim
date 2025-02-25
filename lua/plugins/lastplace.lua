-- file: plugins/lastplace.lua
return {
  {
    "ethanholz/nvim-lastplace",
    event = "BufWinEnter",
    config = function()
      require("nvim-lastplace").setup({
        lastplace_ignore_buftype = { "quickfix", "nofile", "help" }, -- 忽略缓冲区类型
        lastplace_ignore_filetype = {
          "gitcommit", "gitrebase", "svn", "hgcommit",               -- 忽略文件类型
          "TelescopePrompt", "NvimTree", "alpha"
        },
        lastplace_open_folds = true -- 自动打开折叠
      })
    end
  }
}
