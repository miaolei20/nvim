return {
  {
    "nvim-telescope/telescope-file-browser.nvim", -- 插件名称
    event = "VeryLazy", -- 懒加载插件
    dependencies = { "nvim-telescope/telescope.nvim" }, -- 依赖的插件
    config = function()
      require("telescope").load_extension("file_browser") -- 加载文件浏览器扩展

      -- 快捷键配置
      vim.keymap.set("n", "<leader>fe", function()
        require("telescope").extensions.file_browser.file_browser() -- 打开文件浏览器
      end, { desc = "File Browser" }) -- 设置描述
    end
  }
}
