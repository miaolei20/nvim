return {
  {
    "kevinhwang91/nvim-ufo",
    event = "BufReadPost",
    dependencies = {
      "kevinhwang91/promise-async",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      open_fold_hl_timeout = 100,
      preview = {
        win_config = {
          border = "rounded",
          winblend = 5, -- 轻微透明，增强现代感
          maxheight = 15, -- 限制最大高度，防止溢出
        },
      },
      provider_selector = function(bufnr, filetype)
        local ignore_list = { "fugitive", "gitcommit", "alpha", "dashboard" }
        if vim.tbl_contains(ignore_list, filetype) then
          return ""
        end

        local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
        if #clients > 0 then
          return { "lsp", "treesitter" }
        else
          return { "treesitter", "indent" }
        end
      end,
      fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = ("  ⏵ %d "):format(endLnum - lnum) -- ⏵ 更符合现代风格
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0

        for _, chunk in ipairs(virtText) do
          local text, hlGroup = unpack(chunk)
          local chunkWidth = vim.fn.strdisplaywidth(text)
          if curWidth + chunkWidth < targetWidth then
            table.insert(newVirtText, { text, hlGroup })
          else
            table.insert(newVirtText, { truncate(text, targetWidth - curWidth), hlGroup })
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, "Comment" }) -- 颜色统一
        return newVirtText
      end,
    },
    config = function(_, opts)
      local ok, ufo = pcall(require, "ufo")
      if not ok then
        vim.notify("nvim-ufo not found!", vim.log.levels.ERROR)
        return
      end

      -- UI 设置
      vim.opt.foldcolumn = "0" -- **完全去除左侧折叠列**
      vim.opt.foldlevel = 99
      vim.opt.foldenable = true
      vim.opt.fillchars = [[fold: ,foldopen:⏷,foldclose:⏵]] -- **更优雅的折叠符号**

      ufo.setup(opts)

      -- 现代折叠快捷键
      local keymap_opts = { noremap = true, silent = true, desc = "Folding" }
      vim.api.nvim_set_keymap("n", "zR", "<cmd>lua require('ufo').openAllFolds()<CR>", keymap_opts)
      vim.api.nvim_set_keymap("n", "zM", "<cmd>lua require('ufo').closeAllFolds()<CR>", keymap_opts)
      vim.api.nvim_set_keymap("n", "zr", "<cmd>lua require('ufo').openFoldsExceptKinds()<CR>", keymap_opts)
      vim.api.nvim_set_keymap("n", "zm", "<cmd>lua require('ufo').closeFoldsWith()<CR>", keymap_opts)
      vim.api.nvim_set_keymap("n", "zp", "<cmd>lua require('ufo').peekFoldedLinesUnderCursor()<CR>", keymap_opts)

    end,
  },
}
