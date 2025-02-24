-- file: plugins/telescope.lua
return {
  {
    "nvim-telescope/telescope.nvim",
    version = false,
    cmd = "Telescope",
    keys = function() -- 动态加载快捷键
      local function keymap(mode, lhs, rhs, desc)
        return { mode, lhs, rhs, desc = desc }
      end
      return {
        keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", "Find Files"),
        keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", "Live Grep"),
        keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", "Find Buffers"),
        keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", "Help Tags"),
        keymap("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", "Recent Files"),
        keymap("n", "<leader>fc", "<cmd>Telescope git_commits<cr>", "Git Commits"),
        keymap("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols"),
        keymap("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>", "Workspace Diagnostics"),
        keymap("n", "<leader>fw", "<cmd>Telescope grep_string<cr>", "Word Under Cursor"),
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
      local colors = require("onedark.palette").dark
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local action_layout = require("telescope.actions.layout")
      local transform_mod = require("telescope.actions.mt").transform_mod

      -- 深度主题适配
      vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = colors.gray, bg = colors.bg0 })
      vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = colors.cyan, bg = colors.bg1 })
      vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { fg = colors.bg1, bg = colors.bg0 })
      vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { link = "TelescopeResultsBorder" })
      vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = colors.bg2, bold = true })

      -- 增强型动作配置
      local custom_actions = transform_mod({
        -- 在垂直分割窗口中打开文件
        vsplit_selected = function(prompt_bufnr)
          actions.select_vertical(prompt_bufnr)
          vim.cmd("wincmd =") -- 自动调整窗口大小
        end,
        -- 在标签页中打开文件
        tab_selected = function(prompt_bufnr)
          actions.select_tab(prompt_bufnr)
          vim.cmd("tabdo wincmd =") -- 自动调整所有标签页窗口
        end,
      })

      telescope.setup({
        defaults = {
          dynamic_preview_title = true,
          prompt_prefix = "   ",
          selection_caret = "  ",
          entry_prefix = "   ",
          path_display = { "truncate" },
          sorting_strategy = "ascending",
          scroll_strategy = "cycle",
          layout_strategy = "horizontal",
          winblend = 10,
          borderchars = {
            prompt = { "─", " ", " ", " ", "─", "─", " ", " " },
            results = { " " },
            preview = { " " },
          },
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
              ["q"] = actions.close,
            }
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
            hidden = true,
            find_command = { "fd", "--type=file", "--hidden", "--exclude=.git" },
            theme = "dropdown",
          },
          live_grep = {
            theme = "ivy",
            previewer = false,
            layout_config = { height = 0.4 }
          },
          buffers = {
            sort_lastused = true,
            theme = "dropdown",
            previewer = false,
            mappings = {
              i = { ["<C-d>"] = actions.delete_buffer }
            }
          },
          git_commits = {
            theme = "ivy",
            layout_config = { width = 0.9 }
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
            theme = "dropdown",
            hijack_netrw = true,
            hidden = true,
            respect_gitignore = false,
          },
          undo = {
            use_delta = true,
            side_by_side = true,
            layout_strategy = "vertical",
            layout_config = { preview_height = 0.6 },
          }
        }
      })

      -- 加载扩展
      telescope.load_extension("fzf")
      telescope.load_extension("file_browser")
      telescope.load_extension("undo")

      -- 增强快捷键
      vim.keymap.set("n", "<leader>fe", function()
        telescope.extensions.file_browser.file_browser({
          path = "%:p:h",
          grouped = true,
        })
      end, { desc = "File Browser" })

      vim.keymap.set("n", "<leader>fu", "<cmd>Telescope undo<cr>", { desc = "Undo History" })
    end
  }
}