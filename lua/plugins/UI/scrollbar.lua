return {
  {
    "petertriho/nvim-scrollbar",
    event = "BufReadPost",
    dependencies = { "kevinhwang91/nvim-hlslens" },
    config = function()
      -- Modern color scheme
      local colors = {
        grey   = "#5c6370", -- Handle
        red    = "#f38ba8", -- Error
        yellow = "#f9e2af", -- Warn
        blue   = "#89b4fa", -- Info
        cyan   = "#94e2d5", -- Hint
        purple = "#cba6f7", -- Search
      }

      -- Setup with explicit text arrays to fix extmark error
      require("scrollbar").setup({
        handle = {
          color = colors.grey,
          blend = 40,
          hide_if_all_visible = true,
        },
        marks = {
          Error  = { color = colors.red,    text = {"●"} },
          Warn   = { color = colors.yellow, text = {"◆"} },
          Info   = { color = colors.blue,   text = {"■"} },
          Hint   = { color = colors.cyan,   text = {"▲"} },
          Search = { color = colors.purple, text = {"◈"} },
        },
        excluded_filetypes = {
          "NvimTree",
          "TelescopePrompt",
          "alpha",
          "lazy",
          "cmp_menu",
        },
        handlers = {
          cursor = false,
          diagnostic = true,
          gitsigns = true,
          search = true,
        },
      })

      -- Set handle highlight
      vim.api.nvim_set_hl(0, "ScrollbarHandle", { bg = colors.grey, blend = 40 })

      -- Validate setup
      local ok, err = pcall(require("scrollbar").show)
      if not ok then
        vim.notify("Scrollbar failed: " .. err, vim.log.levels.ERROR)
      end
    end,
  },
}