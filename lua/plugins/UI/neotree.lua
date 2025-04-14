return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    event = "BufEnter", -- Load when entering a buffer
    cmd = { "Neotree" }, -- Also load on :Neotree
    opts = {
      close_if_last_window = false, -- Keep open if last window
      popup_border_style = "rounded", -- VSCode-like borders
      enable_git_status = true, -- Show git status
      enable_diagnostics = true, -- Show LSP diagnostics
      open_files_do_not_replace_types = { "terminal", "trouble", "qf" }, -- Don’t replace special buffers
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
      window = {
        position = "left",
        width = 40,
        mapping_options = {
          noremap = true,
          nowait = true,
        },
        mappings = {
          ["<space>"] = "toggle_node", -- Toggle directory
          ["<cr>"] = "open", -- Open file/directory
          ["<tab>"] = "open_with_window_picker", -- Open with window picker
          ["P"] = { "toggle_preview", config = { use_float = true } }, -- Preview file
          ["a"] = { "add", config = { show_path = "relative" } }, -- Create file
          ["A"] = { "add_directory", config = { show_path = "relative" } }, -- Create directory
          ["d"] = "delete", -- Delete file/directory
          ["r"] = "rename", -- Rename file/directory
          ["y"] = "copy_to_clipboard", -- Copy to clipboard
          ["x"] = "cut_to_clipboard", -- Cut to clipboard
          ["p"] = "paste_from_clipboard", -- Paste from clipboard
          ["c"] = "copy", -- Copy file/directory
          ["m"] = "move", -- Move file/directory
          ["q"] = "close_window", -- Close Neo-Tree
          ["R"] = "refresh", -- Refresh tree
          ["?"] = "show_help", -- Show help
          ["["] = "prev_source", -- Previous source (e.g., filesystem, git)
          ["]"] = "next_source", -- Next source
          ["H"] = "toggle_hidden", -- Toggle hidden files
        },
      },
      filesystem = {
        filtered_items = {
          visible = false, -- Show hidden by default
          hide_dotfiles = false,
          hide_gitignored = true,
          hide_by_name = { ".git", "node_modules" },
          never_show = { ".DS_Store" },
        },
        follow_current_file = {
          enabled = true, -- Auto-focus current file
          leave_dirs_open = false, -- Close dirs when switching
        },
        use_libuv_file_watcher = true, -- Auto-refresh on file changes
      },
    },
    config = function(_, opts)
      require("neo-tree").setup(opts)
      -- Optional: Set highlights to match onedarkpro
      vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "#1e222a", fg = "#abb2bf" })
      vim.api.nvim_set_hl(0, "NeoTreeFloatBorder", { fg = "#56b6c2", bg = "#1e222a" })
      vim.api.nvim_set_hl(0, "NeoTreeGitAdded", { fg = "#98c379" })
      vim.api.nvim_set_hl(0, "NeoTreeGitModified", { fg = "#e5c07b" })
      vim.api.nvim_set_hl(0, "NeoTreeGitDeleted", { fg = "#e06c75" })
    end,
  },
}
