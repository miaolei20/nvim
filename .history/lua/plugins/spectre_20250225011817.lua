-- file: plugins/spectre.lua
return {
  {
    "nvim-pack/nvim-spectre",
    keys = {
      { "<leader>sr", desc = "Replace in files (Spectre)" },
      { "<leader>sw", desc = "Search current word" }
    },
    dependencies = { "nvim-lua/plenary.nvim" }, -- 显式声明必要依赖
    config = function()
      local colors = require("onedark.palette").dark
      local spectre = require("spectre")

      -- 动态颜色适配函数
      local function get_hl_color(group, attr)
        return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(group)), attr)
      end

      spectre.setup({
        color_devicons = true,
        live_update = true,  -- 启用实时更新
        line_sep_start = "▔", -- 自定义分隔符
        results_padding = "│ ",
        highlight = {
          ui = "Comment",
          search = "IncSearch",
          replace = "DiffDelete",
          border = "FloatBorder"
        },
        mapping = {
          ["toggle_line"] = { map = "dd", desc = "Toggle line match" },
          ["enter_file"] = { map = "<CR>", desc = "Open file" },
          ["send_to_qf"] = { map = "<leader>q", desc = "Send to quickfix" },
          ["replace_cmd"] = { map = "<leader>c", desc = "Edit replace command" }
        },
        replace_engine = {
          default = "sed",  -- 设置默认引擎
          sed = { cmd = "sed", args = { "-i", "-E" } },  -- 增强 sed 参数
          perl = { cmd = "perl", args = { "-pi -e" } }
        },
        theme = {
          winblend = 15,
          border = "rounded",
          search = {
            fg = get_hl_color("IncSearch", "fg#"),
            bg = get_hl_color("Normal", "bg#")
          },
          replace = {
            fg = get_hl_color("DiffDelete", "fg#"),
            bg = get_hl_color("Normal", "bg#")
          },
          preview = {  -- 新增预览区样式
            fg = get_hl_color("Comment", "fg#"),
            bg = get_hl_color("CursorLine", "bg#")
          }
        }
      })

      -- 增强快捷键配置
      vim.keymap.set("n", "<leader>sr", function()
        spectre.open()
      end, { desc = "Spectre: Project replace" })

      vim.keymap.set("n", "<leader>sw", function()
        spectre.open_visual({ select_word = true })
      end, { desc = "Spectre: Search current word" })

      -- 自动命令：保存前关闭 Spectre
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "spectre_*",
        callback = function() spectre.close() end
      })
    end
  }
}