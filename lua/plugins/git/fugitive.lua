return {
  "tpope/vim-fugitive",
  dependencies = { "tpope/vim-rhubarb" }, -- 增强 GitHub 支持
  event = "VeryLazy",                     -- 延迟加载
  keys = {
    { "<leader>gs", "<cmd>Git<CR>",        desc = "Git Status" },
    { "<leader>gc", "<cmd>Git commit<CR>", desc = "Git Commit" },
    { "<leader>gd", "<cmd>Gdiffsplit<CR>", desc = "Git Diff" },
    { "<leader>gb", "<cmd>Git blame<CR>",  desc = "Git Blame" },
    { "<leader>gl", "<cmd>Git log<CR>",    desc = "Git Log" },
    { "<leader>gp", "<cmd>Git push<CR>",   desc = "Git Push" },
    { "<leader>gu", "<cmd>Git pull<CR>",   desc = "Git Pull" },
    { "<leader>gB", "<cmd>Git branch<CR>", desc = "Git Branch" },
  },
  init = function()
    -- 自动设置 Git 工作目录
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "fugitive",
      callback = function()
        vim.opt_local.bufhidden = "delete"
      end,
    })
  end
}
