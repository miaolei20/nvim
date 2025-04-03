return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-telescope/telescope-file-browser.nvim",
    "debugloop/telescope-undo.nvim",
    "nvim-telescope/telescope-frecency.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    "tsakirist/telescope-lazy.nvim",
    "benfowler/telescope-luasnip.nvim",
  },
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Files" },
    { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Grep" },
    { "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "Diagnostics" },
    { "<leader>fb", "<cmd>Telescope file_browser<CR>", desc = "Browser" },
    { "<leader>fu", "<cmd>Telescope undo<CR>", desc = "Undo" },
    { "<leader>fr", "<cmd>Telescope frecency<CR>", desc = "Recent" },
    { "<leader>fl", "<cmd>Telescope lazy<CR>", desc = "Plugins" },
    { "<leader>fs", "<cmd>Telescope luasnip<CR>", desc = "Snippets" },
  },
  opts = {
    defaults = {
      layout_config = { width = 0.95, height = 0.85 },
      path_display = { "truncate" },
      file_ignore_patterns = { ".git/", "node_modules/" },
      mappings = {
        i = {
          ["<C-j>"] = "move_selection_next",
          ["<C-k>"] = "move_selection_previous",
          ["<Esc>"] = "close",
          ["<CR>"] = "select_default",
        },
      },
    },
    pickers = {
      find_files = { hidden = true },
      diagnostics = { theme = "ivy" },
      luasnip = { theme = "dropdown" },
    },
    extensions = {
      fzf = { fuzzy = true },
      file_browser = { hijack_netrw = true },
      ["ui-select"] = { layout_strategy = "dropdown", previewer = false },
    },
  },
  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts)
    local extensions = { "fzf", "file_browser", "undo", "frecency", "ui-select", "lazy", "luasnip" }
    for _, ext in ipairs(extensions) do
      pcall(telescope.load_extension, ext)
    end
  end,
}