-- file: plugins/toggleterm.lua
return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = { -- 显式声明所有快捷键
      { "<leader>tt", desc = "Toggle Terminal" },
      { "<C-\\>",     desc = "Toggle Terminal", mode = { "n", "t" } },
      { "<leader>gg", desc = "Lazygit" },
      { "<leader>gp", desc = "Python REPL" }
    },
    config = function()
      local Terminal = require("toggleterm.terminal").Terminal
      
      -- 基础配置
      require("toggleterm").setup({
        size = function(term)
          return (term.direction == "horizontal") and 15 
              or (term.direction == "vertical") and vim.o.columns * 0.4
        end,
        direction = "horizontal", -- 默认水平分割
        shade_terminals = true,
        start_in_insert = true,
        close_on_exit = true,
        persist_size = false,
        persist_mode = false,
        shell = vim.o.shell,
        float_opts = {
          border = "double",  -- 更清晰的边框样式
          winblend = 15,      -- 增强透明度效果
          width = function() return math.floor(vim.o.columns * 0.8) end,
          height = function() return math.floor(vim.o.lines * 0.8) end,
        },
        highlights = {
          FloatBorder = { link = "ToggleTermBorder" }, -- 链接到主题颜色
        }
      })

      -- 基础终端快捷键
      vim.keymap.set({ "n", "t" }, "<C-\\>", "<cmd>ToggleTerm<CR>")
      vim.keymap.set("n", "<leader>tt", function()
        require("toggleterm").toggle_command("direction=horizontal")
      end, { desc = "Toggle Horizontal Terminal" })

      -- 专用终端配置 --------------------------------
      -- Lazygit 终端
      local lazygit = Terminal:new({
        cmd = "lazygit",
        dir = "git_dir",
        direction = "float",
        hidden = true,
        on_open = function(term)
          vim.cmd("startinsert!")
          vim.keymap.set("t", "<Esc>", "<cmd>close<CR>", { buffer = term.bufnr })
        end,
        on_close = function(_)
          vim.cmd("checktime") -- 刷新文件状态
        end,
      })

      -- Python REPL
      local python_repl = Terminal:new({
        cmd = "python",
        direction = "vertical",
        hidden = true,
        env = { VIRTUAL_ENV = os.getenv("VIRTUAL_ENV") },  -- 继承虚拟环境
      })

      -- 专用终端快捷键
      vim.keymap.set("n", "<leader>gg", function()
        if vim.fn.executable("lazygit") == 1 then
          lazygit:toggle()
        else
          vim.notify("Lazygit not installed!", vim.log.levels.WARN)
        end
      end, { desc = "Toggle Lazygit" })

      vim.keymap.set("n", "<leader>gp", function() 
        python_repl:toggle() 
      end, { desc = "Toggle Python REPL" })

      -- 增强功能 --------------------------------
      -- 快速发送代码到终端
      vim.keymap.set("v", "<leader>ts", function()
        require("toggleterm").send_lines_to_terminal("single_line", false, { args = vim.fn.mode() })
      end, { desc = "Send selection to terminal" })
    end
  }
}