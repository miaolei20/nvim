return {
  {
    "nvim-telescope/telescope.nvim",
    version = false,
    cmd = "Telescope",
    event = "VeryLazy",  -- 统一使用懒加载
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-tree/nvim-web-devicons",
      "debugloop/telescope-undo.nvim"
    },
    keys = function()
      local builtin = require("telescope.builtin")
      local extensions = require("telescope").extensions
      return {
        -- 核心快捷键
        { "<leader>ff", builtin.find_files, desc = "Find Files" },
        { "<leader>fg", builtin.live_grep,  desc = "Live Grep" },
        { "<leader>fb", builtin.buffers,    desc = "Find Buffers" },
        { "<leader>fh", builtin.help_tags,  desc = "Help Tags" },
        { "<leader>fr", builtin.oldfiles,   desc = "Recent Files" },
        
        -- 增强型快捷键
        { "<leader>fe", function()
          extensions.file_browser.file_browser({
            path = "%:p:h",
            grouped = true,
            theme = "dropdown"
          })
        end, desc = "File Browser" },
        
        { "<leader>fu", "<cmd>Telescope undo<cr>", desc = "Undo History" }
      }
    end,
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local action_layout = require("telescope.actions.layout")

      -- 异步颜色配置（性能优化）
      vim.schedule(function()
        local ok, palette = pcall(require, "onedark.palette")
        if ok then
          palette = palette.dark
          vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = palette.gray, bg = palette.bg0 })
          vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = palette.cyan, bg = palette.bg1 })
        end
      end)

      -- 统一配置项（合并上下文[<sup>1</sup>](https://www.msn.com/en-us/society-culture-and-history/general/the-sky-today-march-10-2025/ar-AA1AzBeM)[<sup>2</sup>](https://www.wincalendar.com/Calendar/Date/March-10-2025)的设置）
      telescope.setup({
        defaults = {
          dynamic_preview_title = true,
          prompt_prefix = "   ",
          selection_caret = "  ",
          path_display = { "truncate" },
          winblend = 10,
          borderchars = {
            prompt  = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
            results = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
            preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }
          },
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-v>"] = actions.select_vertical,
              ["<C-u>"] = action_layout.toggle_preview,
              ["<ESC>"] = actions.close
            }
          },
          file_ignore_patterns = {
            "%.git/", "node_modules/", "%.idea/",
            "__pycache__/", "%.class"
          },
          vimgrep_arguments = {
            "rg", "--color=never", "--no-heading",
            "--with-filename", "--line-number",
            "--column", "--smart-case", "--hidden"
          }
        },
        pickers = {
          find_files = {
            hidden = true,
            find_command = { "fd", "--type=file", "--hidden" },
            theme = "dropdown"
          }
        },
        extensions = {
          fzf = {
            fuzzy = true,
            case_mode = "smart_case"
          },
          file_browser = {
            hijack_netrw = true,
            theme = "dropdown"
          }
        }
      })

      -- 延迟加载扩展（性能优化）
      vim.defer_fn(function()
        telescope.load_extension("fzf")
        telescope.load_extension("file_browser")
        telescope.load_extension("undo")
      end, 100)
    end
  }
}
