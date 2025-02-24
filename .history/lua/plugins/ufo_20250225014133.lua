-- file: plugins/ufo.lua
return {
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    config = function()
      vim.o.foldcolumn = "1" -- 显示折叠列
      vim.o.foldlevel = 99
      vim.o.foldenable = true

      require("ufo").setup({
        provider_selector = function() -- 折叠提供者
          return { "treesitter", "indent" }
        end,
        open_fold_hl_timeout = 300, -- 高亮时间
        fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
          return virtText -- 自定义虚拟文本显示
        end
      })

      -- 折叠快捷键
      vim.keymap.set("n", "zR", require("ufo").openAllFolds)
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
    end
  }
}