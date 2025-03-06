return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-web-devicons" },
    config = function()
      -- 固定全局状态栏和禁用原生模式显示
      vim.opt.laststatus = 3
      vim.opt.showmode = false

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

      -- 状态栏切换快捷键（可选）
      vim.keymap.set("n", "<leader>lt", function()
        local new_status = (vim.opt.laststatus:get() == 3) and 0 or 3
        vim.opt.laststatus = new_status
        vim.notify("状态栏: " .. (new_status == 3 and "显示" or "隐藏"))
      end, { desc = "切换状态栏显示" })

      require("lualine").setup({
        options = {
          theme = "onedark",
          globalstatus = true,
          component_separators = { left = "", right = "" },
          section_separators   = { left = "", right = "" },
          disabled_filetypes   = {
            statusline = {
              "alpha", "dashboard", "NvimTree", "neo-tree",
              "toggleterm", "TelescopePrompt", "spectre_panel",
              "DressingInput", "DressingSelect", "Avante"
            },
          },
          refresh = { statusline = 150 },
          ui = {
            border = "rounded",
            winhighlight = {
              "Normal:AvanteNormal",
              "FloatBorder:AvanteBorder",
            },
          },
        },
        sections = {
          lualine_a = {
            {
              "mode",
              icon = " ",
              color = function()
                local col = get_mode_color()
                return { fg = col.fg, gui = "bold" }
              end,
              padding = { left = 1, right = 1 },
            },
          },
          lualine_b = {
            {
              "branch",
              icon = " ",
              color = { fg = onedark.white },
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
            },
          },
          lualine_x = {
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = { fg = onedark.cyan },
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
                added    = { fg = onedark.green },
                modified = { fg = onedark.yellow },
                removed  = { fg = onedark.red },
              },
              padding = { left = 1, right = 1 },
            },
          },
          lualine_y = {
            {
              "encoding",
              fmt = function(str) return " " .. str:upper() end,
              color = { fg = onedark.blue },
            },
            {
              "fileformat",
              symbols = {
                unix = " ",
                dos  = " ",
                mac  = "󰀵 ",
              },
              colored = true,
              color = { fg = onedark.blue },
              padding = { left = 1 },
            },
            {
              "progress",
              fmt = function() return " %p%%" end,
              color = { fg = onedark.cyan },
            },
            { "location", padding = { left = 0, right = 1 } },
          },
          lualine_z = {
            {
              "datetime",
              style = "default",
              fmt = function() return " " .. os.date("%H:%M") end,
              color = { fg = onedark.white },
              padding = { left = 1, right = 1 },
            },
          },
        },
        extensions = {
          "neo-tree",
          "toggleterm",
          {
            filetypes = { "spectre" },
            sections = {},
            inactive_sections = {},
          },
          {
            filetypes = { "Avante" },
            sections = {},
            inactive_sections = {},
          },
        },
      })

      -- 自动命令：窗口变化时强制恢复全局状态栏设置
      vim.api.nvim_create_autocmd({ "WinNew", "WinClosed", "BufWinEnter" }, {
        callback = function()
          vim.schedule(function()
            vim.opt.laststatus = 3
            vim.cmd("redrawstatus!")
          end)
        end,
      })
    end,
  },
}
