return {
  {
    "echasnovski/mini.indentscope",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      -- 调色板配置（保持与原有逻辑一致）
      local get_palette = function()
        local default = {
          base = {
            bg = "#282c34",
            grey = "#5c6370",
            blue = "#61afef",
          },
          extended = {
            indent = {
              level1 = "#3a3f4b",
              level2 = "#4a505d", 
              level3 = "#5a6170",
              level4 = "#6a7282",
            }
          }
        }

        local ok, onedark = pcall(require, "onedark.palette")
        return ok and vim.tbl_deep_extend("force", default, onedark.dark) or default
      end

      -- 现代缩进线样式生成
      local palette = get_palette()
      local blends = { 30, 25, 20, 15 }
      local styles = {}
      for i = 1, 4 do
        styles[i] = {
          fg = palette.extended.indent["level"..i],
          blend = blends[i],
          -- 使用 Unicode 符号组合创建更精细的缩进线
          symbol = (i % 2 == 0) and "▏" or "│"
        }
      end

      -- 核心配置
      require("mini.indentscope").setup({
        draw = {
          animation = function()
            return 20 -- 微妙的入场动画
          end
        },
        mappings = {
          object_scope = "ii",
          object_scope_with_border = "ai"
        },
        options = {
          border = "both", -- 同时显示上下边界
          try_as_border = true
        },
        symbol = "▏",
        style = styles, -- 应用分层样式
        
        -- 排除文件类型
        exclude = {
          filetypes = {
            "help", "dashboard", "NvimTree", "TelescopePrompt",
            "lspinfo", "checkhealth", "man"
          }
        }
      })

      -- 动态透明度更新（优化版）
      vim.api.nvim_create_autocmd({ "WinEnter", "ColorScheme" }, {
        callback = function()
          for i = 1, 4 do
            vim.api.nvim_set_hl(0, "MiniIndentscopeLevel"..i, {
              fg = palette.extended.indent["level"..i],
              blend = blends[i]
            })
          end
        end
      })

      -- 高级样式覆盖
      vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", {
        fg = palette.base.blue,
        bold = true,
        nocombine = true
      })
    end
  }
}