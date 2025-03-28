return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-file-browser.nvim",
      "debugloop/telescope-undo.nvim",
      "nvim-telescope/telescope-frecency.nvim",
    },
    keys = function()
      local builtin = require("telescope.builtin")
      return {
        { "<leader>ff", builtin.find_files, desc = "Find Files" },
        { "<leader>fg", builtin.live_grep, desc = "Live Grep" },
        { "<leader>fs", "<cmd>Telescope frecency<CR>", desc = "Recent Files" },
        { "<leader>fe", "<cmd>Telescope file_browser path=%:p:h<CR>", desc = "File Explorer" },
        { "<leader>fu", "<cmd>Telescope undo<CR>", desc = "Undo History" },
      }
    end,
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      -- Modern, minimal highlighting
      vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = "#545c7e" })
      vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = "#56b6c2" })
      vim.api.nvim_set_hl(0, "TelescopeTitle", { fg = "#56b6c2", bold = true })

      telescope.setup({
        defaults = {
          prompt_prefix = " ",
          path_display = { "truncate" },
          borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<Esc>"] = actions.close,
            },
          },
          file_ignore_patterns = { ".git/", "node_modules/" },
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
        },
        pickers = {
          find_files = {
            hidden = true,
            find_command = { "fd", "--type", "f", "--hidden", "--strip-cwd-prefix" },
          },
        },
        extensions = {
          fzf = { fuzzy = true },
          frecency = {
            show_scores = false,
            show_unindexed = true,
            ignore_patterns = { "*.git/*" },
          },
          file_browser = {
            hijack_netrw = true,
            hidden = true,
          },
        },
      })

      -- Load extensions on demand
      telescope.load_extension("fzf")
      telescope.load_extension("file_browser")
      telescope.load_extension("undo")
      telescope.load_extension("frecency")
    end,
  },
}