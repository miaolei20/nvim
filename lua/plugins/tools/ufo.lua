return {
  {
    "kevinhwang91/nvim-ufo",
    event = "BufReadPost",
    dependencies = {
      "kevinhwang91/promise-async",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      open_fold_hl_timeout = 150,
      preview = {
        win_config = {
          border = "rounded",
          winblend = 30,
          maxheight = 20,
        },
      },
      provider_selector = function(bufnr, filetype)
        if vim.tbl_contains({ "fugitive", "gitcommit" }, filetype) then
          return ""
        end

        local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
        if #clients > 0 then
          return { "lsp", "treesitter" }  -- LSP 可用时，使用 LSP + Treesitter
        else
          return { "treesitter", "indent" }  -- 否则使用 Treesitter + Indent
        end
      end,
      fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = (" 󰁂 %d "):format(endLnum - lnum)
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
        table.insert(newVirtText, { suffix, "Comment" })
        return newVirtText
      end,
    },
    config = function(_, opts)
      -- 安全加载检查
      local ok, ufo = pcall(require, "ufo")
      if not ok then
        vim.notify("nvim-ufo not found!", vim.log.levels.ERROR)
        return
      end

      -- 启用折叠
      vim.opt.foldcolumn = "1"
      vim.opt.foldlevel = 99
      vim.opt.foldenable = true

      -- 加载配置
      ufo.setup(opts)

      -- 绑定快捷键
      local keymap_opts = { noremap = true, silent = true, desc = "Folding" }
      vim.api.nvim_set_keymap("n", "zR", "<cmd>lua require('ufo').openAllFolds()<CR>", keymap_opts)
      vim.api.nvim_set_keymap("n", "zM", "<cmd>lua require('ufo').closeAllFolds()<CR>", keymap_opts)
      vim.api.nvim_set_keymap("n", "zr", "<cmd>lua require('ufo').openFoldsExceptKinds()<CR>", keymap_opts)
      vim.api.nvim_set_keymap("n", "zm", "<cmd>lua require('ufo').closeFoldsWith()<CR>", keymap_opts)
      vim.api.nvim_set_keymap("n", "zp", "<cmd>lua require('ufo').peekFoldedLinesUnderCursor()<CR>", keymap_opts)
    end,
  },
}
