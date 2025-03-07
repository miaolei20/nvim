return {
  {
    "nvim-telescope/telescope.nvim",
    version = false,
    cmd = "Telescope",
    keys = function()
      local builtin = require("telescope.builtin")
      return {
        { "<leader>ff", builtin.find_files,           desc = "Find Files" },
        { "<leader>fg", builtin.live_grep,            desc = "Live Grep" },
        { "<leader>fb", builtin.buffers,              desc = "Find Buffers" },
        { "<leader>fh", builtin.help_tags,            desc = "Help Tags" },
        { "<leader>fr", builtin.oldfiles,             desc = "Recent Files" },
        { "<leader>fs", builtin.lsp_document_symbols, desc = "Document Symbols" },
        { "<leader>fd", builtin.diagnostics,          desc = "Workspace Diagnostics" },
        { "<leader>fw", builtin.grep_string,          desc = "Word Under Cursor" },
      }
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-tree/nvim-web-devicons",
      "debugloop/telescope-undo.nvim",
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local action_layout = require("telescope.actions.layout")
      local transform_mod = require("telescope.actions.mt").transform_mod

      -- 尝试加载 onedark 调色板，用于自定义 Telescope 界面颜色
      local ok, palette = pcall(require, "onedark.palette")
      if ok then
        palette = palette.dark
        vim.api.nvim_set_hl(0, "TelescopeBorder",       { fg = palette.gray, bg = palette.bg0 })
        vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = palette.cyan, bg = palette.bg1 })
        vim.api.nvim_set_hl(0, "TelescopeResultsBorder",{ fg = palette.gray, bg = palette.bg0 })
        vim.api.nvim_set_hl(0, "TelescopePreviewBorder",{ link = "TelescopeResultsBorder" })
        vim.api.nvim_set_hl(0, "TelescopeSelection",    { bg = palette.bg2, bold = true })
      else
        vim.notify("onedark.palette not found, skipping UI customizations", vim.log.levels.WARN)
      end

      -- 自定义边框样式：统一使用圆角边框
      local borderchars = {
        prompt  = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        results = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      }

      -- 自定义操作：垂直分割/标签页打开后自动均分窗口
      local custom_actions = transform_mod({
        vsplit_selected = function(prompt_bufnr)
          actions.select_vertical(prompt_bufnr)
          vim.cmd("wincmd =")
        end,
        tab_selected = function(prompt_bufnr)
          actions.select_tab(prompt_bufnr)
          vim.cmd("tabdo wincmd =")
        end,
      })

      telescope.setup({
        defaults = {
          dynamic_preview_title = true,
          prompt_prefix         = "   ", -- 现代化搜索图标
          selection_caret       = "  ",
          entry_prefix          = "   ",
          path_display          = { "truncate" },
          sorting_strategy      = "ascending",
          scroll_strategy       = "cycle",
          layout_strategy       = "horizontal",
          winblend              = 10,
          borderchars           = borderchars,
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-v>"] = custom_actions.vsplit_selected,
              ["<C-t>"] = custom_actions.tab_selected,
              ["<C-u>"] = action_layout.toggle_preview,
              ["<C-f>"] = actions.to_fuzzy_refine,
              ["<ESC>"] = actions.close,
            },
            n = {
              ["<C-u>"] = action_layout.toggle_preview,
              ["q"]     = actions.close,
            },
          },
          file_ignore_patterns = {
            "%.git/.*", "node_modules/.*", "%.idea/.*",
            "%.vscode/.*", "__pycache__/.*", "%.class"
          },
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
            hidden       = true,
            find_command = { "fd", "--type=file", "--hidden", "--exclude=.git" },
            theme        = "dropdown",
          },
          live_grep = {
            theme         = "ivy",
            previewer     = false,
            layout_config = { height = 0.4 },
          },
          buffers = {
            sort_lastused = true,
            theme         = "dropdown",
            previewer     = false,
            mappings      = {
              i = { ["<C-d>"] = actions.delete_buffer },
            },
          },
          git_commits = {
            theme         = "ivy",
            layout_config = { width = 0.9 },
          },
        },
        extensions = {
          fzf = {
            fuzzy                   = true,
            override_generic_sorter = true,
            override_file_sorter    = true,
            case_mode               = "smart_case",
          },
          file_browser = {
            theme             = "dropdown",
            hijack_netrw      = true,
            hidden            = true,
            respect_gitignore = false,
          },
          undo = {
            use_delta       = true,
            side_by_side    = true,
            layout_strategy = "vertical",
            layout_config   = { preview_height = 0.6 },
          },
        },
      })

      -- 加载扩展
      telescope.load_extension("fzf")
      telescope.load_extension("file_browser")
      telescope.load_extension("undo")

      -- 附加快捷键：文件浏览器 & 撤销历史
      vim.keymap.set("n", "<leader>fe", function()
        telescope.extensions.file_browser.file_browser({
          path    = "%:p:h",
          grouped = true,
        })
      end, { desc = "File Browser" })

      vim.keymap.set("n", "<leader>fu", "<cmd>Telescope undo<cr>", { desc = "Undo History" })
    end,
  },
}
