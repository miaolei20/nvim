-- file: plugins/telescope.lua
return {
  {
    "nvim-telescope/telescope.nvim",  -- 主插件
    version = false, -- 使用最新版本
    dependencies = {
      "nvim-lua/plenary.nvim",  -- 必要依赖
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- 性能优化
      "nvim-tree/nvim-web-devicons" -- 图标支持
    },
    config = function()
      local colors = require("onedark.palette").dark  -- 获取配色方案
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      -- 颜色适配 LazyVim 风格
      vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = colors.gray, bg = colors.bg0 })
      vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = colors.cyan, bg = colors.bg1 })
      vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { fg = colors.bg1, bg = colors.bg0 })
      vim.api.nvim_set_hl(0, "TelescopeTitle", { fg = colors.cyan, bold = true })
      vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = colors.bg2, bold = true })

      telescope.setup({
        defaults = {
          prompt_prefix = "   ",  -- 提示符前缀
          selection_caret = "  ",  -- 选择项前缀
          path_display = { "truncate" },  -- 路径显示方式
          sorting_strategy = "ascending",  -- 排序策略
          layout_config = {
            horizontal = {
              prompt_position = "top",  -- 提示符位置
              preview_width = 0.55,  -- 预览窗口宽度
              results_width = 0.8  -- 结果窗口宽度
            },
            vertical = { mirror = false },  -- 垂直布局配置
            width = 0.87,  -- 总宽度
            height = 0.80,  -- 总高度
            preview_cutoff = 120  -- 预览窗口截断阈值
          },
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,  -- Ctrl+j 移动到下一个选择项
              ["<C-k>"] = actions.move_selection_previous,  -- Ctrl+k 移动到上一个选择项
              ["<C-n>"] = actions.cycle_history_next,  -- Ctrl+n 循环到下一个历史记录
              ["<C-p>"] = actions.cycle_history_prev,  -- Ctrl+p 循环到上一个历史记录
              ["<ESC>"] = actions.close  -- ESC 关闭 Telescope
            }
          },
          file_ignore_patterns = {  -- 忽略的文件模式
            "node_modules",
            "%.git",
            "target",
            "build",
            "%.lock",
            "%.idea",
            "%.vscode",
            "%.output",
            "%.class"
          }
        },
        pickers = {
          find_files = {
            hidden = true,  -- 显示隐藏文件
            find_command = { "fd", "--type=file", "--hidden", "--exclude=.git" }  -- 使用 fd 查找文件
          },
          live_grep = {
            only_sort_text = true,  -- 仅对文本排序
            theme = "dropdown",  -- 使用下拉菜单主题
            additional_args = function()
              return { "--hidden" }  -- 额外参数：显示隐藏文件
            end
          }
        },
        extensions = {
          fzf = {
            fuzzy = true,  -- 启用模糊搜索
            override_generic_sorter = true,  -- 覆盖通用排序器
            override_file_sorter = true,  -- 覆盖文件排序器
            case_mode = "smart_case"  -- 智能大小写模式
          }
        }
      })

      -- 加载扩展
      telescope.load_extension("fzf")

      -- LazyVim 风格快捷键
      local map = vim.keymap.set
      map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find Files" })
      map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live Grep" })
      map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find Buffers" })
      map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help Tags" })
      map("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent Files" })
    end
  }
}
