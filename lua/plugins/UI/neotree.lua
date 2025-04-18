return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    cmd = { "Neotree" },
    opts = {
      close_if_last_window = true,
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,
      window = {
        position = "left",
        width = 40,
      },
      filesystem = {
        filtered_items = {
          visible = false,
          hide_dotfiles = true,
          hide_gitignored = true,
        },
      },
    },
    config = function(_, opts)
      require("neo-tree").setup(opts)

      -- Register explorer mappings
      local wk = require("which-key")
      wk.add({
        { "<leader>e", group = "Explorer", icon = "󰉋" },
        { "<leader>et", "<cmd>Neotree toggle left<CR>", desc = "Toggle Explorer", icon = "󰐿", mode = "n" },
        { "<leader>ef", "<cmd>Neotree focus left<CR>", desc = "Focus Explorer", icon = "󰋱", mode = "n" },
        { "<leader>eg", "<cmd>Neotree git_status left<CR>", desc = "Git Status", icon = "󰜘", mode = "n" },
        { "<leader>eb", "<cmd>Neotree buffers left<CR>", desc = "Buffer List", icon = "󰈤", mode = "n" },
      })

      -- Register neo-tree buffer mappings
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "neo-tree",
        callback = function()
          wk.add({
            { "e", group = "Neo-Tree", icon = "󰉋" },
            { "et", "toggle_node", desc = "Toggle Node", icon = "󰁙", mode = "n" },
            { "eo", "open", desc = "Open", icon = "󰌑", mode = "n" },
            { "ew", "open_with_window_picker", desc = "Open in Window", icon = "󱂬", mode = "n" },
            { "ep", "toggle_preview", desc = "Toggle Preview", icon = "󰋲", mode = "n" },
            { "ea", "add", desc = "Add File", icon = "󰝒", mode = "n" },
            { "eA", "add_directory", desc = "Add Directory", icon = "󰉌", mode = "n" },
            { "ed", "delete", desc = "Delete", icon = "󰅖", mode = "n" },
            { "er", "rename", desc = "Rename", icon = "󰑕", mode = "n" },
            { "ey", "copy_to_clipboard", desc = "Copy to Clipboard", icon = "󰅍", mode = "n" },
            { "ex", "cut_to_clipboard", desc = "Cut to Clipboard", icon = "󰆐", mode = "n" },
            { "es", "paste_from_clipboard", desc = "Paste from Clipboard", icon = "󰆒", mode = "n" },
            { "ec", "copy", desc = "Copy File", icon = "󰉍", mode = "n" },
            { "em", "move", desc = "Move File", icon = "󰹑", mode = "n" },
            { "eq", "close_window", desc = "Close Explorer", icon = "󰅘", mode = "n" },
            { "eR", "refresh", desc = "Refresh", icon = "󰑐", mode = "n" },
            { "e?", "show_help", desc = "Show Help", icon = "󰋖", mode = "n" },
            { "eh", "toggle_hidden", desc = "Toggle Hidden", icon = "󰘓", mode = "n" },
          }, { buffer = vim.api.nvim_get_current_buf() })
        end,
      })
    end,
  },
}