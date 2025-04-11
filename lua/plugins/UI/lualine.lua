local colors = require("onedarkpro.helpers").get_colors()
local icons = require("config.icons")

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  config = function()
    -- Set up autocommand for LSP clients to cache results
    vim.api.nvim_create_autocmd({ "LspAttach", "LspDetach" }, {
      callback = function(args)
        local bufnr = args.buf
        local clients = vim.lsp.get_clients({ bufnr = bufnr })
        if #clients == 0 then
          pcall(vim.api.nvim_buf_set_var, bufnr, "lsp_clients", "")
        else
          local client_names = table.concat(vim.tbl_map(function(client) return client.name end, clients), ", ")
          pcall(vim.api.nvim_buf_set_var, bufnr, "lsp_clients", client_names)
        end
      end,
    })

    require('lualine').setup {
      options = {
        theme = "onedark",
        globalstatus = true,
        component_separators = "",
        section_separators = { left = "", right = "" },
        disabled_filetypes = { statusline = { "alpha", "neo-tree" }, winbar = {}, inactive_winbar = {} },
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
              return vim.b.lsp_clients or ""
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
      tabline = {
        lualine_a = {
          {
            'buffers',
            show_filename_only = true,
            hide_filename_extension = false,
            show_modified_status = true,
            mode = 2, -- Show buffer number and name
            max_length = vim.o.columns * 2 / 3,
            symbols = {
              modified = ' [+]',      -- Modified status
              alternate_file = '#', -- Alternate file
              directory =  '',     -- Directory
            },
            buffers_color = {
              active = { bg = colors.blue, fg = colors.bg },
              inactive = { bg = colors.bg, fg = colors.fg },
            },
          }
        },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { 'tabs' }
      },
      extensions = { "neo-tree" },
    }
  end,
}