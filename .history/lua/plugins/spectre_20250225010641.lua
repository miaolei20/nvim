-- file: plugins/spectre.lua
return {
  {
    "nvim-pack/nvim-spectre",
    keys = {
      { "<leader>S", desc = "Spectre Search/Replace" },
      { "<leader>sw", desc = "Word under cursor" }
    },
    config = function()
      local colors = require("onedark.palette").dark
      local spectre = require("spectre")

      -- 安全检测替换引擎
      local function check_engine(engine)
        if vim.fn.executable(engine.cmd) == 0 then
          vim.notify(engine.cmd .. " not found!", vim.log.levels.WARN)
          return false
        end
        return true
      end

      spectre.setup({
        color_devicons = true,
        live_update = true,  -- 实时更新搜索结果
        line_sep_start = "┌────────────────────────────────────────────",
        line_sep_end = "└────────────────────────────────────────────",
        highlight = {
          ui = "Comment",       -- 界面元素高亮
          search = "IncSearch",  -- 搜索匹配高亮
          replace = "WarningMsg" -- 替换标记高亮
        },
        mapping = {
          ["toggle_line"] = "dd",
          ["enter_file"] = {"<CR>", "o"},  -- 支持两种打开方式
          ["send_to_qf"] = "Q",            -- 发送结果到 quickfix
          ["replace_cmd"] = "R",           -- 直接执行替换命令
          ["show_diff"] = "D",             -- 显示差异
          ["run_current_replace"] = "W",   -- 替换当前匹配
        },
        replace_engine = {
          sed = { 
            cmd = "sed",
            args = { "-i", "-E" },  -- 强制启用扩展正则表达式
            check = check_engine
          },
          default = "sed"  -- 回退到内置替换引擎
        },
        theme = {
          winblend = 15,
          border = "single",  -- 更简洁的边框
          search = {
            fg = colors.fg,
            bg = colors.bg1,
            gui = "italic"
          },
          replace = {
            fg = colors.red,
            bg = colors.bg1,
            gui = "bold"
          },
          preview = {  -- 新增预览窗口样式
            fg = colors.comment,
            bg = colors.bg0
          }
        },
        default = {
          find = {  -- 默认搜索参数
            cmd = "rg",
            args = {
              "--color=never",
              "--no-heading",
              "--with-filename",
              "--line-number",
              "--column",
              "--smart-case",
              "--hidden"
            }
          }
        }
      })

      -- 增强快捷键
      vim.keymap.set("n", "<leader>S", function()
        spectre.open()
      end, { desc = "Spectre Global Search" })

      vim.keymap.set("n", "<leader>sw", function()
        spectre.open_visual({ select_word = true })  -- 自动选中当前单词
      end, { desc = "Spectre Word Search" })

      -- 快速访问最近搜索
      vim.keymap.set("n", "<leader>sh", function()
        spectre.resume_last_search()
      end, { desc = "Spectre History" })
    end
  }
}