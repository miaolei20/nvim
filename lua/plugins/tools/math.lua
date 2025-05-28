return{
 {
  "iamcco/markdown-preview.nvim",
  build = "cd app && npm install",
  cmd = { "MarkdownPreview", "MarkdownPreviewToggle", "MarkdownPreviewStop" },
  keys = {
    {
      "<leader>mp",
      function()
        vim.cmd("MarkdownPreviewToggle")
      end,
      desc = "Toggle Markdown Preview"
    }
  },
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
    vim.g.mkdp_browser = ""
    vim.g.mkdp_auto_close = 0
    vim.g.mkdp_page_title = "${name} - Markdown Preview"
    vim.g.mkdp_theme = "dark"
  end,
  ft = { "markdown" }, -- 添加这个确保打开 md 文件时命令已注册，但不会立刻加载插件
}

}