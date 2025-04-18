local M = {}

M.opts = {
  defaults = {
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        width = 0.95,
        height = 0.85,
        preview_width = 0.6,
        prompt_position = "top",
      },
      vertical = {
        width = 0.85,
        height = 0.85,
        prompt_position = "top",
      },
    },
    path_display = { "smart" },
    file_ignore_patterns = {
      "%.git/",
      "node_modules/",
      "%.venv/",
      "%.cache/",
      "%.lock$",
      "%.o$",
      "%.a$",
      "%.out$",
    },
    mappings = {
      i = {
        ["<C-j>"] = "move_selection_next",
        ["<C-k>"] = "move_selection_previous",
        ["<Esc>"] = "close",
        ["<CR>"] = "select_default",
        ["<C-u>"] = "preview_scrolling_up",
        ["<C-d>"] = "preview_scrolling_down",
      },
      n = {
        ["q"] = "close",
        ["<Esc>"] = "close",
        ["<CR>"] = "select_default",
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
      "--glob=!.git/",
    },
  },
  pickers = {
    find_files = {
      hidden = true,
      no_ignore = false,
      find_command = { "fd", "--type=f", "--strip-cwd-prefix", "--hidden", "--exclude=.git" },
    },
    diagnostics = {
      theme = "ivy",
      layout_config = { height = 0.4, preview_cutoff = 120 },
      line_width = 0.8,
    },
    live_grep = {
      only_sort_text = true,
      max_results = 1500,
    },
    buffers = {
      theme = "dropdown",
      previewer = false,
      sort_lastused = true,
      mappings = {
        i = { ["<C-d>"] = "delete_buffer" },
        n = { ["d"] = "delete_buffer" },
      },
    },
  },
  extensions = {
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
      path = "%:p:h",
      respect_gitignore = true,
    },
    ["ui-select"] = require("telescope.themes").get_dropdown({
      previewer = false,
      layout_config = { width = 0.8, height = 0.5 },
    }),
    fzf_writer = {
      minimum_grep_characters = 2,
      minimum_files_characters = 2,
      use_highlighter = true,
    },
    undo = {
      side_by_side = true,
      layout_strategy = "vertical",
      layout_config = { preview_height = 0.7 },
    },
    frecency = {
      show_scores = false,
      show_unindexed = true,
      ignore_patterns = { "*.git/*", "*/tmp/*" },
    },
    lazy = {
      theme = "ivy",
      mappings = {
        i = { ["<CR>"] = "open_config" },
        n = { ["c"] = "open_config" },
      },
    },
    notify = {
      theme = "ivy",
      layout_config = { height = 0.4 },
    },
  },
}

function M.setup(opts)
  local telescope = require("telescope")
  telescope.setup(opts)

  -- Load extensions
  local extensions = { "fzf", "file_browser", "undo", "frecency", "ui-select", "lazy", "fzf_writer", "notify" }
  for _, ext in ipairs(extensions) do
    local ok, err = pcall(telescope.load_extension, ext)
    if not ok then
      vim.notify("Failed to load telescope extension: " .. ext .. " (" .. tostring(err) .. ")", vim.log.levels.WARN)
    end
  end

  -- Project files function
  local is_inside_work_tree = {}
  local function project_files()
    local cwd = vim.fn.getcwd()
    if is_inside_work_tree[cwd] == nil then
      local job = vim.fn.jobstart("git rev-parse --is-inside-work-tree", {
        on_exit = function(_, code)
          is_inside_work_tree[cwd] = code == 0
        end,
      })
      vim.fn.jobwait({ job }, 1000)
    end
    local builtin = require("telescope.builtin")
    local opts = { show_untracked = true }
    if is_inside_work_tree[cwd] then
      builtin.git_files(opts)
    else
      builtin.find_files(opts)
    end
  end

  -- Keybindings with which-key
  local wk = require("which-key")
  wk.add({
    { "<leader>s", group = "Search", icon = "🔍" },
    { "<leader>sf", project_files, desc = "Find Files", mode = "n", icon = "📁" },
    { "<leader>sg", function() require("telescope").extensions.fzf_writer.grep() end, desc = "Live Grep", mode = "n", icon = "🔎" },
    { "<leader>sd", function() require("telescope.builtin").diagnostics() end, desc = "Diagnostics", mode = "n", icon = "🩺" },
    { "<leader>sb", function() require("telescope").extensions.file_browser.file_browser() end, desc = "File Browser", mode = "n", icon = "📂" },
    { "<leader>su", function() require("telescope").extensions.undo.undo() end, desc = "Undo History", mode = "n", icon = "🔄" },
    { "<leader>sr", function() require("telescope").extensions.frecency.frecency() end, desc = "Recent Files", mode = "n", icon = "🕒" },
    { "<leader>sl", function() require("telescope").extensions.lazy.lazy() end, desc = "Lazy Plugins", mode = "n", icon = "📦" },
    { "<leader>sn", function() require("telescope").extensions.notify.notify() end, desc = "Notifications", mode = "n", icon = "🔔" },
    { "<leader>so", function() require("telescope.builtin").buffers() end, desc = "Open Buffers", mode = "n", icon = "📋" },
  })
end

return M