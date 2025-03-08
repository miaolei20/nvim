return {
  {
    "nvim-pack/nvim-spectre",
    keys = {
      { "<leader>sr", desc = "Replace in files (Spectre)" },
      { "<leader>sw", desc = "Search current word" },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local spectre = require("spectre")

      -- 获取当前主题的高亮颜色，动态适配
      local function get_hl_color(group, attr)
        return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(group)), attr)
      end

      spectre.setup({
        color_devicons = true,
        live_update = true,
        line_sep_start = "▔",
        results_padding = "│ ",
        highlight = {
          ui      = "Comment",
          search  = "IncSearch",
          replace = "DiffDelete",
          border  = "FloatBorder",
        },
        mapping = {
          toggle_line = { map = "dd",       desc = "Toggle line match" },
          enter_file  = { map = "<CR>",     desc = "Open file" },
          send_to_qf  = { map = "<leader>q", desc = "Send to quickfix" },
          replace_cmd = { map = "<leader>c", desc = "Edit replace command" },
        },
        replace_engine = {
          default = "sed",
          sed = { cmd = "sed", args = { "-i", "-E" } },
          perl = { cmd = "perl", args = { "-pi", "-e" } },
        },
        theme = {
          winblend = 20,         -- 提高透明度，软化整体界面
          border = "rounded",
          title = {
            fg = get_hl_color("Title", "fg#") or "#ffffff",
            bg = get_hl_color("Normal", "bg#"),  -- 与 Normal 背景保持一致
          },
          search = {
            fg = get_hl_color("IncSearch", "fg#") or "#bbbbbb",
            bg = get_hl_color("Normal", "bg#"),  -- 统一背景，避免突兀
          },
          replace = {
            fg = get_hl_color("DiffDelete", "fg#") or "#bbbbbb",
            bg = get_hl_color("Normal", "bg#"),
          },
          preview = {
            fg = get_hl_color("Comment", "fg#") or "#bbbbbb",
            bg = get_hl_color("Normal", "bg#"),
          },
        },
      })

      -- 快捷键配置：项目替换与搜索当前单词
      vim.keymap.set("n", "<leader>sr", function()
        spectre.open()
      end, { desc = "Spectre: Project replace" })

      vim.keymap.set("n", "<leader>sw", function()
        spectre.open_visual({ select_word = true })
      end, { desc = "Spectre: Search current word" })

      -- 自动命令：在保存前关闭 Spectre 窗口，防止残留
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "spectre_*",
        callback = function()
          spectre.close()
        end,
      })
    end,
  },
}
