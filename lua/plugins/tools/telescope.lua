return {
  {
    "nvim-telescope/telescope.nvim",
    version = false,
    cmd = "Telescope",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "jvgrootveld/telescope-lazy-plugins.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "debugloop/telescope-undo.nvim",
      { "nvim-telescope/telescope-frecency.nvim", dependencies = "kkharji/sqlite.lua" },  -- 新增 frecency
    },
    keys = function()
      local builtin = require("telescope.builtin")
      return {
        -- 核心快捷键
        { "<leader>ff", builtin.find_files, desc = "Find Files" },
        { "<leader>fg", builtin.live_grep,  desc = "Live Grep" },
        { "<leader>fs", "<cmd>Telescope frecency<cr>", desc = "Frecency Files" },  -- 新增
        
        -- 增强型快捷键
        { "<leader>fe", function()
          require("telescope").extensions.file_browser.file_browser({
            path = "%:p:h",
            theme = "dropdown"
          })
        end, desc = "File Browser" },
        
        { "<leader>fu", "<cmd>Telescope undo<cr>", desc = "Undo History" },
        { "<leader>fp", "<cmd>Telescope lazy_plugins<cr>", desc = "Lazy Plugins" }
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

      -- 统一配置
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
            layout_config = { width = 0.4 }
          },
          frecency = {  -- 新增 frecency 配置
            show_scores = false,
            workspaces = {
              ["conf"] = vim.fn.expand("~/.config/nvim"),
              ["code"] = vim.fn.expand("~/code")
            }
          }
        }
      })
      
      -- 智能扩展加载策略
      local load_ext = function(ext)
        return function()
          if not package.loaded["telescope._extensions."..ext] then
            telescope.load_extension(ext)
          end
        end
      end

      -- 按需加载扩展
      vim.api.nvim_create_autocmd("User", {
        pattern = "TelescopePreviewerLoaded",
        callback = function()
          load_ext("fzf")()
          load_ext("file_browser")()
          load_ext("undo")()
          load_ext("lazy_plugins")()
          load_ext("frecency")()  -- 新增
        end,
        once = true
      })
    end
  }
}