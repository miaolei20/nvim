-- lua/plugins/tools/telescope.lua
return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-file-browser.nvim",
      "debugloop/telescope-undo.nvim",
      "nvim-telescope/telescope-frecency.nvim",
      "nvim-telescope/telescope-ui-select.nvim",  -- 新增现代 UI 组件
    },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find Files" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Live Grep" },
      { "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "Workspace Diagnostics" },  -- 新增诊断入口
      { "<leader>fb", "<cmd>Telescope file_browser<CR>", desc = "File Browser" },
      { "<leader>fu", "<cmd>Telescope undo<CR>", desc = "Undo History" },
      { "<leader>fr", "<cmd>Telescope frecency<CR>", desc = "Recent Files" },
    },
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { width = 0.95, height = 0.85 },  -- 更现代的布局
        path_display = { "truncate" },
        file_ignore_patterns = { "^.git/", "^node_modules/" },
        mappings = {
          i = {
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
            ["<Esc>"] = "close",
          },
        },
        border = true,  -- 启用边框
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },  -- 圆角边框
      },
      pickers = {
        find_files = { hidden = true },
        diagnostics = {
          theme = "ivy",  -- 使用紧凑主题
          initial_mode = "normal",  -- 直接进入选择模式
        },
      },
      extensions = {
        fzf = { fuzzy = true },
        file_browser = { hijack_netrw = true },
        ["ui-select"] = {  -- 现代化 UI 扩展
          require("telescope.themes").get_dropdown {
            previewer = false,
            layout_config = { width = 0.4, height = 0.4 },
          }
        },
      },
    },
    config = function(_, opts)
      require("telescope").setup(opts)
      pcall(function()
        for _, ext in ipairs { "fzf", "file_browser", "undo", "frecency", "ui-select" } do
          require("telescope").load_extension(ext)
        end
      end)
    end,
  },
}