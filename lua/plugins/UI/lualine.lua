-- lua/plugins/UI/lualine.lua
local colors = require("onedarkpro.helpers").get_colors()
local icons = require("config.icons")

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = {
    options = {
      theme = "onedark",
      globalstatus = true,
      component_separators = "",
      section_separators = { left = "", right = "" },
      disabled_filetypes = { statusline = { "alpha", "neo-tree" } },
    },
    sections = {
      lualine_a = {
        {
          "mode",
          icon = icons.misc.vim,
          separator = { left = "", right = "" },
          color = { bg = colors.blue, fg = colors.bg },
        },
      },
      lualine_b = {
        { "branch", icon = icons.misc.branch },
      },
      lualine_c = {
        { "filename" },
        {
          function()
            local clients = vim.lsp.get_clients({ bufnr = 0 })
            if #clients == 0 then return "" end
            return table.concat(vim.tbl_map(function(client) return client.name end, clients), ", ")
          end,
          icon = "",
          color = { fg = colors.purple },
        },
      },
      lualine_x = {
        {
          "diff",
          symbols = { added = icons.git.added .. " ", modified = icons.git.modified .. " ", removed = icons.git.removed .. " " },
          padding = { left = 1, right = 1 },
          diff_color = {
            added = { fg = colors.green },
            modified = { fg = colors.yellow },
            removed = { fg = colors.red },
          },
          source = function()
            local gitsigns = vim.b.gitsigns_status_dict
            if gitsigns then
              return {
                added = gitsigns.added,
                modified = gitsigns.changed,
                removed = gitsigns.removed,
              }
            end
          end,
        },
        { "diagnostics", symbols = icons.diagnostics },
      },
      lualine_y = { "filetype" },
      lualine_z = {
        {
          "location",
          separator = { left = "", right = "" },
          color = { bg = colors.green, fg = colors.bg },
        },
      },
    },
    extensions = { "neo-tree" },
  },
}
