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
    { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find Files" },
    { "<leader>fg", "<cmd>Telescope live_grep<CR>",  desc = "Live Grep" },
    { "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "Diagnostics" },
    { "<leader>fb", "<cmd>Telescope file_browser<CR>", desc = "File Browser" },
    { "<leader>fu", "<cmd>Telescope undo<CR>",        desc = "Undo History" },
    { "<leader>fr", "<cmd>Telescope frecency<CR>",   desc = "Frecency" },
    { "<leader>fl", "<cmd>Telescope lazy<CR>",       desc = "Lazy Plugins" },
    { "<leader>fs", "<cmd>Telescope luasnip<CR>",    desc = "Snippets" },
  },
  opts = {
    defaults = {
      layout_strategy = "horizontal",
      layout_config = {
        horizontal = { 
          width = 0.95,
          height = 0.85,
          preview_width = 0.55,
        },
        vertical = { width = 0.85, height = 0.85 },
      },
      path_display = { "truncate" },
      file_ignore_patterns = {
        "^.git/",
        "^node_modules/",
        "^.venv/",
        "^.cache/",
        "%.lock",
      },
      mappings = {
        i = {
          ["<C-j>"] = "move_selection_next",
          ["<C-k>"] = "move_selection_previous",
          ["<Esc>"] = "close",
          ["<CR>"]  = "select_default",
        },
      },
    },
    pickers = {
      find_files = {
        hidden = true,
        no_ignore = false,
        find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
      },
      diagnostics = { theme = "ivy" },
      luasnip = { theme = "dropdown" },
    },
    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
      },
      file_browser = {
        hijack_netrw = true,
        hidden = true,
        grouped = true,
      },
      ["ui-select"] = require("telescope.themes").get_dropdown({
        previewer = false,
        layout_config = {
          width = 0.8,
          height = 0.5,
        }
      }),
    },
  },
  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts)

    -- Safe load extensions
    local extensions = {
      "fzf",
      "file_browser",
      "undo",
      "frecency",
      "ui-select",
      "lazy",
      "luasnip"
    }

    for _, ext in ipairs(extensions) do
      local ok, _ = pcall(telescope.load_extension, ext)
      if not ok then
        vim.notify("Failed to load telescope extension: " .. ext, vim.log.levels.WARN)
      end
    end
  end,
}
