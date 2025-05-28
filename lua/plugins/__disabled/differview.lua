return {
  "sindrets/diffview.nvim",
  cmd = {
    "DiffviewOpen",
    "DiffviewFileHistory",
    "DiffviewClose",
    "DiffviewToggleFiles",
    "DiffviewFocusFiles",
  },
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    use_icons = true,
    view = {
      merge_tool = {
        layout = "diff3_mixed", -- 可选: diff3_plain | diff3_mixed | diff3_horizontal
        disable_diagnostics = true,
      },
      default = {
        layout = "diff2_horizontal",
      },
    },
    file_panel = {
      listing_style = "tree",
      tree_options = {
        flatten_dirs = true,
        folder_statuses = "only_folded", -- or "always" | "never"
      },
    },
    keymaps = {
      view = {
        ["<leader>e"] = "<Cmd>DiffviewToggleFiles<CR>",
        ["q"] = "<Cmd>DiffviewClose<CR>",
      },
      file_panel = {
        ["j"] = "next_entry",
        ["k"] = "prev_entry",
        ["<cr>"] = "select_entry",
        ["s"] = "toggle_stage_entry",
        ["u"] = "toggle_stage_entry",
        ["R"] = "refresh_files",
        ["<tab>"] = "select_next_entry",
        ["<s-tab>"] = "select_prev_entry",
        ["q"] = "<Cmd>DiffviewClose<CR>",
      },
    },
  },
}
