return {
  "ethanholz/nvim-lastplace",
  event = "BufReadPost",
  opts = {
    lastplace_ignore_buftype = { "quickfix", "nofile", "help", "terminal" },
    lastplace_ignore_filetype = { "gitcommit", "gitrebase", "NvimTree", "alpha" },
    lastplace_open_folds = true,
  },
}