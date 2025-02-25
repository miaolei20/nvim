-- file: plugins/lualine.lua
return {
  {
    "nvim-lualine/lualine.nvim", -- 主插件
    event = "VeryLazy",          -- 延迟加载插件
    dependencies = { "nvim-web-devicons" },
    config = function()
      local onedark = require("onedark.palette").dark

      local icons = {
        diagnostics = {
          Error = " ",
          Warn  = " ",
          Info  = " ",
          Hint  = "󰛨 ",
        },
        git = {
          added    = " ",
          modified = " ",
          removed  = " ",
        },
      }

      -- 各种模式下的前景色（全部使用黑色）
      local mode_colors = {
        n = { fg = onedark.black },
        i = { fg = onedark.black },
        v = { fg = onedark.black },
        V = { fg = onedark.black },
        [''] = { fg = onedark.black },
        c = { fg = onedark.black },
      }

      local function get_mode_color()
        local mode = vim.api.nvim_get_mode().mode:sub(1, 1)
        return mode_colors[mode] or mode_colors.n
      end

      -- 保持状态栏设置一致
      vim.o.laststatus = vim.g.lualine_laststatus

      require("lualine").setup({
        options = {
          theme                = "onedark",
          component_separators = { left = "", right = "" },
          section_separators   = { left = "", right = "" },
          globalstatus         = true,
          disabled_filetypes   = {
            statusline = { "dashboard", "alpha", "ministarter", "TelescopePrompt", "NvimTree" },
          },
          refresh              = { statusline = 150 },
        },
        sections = {
          lualine_a = {
            {
              "mode",
              icon = " ",
              color = function()
                local col = get_mode_color()
                return { fg = col.fg, bg = nil, gui = "bold" }
              end,
              padding = { left = 1, right = 1 },
            },
          },
          lualine_b = {
            {
              "branch",
              icon = " ",
              color = { fg = onedark.white, bg = nil },
              padding = { left = 1, right = 1 },
            },
          },
          lualine_c = {
            {
              "diagnostics",
              symbols = icons.diagnostics,
              colored = true,
              update_in_insert = true,
              padding = { left = 1 },
              color = { bg = nil },
            },
          },
          lualine_x = {
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = { fg = onedark.cyan, bg = nil },
            },
            {
              "diff",
              symbols = icons.git,
              source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                return gitsigns and {
                  added    = gitsigns.added,
                  modified = gitsigns.changed,
                  removed  = gitsigns.removed,
                }
              end,
              colored = false,
              diff_color = {
                added    = { fg = onedark.green, bg = nil },
                modified = { fg = onedark.yellow, bg = nil },
                removed  = { fg = onedark.red, bg = nil },
              },
              padding = { left = 1, right = 1 },
            },
          },
          lualine_y = {
            {
              "encoding",
              fmt = function(str) return " " .. str:upper() end,
              color = { fg = onedark.blue, bg = nil },
            },
            {
              "fileformat",
              symbols = {
                unix = " ",
                dos  = " ",
                mac  = "󰀵 ",
              },
              colored = true,
              color = { fg = onedark.blue, bg = nil },
              padding = { left = 1 },
            },
            {
              "progress",
              fmt = function() return " %p%%" end,
              color = { fg = onedark.cyan, bg = nil },
            },
            { "location", padding = { left = 0, right = 1 }, color = { bg = nil } },
          },
          lualine_z = {
            {
              "datetime",
              style = "default",
              fmt = function() return " " .. os.date("%H:%M") end,
              color = { fg = onedark.white, bg = nil },
              padding = { left = 1, right = 1 },
            },
          },
        },
        extensions = { "neo-tree", "toggleterm", "lazy", "fzf", "nvim-tree" },
      })
    end,
  },
}
