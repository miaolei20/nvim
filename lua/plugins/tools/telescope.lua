return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    event = { "BufReadPre", "BufNewFile" }, -- 延迟加载
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make", cond = function() return vim.fn.executable("make") == 1 end },
      "nvim-telescope/telescope-file-browser.nvim",
      "debugloop/telescope-undo.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "folke/which-key.nvim",
    },
    config = function()
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")

      telescope.setup({
        defaults = {
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = { width = 0.95, height = 0.85, preview_width = 0.6, prompt_position = "top" },
            vertical = { width = 0.85, height = 0.85, prompt_position = "top" },
          },
          path_display = { "smart" },
          file_ignore_patterns = { "^.git/", "^node_modules/", "^.venv/", "^.cache/" }, -- 精简并优化正则
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
            "--glob=!.git/*",
            "--glob=!node_modules/*",
            "--glob=!.venv/*",
            "--max-depth=5", -- 限制搜索深度
            "--threads=0", -- 自动线程优化
            "--mmap", -- 使用内存映射提升性能
          },
        },
        pickers = {
          find_files = {
            hidden = true,
            no_ignore = false,
            find_command = { "fd", "--type=f", "--strip-cwd-prefix", "--hidden", "--exclude=.git", "--max-depth=5" }, -- 添加深度限制
          },
          diagnostics = {
            theme = "ivy",
            layout_config = { height = 0.4 },
            line_width = 0.8,
          },
          live_grep = {
            only_sort_text = true,
            max_results = 3000, -- 适度放宽限制
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
          oldfiles = {
            theme = "dropdown",
            previewer = false,
            layout_config = { width = 0.8, height = 0.5 },
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
            path = "%:p:h",
            respect_gitignore = true,
            depth = 5, -- 限制深度
          },
          ["ui-select"] = require("telescope.themes").get_dropdown({
            previewer = false,
            layout_config = { width = 0.8, height = 0.5 },
          }),
          undo = {
            side_by_side = true,
            layout_strategy = "vertical",
            layout_config = { preview_height = 0.7 },
          },
        },
      })

      -- 异步加载扩展
      vim.defer_fn(function()
        local extensions = { "fzf", "file_browser", "undo", "ui-select" }
        for _, ext in ipairs(extensions) do
          local ok, err = pcall(telescope.load_extension, ext)
          if not ok then
            vim.api.nvim_echo({ { "Failed to load telescope extension: " .. ext .. " (" .. tostring(err) .. ")", "WarningMsg" } }, true, {})
          end
        end
      end, 100)

      -- 异步化 project_files 函数
      local is_inside_work_tree = {}
      local function project_files()
        local win_height = vim.api.nvim_win_get_height(0)
        local safe_height = math.max(15, math.floor(win_height * 0.7))
        local opts = {
          show_untracked = true,
          layout_config = { height = safe_height },
        }
        local cwd = vim.fn.getcwd()
        if is_inside_work_tree[cwd] ~= nil then
          if is_inside_work_tree[cwd] then
            builtin.git_files(opts)
          else
            builtin.find_files(opts)
          end
        else
          vim.system({ "git", "rev-parse", "--is-inside-work-tree" }, { text = true }, function(obj)
            is_inside_work_tree[cwd] = obj.code == 0
            vim.schedule(function()
              if is_inside_work_tree[cwd] then
                builtin.git_files(opts)
              else
                builtin.find_files(opts)
              end
            end)
          end)
        end
      end

      -- Keybindings with which-key
      local wk = require("which-key")
      wk.add({
        { "<leader>s", group = "Search", icon = "🔍" },
        { "<leader>sf", project_files, desc = "Find Files", mode = "n", icon = "📁" },
        { "<leader>sg", function() builtin.live_grep() end, desc = "Live Grep", mode = "n", icon = "🔎" },
        { "<leader>sd", function() builtin.diagnostics() end, desc = "Diagnostics", mode = "n", icon = "🩺" },
        { "<leader>sb", function() telescope.extensions.file_browser.file_browser() end, desc = "File Browser", mode = "n", icon = "📂" },
        { "<leader>su", function() telescope.extensions.undo.undo() end, desc = "Undo History", mode = "n", icon = "🔄" },
        { "<leader>sr", function() builtin.oldfiles() end, desc = "Recent Files", mode = "n", icon = "🕒" },
        { "<leader>so", function() builtin.buffers() end, desc = "Open Buffers", mode = "n", icon = "📋" },
      })
    end,
  },
}