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
    "nvim-telescope/telescope-fzf-writer.nvim",
  },
  opts = function()
    local actions = require("telescope.actions")
    local themes = require("telescope.themes")

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
      fzf_writer = {
        minimum_grep_characters = 2,
        minimum_files_characters = 2,
        use_highlighter = true,
      },
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

    -- 加载扩展
    local extensions_to_load = { "fzf", "file_browser", "undo", "frecency", "ui-select", "lazy", "fzf_writer" }
    for _, ext in ipairs(extensions_to_load) do
      local ok = pcall(telescope.load_extension, ext)
      if not ok then
        vim.notify("Failed to load telescope extension: " .. ext, vim.log.levels.WARN)
      end
    end

    -- 定义 project_files 函数，使用 git_files 当可能时
    local is_inside_work_tree = {}
    local function project_files()
      local opts = {}
      local cwd = vim.fn.getcwd()
      if is_inside_work_tree[cwd] == nil then
        vim.fn.system("git rev-parse --is-inside-work-tree")
        is_inside_work_tree[cwd] = vim.v.shell_error == 0
      end
      if is_inside_work_tree[cwd] then
        require("telescope.builtin").git_files(opts)
      else
        require("telescope.builtin").find_files(opts)
      end
    end

    -- 设置键映射
    vim.keymap.set("n", "<leader>ff", project_files, { desc = "Find Files" })
    vim.keymap.set("n", "<leader>fg", function() require('telescope').extensions.fzf_writer.grep() end, { desc = "Live Grep" })
    vim.keymap.set("n", "<leader>fd", function() require('telescope.builtin').diagnostics() end, { desc = "Diagnostics" })
    vim.keymap.set("n", "<leader>fb", function() require('telescope').extensions.file_browser.file_browser() end, { desc = "File Browser" })
    vim.keymap.set("n", "<leader>fu", function() require('telescope').extensions.undo.undo() end, { desc = "Undo History" })
    vim.keymap.set("n", "<leader>fr", function() require('telescope').extensions.frecency.frecency() end, { desc = "Frecency" })
    vim.keymap.set("n", "<leader>fl", function() require('telescope').extensions.lazy.lazy() end, { desc = "Lazy Plugins" })
  end,
}
