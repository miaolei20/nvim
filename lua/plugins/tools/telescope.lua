return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  event = "VeryLazy",
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find Files" },
    { "<leader>fg", "<cmd>Telescope live_grep<CR>",  desc = "Live Grep" },
    { "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "Diagnostics" },
    { "<leader>fb", "<cmd>Telescope file_browser<CR>", desc = "File Browser" },
    { "<leader>fu", "<cmd>Telescope undo<CR>",        desc = "Undo History" },
    { "<leader>fr", "<cmd>Telescope frecency<CR>",    desc = "Frecency" },
    { "<leader>fl", "<cmd>Telescope lazy<CR>",        desc = "Lazy Plugins" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-telescope/telescope-file-browser.nvim",
    "debugloop/telescope-undo.nvim",
    "nvim-telescope/telescope-frecency.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    "tsakirist/telescope-lazy.nvim",
  },
  opts = function()
    local actions = require("telescope.actions")
    local themes = require("telescope.themes")

    -- 将默认配置拆分为局部变量，避免多层嵌套
    local defaults = {
      layout_strategy = "horizontal",
      layout_config = {
        horizontal = {
          width = 0.95,
          height = 0.85,
          preview_width = 0.55,
          prompt_position = "top",
        },
        vertical = {
          width = 0.85,
          height = 0.85,
          prompt_position = "top",
        },
      },
      path_display = { "truncate" },
      file_ignore_patterns = {
        "%.git/.*",
        "node_modules/.*",
        "%.venv/.*",
        "%.cache/.*",
        ".*%.lock",
      },
      mappings = {
        i = {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<Esc>"]  = actions.close,
          ["<CR>"]  = actions.select_default,
        },
      },
      sorting_strategy = "ascending",
      set_env = { ["COLORTERM"] = "truecolor" },
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--hidden",
      },
    }

    local pickers = {
      find_files = {
        hidden = true,
        no_ignore = false,
        find_command = { "fd", "--type=f", "--strip-cwd-prefix", "--hidden" },
      },
      diagnostics = {
        theme = "ivy",
        layout_config = { height = 0.4 },
      },
      live_grep = {
        only_sort_text = true,
        max_results = 1000,
      },
    }

    local extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case",
      },
      file_browser = {
        hijack_netrw = true,
        hidden = true,
        grouped = true,
        initial_mode = "normal",
        auto_depth = true,
      },
      ["ui-select"] = themes.get_dropdown({
        previewer = false,
        layout_config = { width = 0.8, height = 0.5 },
      }),
    }

    return {
      defaults = defaults,
      pickers = pickers,
      extensions = extensions,
    }
  end,
  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts)

    -- 使用局部列表加载扩展，并在加载失败时发出警告
    local extensions_to_load = { "fzf", "file_browser", "undo", "frecency", "ui-select", "lazy" }
    for _, ext in ipairs(extensions_to_load) do
      local ok = pcall(telescope.load_extension, ext)
      if not ok then
        vim.notify("Failed to load telescope extension: " .. ext, vim.log.levels.WARN)
      end
    end
  end,
}
