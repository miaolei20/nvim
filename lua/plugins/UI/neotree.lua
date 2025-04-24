return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      "folke/which-key.nvim", -- 明确声明 which-key 依赖
    },
    cmd = { "Neotree" },
    -- 确保在特定事件触发时加载，避免未加载问题
    event = { "BufEnter", "VimEnter" },
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
      local wk = require("which-key")

      -- Debug logging
      local function debug_log(msg)
        if vim.g.debug_neotree then
          vim.notify("[Neo-tree] " .. msg, vim.log.levels.DEBUG)
        end
      end

      -- Setup Neo-tree
      require("neo-tree").setup(opts)
      debug_log("Neo-tree setup complete")

      -- Automatically open Neo-tree on startup (if configured)
      if opts.open_on_setup then
        vim.api.nvim_create_autocmd("VimEnter", {
          callback = function()
            if vim.fn.argc() == 0 then -- Only open if no file is opened
              vim.cmd("Neotree show left")
              debug_log("Neo-tree opened on startup")
            end
          end,
          once = true,
        })
      end

      -- Register global explorer mappings
      wk.add({
        { "<leader>e", group = "Explorer", icon = "󰉋" },
        { "<leader>et", "<cmd>Neotree toggle left<CR>", desc = "Toggle Explorer", icon = "󰐿", mode = "n" },
        { "<leader>ef", "<cmd>Neotree focus left<CR>", desc = "Focus Explorer", icon = "󰋱", mode = "n" },
        { "<leader>eg", "<cmd>Neotree git_status left<CR>", desc = "Git Status", icon = "󰜘", mode = "n" },
        { "<leader>eb", "<cmd>Neotree buffers left<CR>", desc = "Buffer List", icon = "󰈤", mode = "n" },
      })
      debug_log("Global explorer mappings registered")

      -- Register neo-tree buffer mappings
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "neo-tree",
        callback = function(args)
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
          }, { buffer = args.buf })
          debug_log("Neo-tree buffer mappings registered for buffer " .. args.buf)
        end,
      })
    end,
  },
}