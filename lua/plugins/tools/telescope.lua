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
    },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find Files" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Live Grep" },
      { "<leader>fb", "<cmd>Telescope file_browser<CR>", desc = "File Browser" },
      { "<leader>fu", "<cmd>Telescope undo<CR>", desc = "Undo History" },
      { "<leader>fr", "<cmd>Telescope frecency<CR>", desc = "Recent Files" },
    },
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        path_display = { "truncate" },
        file_ignore_patterns = { "^.git/", "^node_modules/" },
        mappings = {
          i = {
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
            ["<Esc>"] = "close",
          },
        },
      },
      pickers = {
        find_files = { hidden = true },
      },
      extensions = {
        fzf = { fuzzy = true, override_generic_sorter = true },
        file_browser = { hijack_netrw = true },
        frecency = {},
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      telescope.load_extension("fzf")
      telescope.load_extension("file_browser")
      telescope.load_extension("undo")
      telescope.load_extension("frecency")
    end,
  },
}