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
      "nvim-telescope/telescope-frecency.nvim",
    },
    keys = function()
      local builtin = require("telescope.builtin")
      return {
        { "<leader>ff", builtin.find_files, desc = "Find Files" },
        { "<leader>fg", builtin.live_grep, desc = "Live Grep" },
        { "<leader>fs", "<CMD>Telescope frecency workspace=CWD<CR>", desc = "Frecency Files" },
        { "<leader>fe", "<CMD>Telescope file_browser path=%:p:h theme=dropdown<CR>", desc = "File Browser" },
        { "<leader>fu", "<CMD>Telescope undo<CR>", desc = "Undo History" },
        { "<leader>fp", "<CMD>Telescope lazy_plugins<CR>", desc = "Lazy Plugins" },
      }
    end,
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      -- 异步高亮设置
      vim.schedule(function()
        local palette = require("onedark.palette").dark
        local hl_groups = {
          TelescopeBorder = { fg = palette.grey, bg = palette.bg0 },
          TelescopePromptBorder = { fg = palette.cyan, bg = palette.bg1 },
          TelescopeTitle = { fg = palette.cyan, bold = true },
        }
        for group, def in pairs(hl_groups) do
          vim.api.nvim_set_hl(0, group, def)
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
              ["<ESC>"] = actions.close,
            },
          },
          file_ignore_patterns = { "^.git/", "^node_modules/", "^.idea/", "__pycache__/" },
          vimgrep_arguments = {
            "rg", "--color=never", "--no-heading", "--with-filename",
            "--line-number", "--column", "--smart-case", "--hidden",
            "--glob=!.git", "--glob=!node_modules",
          },
        },
        pickers = {
          find_files = {
            hidden = true,
            find_command = { "fd", "--type=file", "--hidden" },
          },
        },
        extensions = {
          fzf = { fuzzy = true },
          lazy_plugins = {
            theme = "dropdown",
            layout_config = { width = 0.4 },
            lazy_config = vim.fn.stdpath("config") .. "/init.lua",
          },
          frecency = {
            db_safe_mode = false,
            auto_validate = true,
            show_scores = true,
            show_unindexed = true,
            ignore_patterns = { "*.git/*" },
            workspaces = {
              ["conf"] = vim.fn.stdpath("config"),
              ["project"] = "~/projects",
            },
          },
        },
      })

      -- 延迟加载扩展
      local extensions = { "fzf", "file_browser", "undo", "lazy_plugins", "frecency" }
      vim.api.nvim_create_autocmd("User", {
        pattern = "TelescopePreviewerLoaded",
        once = true,
        callback = function()
          for _, ext in ipairs(extensions) do
            telescope.load_extension(ext)
          end
        end,
      })
    end,
  },
}