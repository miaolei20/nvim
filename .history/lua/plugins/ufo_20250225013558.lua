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
      vim.opt.foldcolumn = "1"    -- 显示折叠栏
      vim.opt.foldlevel = 99      -- 默认展开所有折叠
      vim.opt.foldenable = true
      vim.opt.fillchars = {
        foldopen = "",          -- 折叠打开图标
        foldclose = "",         -- 折叠关闭图标
        fold = " ",              -- 折叠填充字符
        foldsep = " "            -- 折叠分隔符
      }

      -- 核心配置
      ufo.setup({
        provider_selector = function(bufnr, filetype, buftype)
          -- 遵守最多两个提供者的限制
          local is_nvim_09 = vim.fn.has("nvim-0.9") == 1
          return {
            main = is_nvim_09 and "lsp" or "treesitter",
            fallback = is_nvim_09 and "treesitter" or "indent"
          }
        end,
        open_fold_hl_timeout = 150,
        preview = {
          win_config = {
            border = "rounded",      -- 圆角边框
            winblend = 30,           -- 透明度混合
            winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
            maxheight = 20           -- 限制预览高度
          }
        },
        fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
          -- 自定义折叠显示内容
          local newVirtText = {}
          local suffix = (" 󰁂 %d lines "):format(endLnum - lnum)
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
              local hlGroup = chunk[2]
              if chunkText ~= "" then
                table.insert(newVirtText, {chunkText, hlGroup})
              end
              break
            end
            curWidth = curWidth + chunkWidth
          end
          
          table.insert(newVirtText, { suffix, "UfoFoldedEllipsis" })
          return newVirtText
        end
      })

      -- 增强快捷键系统
      vim.keymap.set("n", "zR", ufo.openAllFolds, { desc = "Open all folds" })
      vim.keymap.set("n", "zM", ufo.closeAllFolds, { desc = "Close all folds" })
      vim.keymap.set("n", "zr", ufo.openFoldsExceptKinds, { desc = "Open folds recursively" })
      vim.keymap.set("n", "zm", ufo.closeFoldsWith, { desc = "Close folds recursively" })
      vim.keymap.set("n", "zp", function()
        local winid = ufo.peekFoldedLinesUnderCursor()
        if not winid then
          vim.lsp.buf.hover()
        end
      end, { desc = "Peek fold preview" })

      -- 自动命令：保存折叠状态
      vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = "*",
        callback = function()
          ufo.saveFolds()
        end
      })

      -- 高亮组配置
      vim.api.nvim_set_hl(0, "UfoFoldedEllipsis", {
        fg = "#8FBCBB",
        bg = "NONE",
        italic = true
      })

      -- 初始化折叠缓存
      vim.defer_fn(function()
        ufo.getFolds()
      end, 2000)
    end
  }
}