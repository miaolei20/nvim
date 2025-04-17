return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    event = { "BufEnter", "VeryLazy" }, -- Load on buffer enter or lazily
    cmd = { "Neotree" }, -- Load on :Neotree command
    opts = {
      close_if_last_window = false, -- Keep Neo-Tree open if last window
      popup_border_style = "rounded", -- VSCode-like rounded borders
      enable_git_status = true, -- Enable git integration
      enable_diagnostics = true, -- Enable LSP diagnostics
      open_files_do_not_replace_types = { "terminal", "trouble", "qf" }, -- Avoid replacing special buffers
      -- Default component configurations
      default_component_configs = {
        icon = {
          folder_closed = "󰉋",
          folder_open = "󰝰",
          folder_empty = "󰉖",
          default = "󰈔",
        },
        git_status = {
          symbols = {
            added = "✚",
            modified = "✹",
            deleted = "✖",
            renamed = "➜",
            untracked = "?",
            ignored = "◌",
            unstaged = "□",
            staged = "■",
            conflict = "",
          },
        },
      },
      -- Window settings
      window = {
        position = "left",
        width = 40,
        mapping_options = {
          noremap = true,
          nowait = true,
        },
        mappings = {
          -- Navigation
          ["<space>"] = "toggle_node", -- Toggle directory
          ["<cr>"] = "open", -- Open file/directory
          ["<tab>"] = "open_with_window_picker", -- Open in selected window
          ["H"] = "toggle_hidden", -- Toggle hidden files
          -- File operations
          ["a"] = { "add", config = { show_path = "relative" } }, -- Create file
          ["A"] = { "add_directory", config = { show_path = "relative" } }, -- Create directory
          ["d"] = "delete", -- Delete file/directory
          ["r"] = "rename", -- Rename file/directory
          ["c"] = "copy", -- Copy file/directory
          ["m"] = "move", -- Move file/directory
          -- Clipboard
          ["y"] = "copy_to_clipboard", -- Copy to clipboard
          ["x"] = "cut_to_clipboard", -- Cut to clipboard
          ["p"] = "paste_from_clipboard", -- Paste from clipboard
          -- Preview and utilities
          ["P"] = { "toggle_preview", config = { use_float = true } }, -- Toggle preview
          ["R"] = "refresh", -- Refresh tree
          ["q"] = "close_window", -- Close Neo-Tree
          ["?"] = "show_help", -- Show help
          ["["] = "prev_source", -- Previous source (filesystem, git, etc.)
          ["]"] = "next_source", -- Next source
        },
      },
      -- Filesystem settings
      filesystem = {
        filtered_items = {
          visible = false, -- Hidden files not visible by default
          hide_dotfiles = false, -- Show dotfiles
          hide_gitignored = true, -- Hide gitignored files
          hide_by_name = { ".git", "node_modules" }, -- Always hide specific names
          never_show = { ".DS_Store", "thumbs.db" }, -- Never show these files
        },
        follow_current_file = {
          enabled = true, -- Auto-focus current file
          leave_dirs_open = false, -- Close directories when switching files
        },
        use_libuv_file_watcher = true, -- Auto-refresh on filesystem changes
        hijack_netrw_behavior = "open_default", -- Replace netrw
      },
      -- Event handlers for performance
      event_handlers = {
        {
          event = "neo_tree_buffer_enter",
          handler = function()
            vim.opt_local.signcolumn = "auto" -- Dynamic signcolumn for diagnostics
          end,
        },
      },
    },
    config = function(_, opts)
      -- Setup Neo-Tree with provided options
      require("neo-tree").setup(opts)
      -- Set highlights to match onedarkpro and heirline.nvim palette
      local colors = require("onedarkpro.helpers").get_colors() or {
        bg = "#1e222a",
        fg = "#abb2bf",
        green = "#98c379",
        yellow = "#e5c07b",
        red = "#e06c75",
        accent = "#56b6c2",
      }
      vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = colors.bg, fg = colors.fg })
      vim.api.nvim_set_hl(0, "NeoTreeFloatBorder", { fg = colors.accent, bg = colors.bg })
      vim.api.nvim_set_hl(0, "NeoTreeGitAdded", { fg = colors.green })
      vim.api.nvim_set_hl(0, "NeoTreeGitModified", { fg = colors.yellow })
      vim.api.nvim_set_hl(0, "NeoTreeGitDeleted", { fg = colors.red })
      vim.api.nvim_set_hl(0, "NeoTreeDirectoryIcon", { fg = colors.accent })
      vim.api.nvim_set_hl(0, "NeoTreeFileIcon", { fg = colors.fg })
    end,
  },
}