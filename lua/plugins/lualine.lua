-- file: plugins/lualine.lua
return {
  {
    "nvim-lualine/lualine.nvim",            -- 主插件
    event = "VeryLazy",                     -- 延迟加载插件
    dependencies = { "nvim-web-devicons" }, -- 依赖的插件
    config = function()
      -- 强制全局单一状态栏配置
      vim.opt.laststatus = 3   -- 永远显示全局状态栏
      vim.opt.showmode = false -- 禁用原生模式显示
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
      -- 添加状态栏切换快捷键
      vim.keymap.set("n", "<leader>lt", function()
        vim.opt.laststatus = vim.opt.laststatus:get() == 3 and 0 or 3
        vim.notify("状态栏: " .. (vim.opt.laststatus:get() == 3 and "显示" or "隐藏"))
      end, { desc = "切换状态栏显示" })

      require("lualine").setup({
        options = {
          theme                = "onedark",
          globalstatus         = true, -- 关键配置：全局统一状态栏
          component_separators = { left = "", right = "" },
          section_separators   = { left = "", right = "" },
          globalstatus         = true,
          disabled_filetypes   = {
            statusline = {
              "alpha", "dashboard", "NvimTree", "neo-tree",
              "toggleterm", "TelescopePrompt", "spectre_panel",
              "DressingInput", "DressingSelect", "Avante"
            }
          },
          refresh              = { statusline = 150 },
          ui                   = {
            border = "rounded", -- 统一边框样式
            winhighlight = {
              "Normal:AvanteNormal", -- 自定义高亮组
              "FloatBorder:AvanteBorder"
            }
          }
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
        extensions = { "neo-tree",
          "toggleterm",
          { -- 针对 spectre 的特殊配置
            sections = {},
            filetypes = { "spectre" },
            inactive_sections = {}
          },
          {
            sections = {},
            filetypes = { "Avante" },
            inactive_sections = {}
          }
        },
      })
      -- 强化状态栏恢复机制
      vim.api.nvim_create_autocmd("BufLeave", {
        pattern = "Avante",
        callback = function()
          vim.schedule(function()
            -- 双重保险恢复全局状态栏
            vim.opt.laststatus = 3
            vim.cmd("redrawstatus!")
          end)
        end
      })

      -- 状态栏位置锁定（防止浮动窗口影响）
      vim.api.nvim_create_autocmd({ "WinNew", "WinClosed" }, {
        callback = function()
          vim.schedule(function()
            if vim.bo.filetype ~= "Avante" then
              vim.opt.laststatus = 3
              vim.cmd("redrawstatus!")
            end
          end)
        end
      })
    end,
  },
}
