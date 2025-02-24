-- file: plugins/ufo.lua
return {
  {
    "kevinhwang91/nvim-ufo",
    event = "BufReadPost",
    dependencies = {
      "kevinhwang91/promise-async",
      "nvim-treesitter/nvim-treesitter"
    },
    config = function()
      -- 安全加载检查
      local ok, ufo = pcall(require, "ufo")
      if not ok then
        vim.notify("nvim-ufo not found!", vim.log.levels.ERROR)
        return
      end

      -- 基础折叠设置
      vim.opt.foldcolumn = "1"
      vim.opt.foldlevel = 99
      vim.opt.foldenable = true
      vim.opt.fillchars = {
        foldopen = "",
        foldclose = "",
        fold = " ",
        foldsep = " "
      }

      -- 核心配置（兼容性修复版）
      ufo.setup({
        provider_selector = function(bufnr, filetype)
          -- 简化提供者选择逻辑
          local providers = {}
          if #vim.lsp.get_active_clients({ bufnr = bufnr }) > 0 then
            table.insert(providers, "lsp")
          end
          table.insert(providers, "treesitter")
          return providers
        end,
        open_fold_hl_timeout = 150,
        preview = {
          win_config = {
            border = "rounded",
            winblend = 30,
            maxheight = 20
          }
        },
        fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
          local newVirtText = {}
          local suffix = (" 󰁂 %d "):format(endLnum - lnum)
          local sufWidth = vim.fn.strdisplaywidth(suffix)
          local targetWidth = width - sufWidth
          local curWidth = 0
          
          for _, chunk in ipairs(virtText) do
            local chunkText = chunk[1]
            local chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if targetWidth > curWidth + chunkWidth then
              table.insert(newVirtText, chunk)
            else
              chunkText = truncate(chunkText, targetWidth - curWidth)
              if chunkText ~= "" then
                table.insert(newVirtText, {chunkText, chunk[2]})
              end
              break
            end
            curWidth = curWidth + chunkWidth
          end
          table.insert(newVirtText, { suffix, "Comment" }) -- 使用内置高亮组
          return newVirtText
        end
      })

      -- 基础快捷键
      vim.keymap.set("n", "zR", ufo.openAllFolds, { desc = "Open all folds" })
      vim.keymap.set("n", "zM", ufo.closeAllFolds, { desc = "Close all folds" })
      vim.keymap.set("n", "zp", ufo.peekFoldedLinesUnderCursor, { desc = "Peek fold" })

      -- 确保 treesitter 解析器已安装
      vim.defer_fn(function()
        require("nvim-treesitter.install").update({ with_sync = true })
      end, 1000)
    end
  }
}