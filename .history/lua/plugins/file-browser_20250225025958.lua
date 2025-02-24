-- file: plugins/telescope-filebrowser.lua
return {
  {
    "nvim-telescope/telescope-file-browser.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("file_browser")
      
      -- 快捷键配置
      vim.keymap.set("n", "<leader>fe", function()
        require("telescope").extensions.file_browser.file_browser()
      end, { desc = "File Browser" })
    end
  }
}
