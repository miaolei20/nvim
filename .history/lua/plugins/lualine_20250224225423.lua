-- file: plugins/lualine.lua
return {
  {
    "nvim-lualine/lualine.nvim",  -- 主插件
    event = "User DashboardReady",  -- 延迟加载插件
     dependencies = {
      "nvim-web-devicons",
      "SmiteshP/nvim-navic",    -- 显式声明依赖
    },
    init = function()
      --vim.g.lualine_laststatus = vim.o.laststatus  -- 保存当前状态栏状态
      if vim.fn.argc(-1) > 0 then
        vim.o.statusline = " "  -- 如果有参数，设置空状态栏
      else
        vim.o.laststatus = 0  -- 否则隐藏状态栏
      end
    end,
    config = function()
      local colors = require("onedark.palette").dark  -- 获取配色方案
      local icons = {
        diagnostics = {
          Error = " ",  -- 错误图标
          Warn  = " ",  -- 警告图标
          Info  = " ",  -- 信息图标
          Hint  = "󰛨 ",  -- 提示图标
        },
        git = {
          added    = " ",  -- 添加图标
          modified = " ",  -- 修改图标
          removed  = " ",  -- 删除图标
        }
      }
      -- 新增导航组件模块
      local navigation = {
  navic = {
    function() return require("nvim-navic").get_location() end,
    cond = function() return require("nvim-navic").is_available() end,
    color = {
      fg = colors.cyan,         -- 前景色与主题一致
      bg = colors.bg_statusline -- 背景色与 lualine 全局背景一致（需确认你的主题色变量名）
    },
    padding = { left = 0, right = 1 }
  }
}
      -- 新增模式颜色映射表
      local mode_colors = {
        n = { bg = colors.cyan, fg = colors.black },    -- Normal
        i = { bg = colors.green, fg = colors.black },   -- Insert
        v = { bg = colors.purple, fg = colors.black },  -- Visual
        V = { bg = colors.purple, fg = colors.black },  -- Visual Line
        [''] = { bg = colors.purple, fg = colors.black }, -- Visual Block
        c = { bg = colors.orange, fg = colors.black },  -- Command
        r = { bg = colors.red, fg = colors.black },     -- Replace
        t = { bg = colors.yellow, fg = colors.black },  -- Terminal
      }

      -- 获取当前模式颜色的函数
      local function get_mode_color()
        local mode = vim.api.nvim_get_mode().mode
        return mode_colors[mode:sub(1, 1)] or mode_colors.n
      end

      -- 初始化状态栏修复
      vim.o.laststatus = vim.g.lualine_laststatus

      require("lualine").setup({
        options = {
          theme = "onedark",  -- 主题设置为 onedark
          component_separators = { left = "", right = "" },  -- 组件分隔符
          section_separators = { left = "", right = "" },  -- 区域分隔符
          globalstatus = true,  -- 全局状态栏
          disabled_filetypes = {
            statusline = { "dashboard", "alpha", "ministarter", "TelescopePrompt" }  -- 禁用状态栏的文件类型
          },
          refresh = { statusline = 150 }  -- 刷新间隔
        },
        sections = {
          lualine_a = { {
            "mode",
            icon = "",
            color = function()
              local col = get_mode_color()
              return {
                fg = col.fg,
                bg = col.bg,
                gui = "bold"
              }
            end,
            padding = { left = 1, right = 1 }
          } },
          lualine_b = {
            { 
              "branch", 
              icon = "",
              color = { fg = colors.white, bg = colors.gray },
              padding = { left = 1, right = 1 }
            }
          },
          lualine_c = {
            {
              "filename",
              path = 1,
              symbols = {
                modified = "● ",
                readonly = "",
                unnamed = "[未命名]"
              },
              color = { fg = colors.purple }
            },
             navigation.navic,  -- 新增导航路径
            {
              "diagnostics",
              symbols = icons.diagnostics,
              colored = true,
              update_in_insert = true,
              padding = { left = 1 }
            }
          },
          lualine_x = {
            -- Noice 插件集成
            function()
              return require("noice").api.status.command.get()
            end,
            function()
              return require("noice").api.status.mode.get()
            end,
            -- DAP 调试状态
            {
              function()
                return "  " .. require("dap").status()
              end,
              cond = function()
                return package.loaded["dap"] and require("dap").status() ~= ""
              end
            },
            -- Lazy 更新提示
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = { fg = colors.cyan }
            },
            -- Git diff 信息
            {
              "diff",
              symbols = icons.git,
              source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                return gitsigns and {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end,
              colored = false,
              diff_color = {
                added = { fg = colors.green },
                modified = { fg = colors.yellow },
                removed = { fg = colors.red }
              }
            }
          },
          lualine_y = {
            {
              "filetype",
              icon_only = true,
              colored = true,
              padding = { left = 1 }
            },
            {
              "encoding",
              fmt = function(str)
                return " " .. str:upper()  -- 添加编码图标
              end,
              color = { fg = colors.blue }
            },
            { 
              "fileformat", 
              symbols = {
                unix = " ",  -- Linux icon
                dos = " ",   -- Windows icon
                mac = "󰀵 "    -- macOS icon
              },
              padding = { left = 1 }
            },
            {
              "progress",
              color = { fg = colors.cyan },
              fmt = function()
                return " %p%%"
              end
            },
            { "location", padding = { left = 0, right = 1 } }
          },
          lualine_z = { {
            "datetime",
            style = "default",
            fmt = function()
              return " " .. os.date("%H:%M")
            end,
            color = { fg = colors.white },
            padding = { left = 1, right = 1 }
          } }
        },
        extensions = { 
          "neo-tree", 
          "toggleterm",
          "lazy",
          "fzf"
        }
      })

    end
  }
}