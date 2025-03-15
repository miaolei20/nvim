return {
  {
    "nvim-telescope/telescope.nvim",
    version = false,
    cmd = "Telescope",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "polirritmico/telescope-lazy-plugins.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "debugloop/telescope-undo.nvim",
      { "nvim-telescope/telescope-frecency.nvim" }, -- 添加 frecency 依赖
    },
    keys = function()
      local builtin = require("telescope.builtin")
      return {
        { "<leader>ff", builtin.find_files, desc = "Find Files" },
        { "<leader>fg", builtin.live_grep,  desc = "Live Grep" },
        { "<leader>fs", function()          -- 添加 frecency 的快捷键
          require("telescope").extensions.frecency.frecency({
            workspace = "CWD"  -- 默认使用当前工作目录
          })
        end, desc = "Frecency Files" },
        { "<leader>fe", function()
          require("telescope").extensions.file_browser.file_browser({
            path = "%:p:h",
            theme = "dropdown"
          })
        end, desc = "File Browser" },
        { "<leader>fu", function()
          require("telescope").extensions.undo.undo()
        end, desc = "Undo History" },
        { "<leader>fp", function()
          require("telescope").extensions.lazy_plugins.lazy_plugins()
        end, desc = "Lazy Plugins" }
      }
    end,
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      -- 异步主题适配
      vim.schedule(function()
        local palette = require("onedark.palette").dark
        for hl_group, hl_def in pairs({
          TelescopeBorder       = { fg = palette.grey, bg = palette.bg0 },
          TelescopePromptBorder = { fg = palette.cyan, bg = palette.bg1 },
          TelescopeTitle        = { fg = palette.cyan, bold = true },
        }) do
          vim.api.nvim_set_hl(0, hl_group, hl_def)
        end
      end)

      telescope.setup({
        defaults = {
          dynamic_preview_title = true,
          prompt_prefix = "   ",
          path_display = { "truncate" },
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<ESC>"] = actions.close
            }
          },
          file_ignore_patterns = {
            "^.git/", "^node_modules/", "^.idea/", "__pycache__/"
          },
          vimgrep_arguments = {
            "rg", "--color=never", "--no-heading",
            "--with-filename", "--line-number",
            "--column", "--smart-case", "--hidden",
            "--glob=!.git", "--glob=!node_modules"
          }
        },
        pickers = {
          find_files = {
            hidden = true,
            find_command = { "fd", "--type=file", "--hidden" }
          }
        },
        extensions = {
          fzf = { fuzzy = true },
          lazy_plugins = {
            theme = "dropdown",
            layout_config = { width = 0.4 },
            lazy_config = vim.fn.stdpath("config") .. "/init.lua"
          },
          frecency = {                        -- 添加 frecency 配置
            db_safe_mode = false,             -- 关闭安全模式以提高性能
            auto_validate = true,            -- 自动验证数据库条目
            show_scores = true,              -- 显示文件分数
            show_unindexed = true,           -- 显示未索引的文件
            ignore_patterns = { "*.git/*" }, -- 忽略模式
            workspaces = {                   -- 可选：定义工作空间
              ["conf"] = vim.fn.stdpath("config"),
              ["project"] = "~/projects"
            }
          }
        }
      })

      local load_ext = function(ext)
        return function()
          if not package.loaded["telescope._extensions."..ext] then
            telescope.load_extension(ext)
          end
        end
      end

      vim.api.nvim_create_autocmd("User", {
        pattern = "TelescopePreviewerLoaded",
        callback = function()
          load_ext("fzf")()
          load_ext("file_browser")()
          load_ext("undo")()
          load_ext("lazy_plugins")()
          load_ext("frecency")()           -- 添加 frecency 扩展加载
        end,
        once = true
      })
    end
  }
}