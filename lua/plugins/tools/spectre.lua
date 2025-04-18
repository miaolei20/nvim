return {
  {
    "nvim-pack/nvim-spectre",
    dependencies = { "nvim-lua/plenary.nvim", "folke/which-key.nvim" },
    keys = {
      { "<leader>sr", "<cmd>Spectre<CR>", desc = "Search/Replace", mode = "n" },
      { "<leader>sR", ":Spectre %<CR>", desc = "Search/Replace Current File", mode = "n" },
    },
    opts = {
      open_cmd = "vsplit", -- Open in vertical split
      default = {
        find = {
          cmd = "rg", -- Use ripgrep for fast search
          options = { "ignore-case", "hidden" }, -- Case-insensitive, include hidden files
        },
        replace = {
          cmd = "sed", -- Use sed for replacement
        },
      },
      mapping = {
        ["run_replace"] = { map = "<leader>r", cmd = "<cmd>lua require('spectre').actions.run_replace()<CR>", desc = "Run Replace" },
        ["toggle_ignore_case"] = { map = "<leader>i", cmd = "<cmd>lua require('spectre').actions.toggle_ignore_case()<CR>", desc = "Toggle Case Sensitivity" },
      },
      live_update = true, -- Update results as you type
      is_insert_mode = true, -- Start in insert mode for query
      highlight = {
        ui = "String",
        search = "DiffChange",
        replace = "DiffDelete",
      },
    },
    config = function(_, opts)
      require("spectre").setup(opts)
      local wk = require("which-key")
      wk.add({
        { "<leader>s", group = "Search", icon = "🔍" },
        { "<leader>sr", "<cmd>Spectre<CR>", desc = "Search/Replace Project", mode = "n", icon = "󰬉" },
        { "<leader>sR", ":Spectre %<CR>", desc = "Search/Replace Current File", mode = "n", icon = "📝" },
      })
    end,
  },
}