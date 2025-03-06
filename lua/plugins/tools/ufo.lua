return {
  {
    "kevinhwang91/nvim-ufo",
    event = "BufReadPost",
    dependencies = {
      "kevinhwang91/promise-async",
      "nvim-treesitter/nvim-treesitter",
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

      -- 提供者选择函数：针对特定 filetype 返回空字符串，否则根据 lsp 与 treesitter 动态选择
      local function provider_selector(bufnr, filetype)
        if vim.tbl_contains({ "fugitive", "gitcommit" }, filetype) then
          return ""
        end

        local providers = {}
        if #vim.lsp.get_active_clients({ bufnr = bufnr }) > 0 then
          table.insert(providers, "lsp")
        end
        table.insert(providers, "treesitter")
        return providers
      end

      -- 虚拟文本处理函数：用于自定义折叠区域显示
      local function fold_virt_text_handler(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local foldCount = endLnum - lnum
        local suffix = (" 󰁂 %d "):format(foldCount)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0

        for _, chunk in ipairs(virtText) do
          local text, hlGroup = unpack(chunk)
          local chunkWidth = vim.fn.strdisplaywidth(text)
          if curWidth + chunkWidth < targetWidth then
            table.insert(newVirtText, { text, hlGroup })
          else
            local truncatedText = truncate(text, targetWidth - curWidth)
            if truncatedText ~= "" then
              table.insert(newVirtText, { truncatedText, hlGroup })
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, "Comment" })
        return newVirtText
      end

      -- 核心配置
      ufo.setup({
        provider_selector = provider_selector,
        open_fold_hl_timeout = 150,
        preview = {
          win_config = {
            border = "rounded",
            winblend = 30,
            maxheight = 20,
          },
        },
        fold_virt_text_handler = fold_virt_text_handler,
      })

      -- 配置快捷键
      vim.keymap.set("n", "zR", ufo.openAllFolds, { desc = "展开所有折叠" })
      vim.keymap.set("n", "zM", ufo.closeAllFolds, { desc = "折叠所有层级" })
      vim.keymap.set("n", "zp", ufo.peekFoldedLinesUnderCursor, { desc = "预览折叠内容" })
      vim.keymap.set("n", "zm", ufo.closeFoldsWith, { desc = "逐步折叠代码" })
      vim.keymap.set("n", "zr", ufo.openFoldsExceptKinds, { desc = "逐步展开代码" })

      -- 延时更新 Treesitter 解析器，确保其已安装
      vim.defer_fn(function()
        require("nvim-treesitter.install").update({ with_sync = true })
      end, 1000)
    end,
  },
}
