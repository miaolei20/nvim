return {
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" }, -- 在读取或新建文件时加载
    main = "ibl",
    opts = function()
      return {
        indent = {
          char = "┆", -- VSCode 风格的细虚线
          highlight = "IblIndent", -- 使用自定义高亮组
        },
        scope = {
          enabled = false, -- 禁用范围显示，与 VSCode 一致
        },
        exclude = {
          filetypes = { "help", "dashboard", "neo-tree", "Trouble", "lazy", "terminal" }, -- 排除无关文件类型
        },
      }
    end,
    config = function(_, opts)
      local ibl = require("ibl")
      local api = vim.api

      -- 定义高亮组，模仿 VSCode 的浅灰色缩进线
      local function set_indent_highlight()
        local colors = require("onedarkpro.helpers").get_colors()
        api.nvim_set_hl(0, "IblIndent", {
          fg = colors.gray or colors.comment, -- 使用灰色或注释颜色
          nocombine = true, -- 避免颜色叠加
        })
      end

      -- 初始化高亮并设置配置
      set_indent_highlight()
      ibl.setup(opts)

      -- 自适应颜色更新（仅在必要时触发）
      api.nvim_create_autocmd("ColorScheme", {
        group = api.nvim_create_augroup("IndentBlanklineColors", { clear = true }),
        callback = set_indent_highlight,
        desc = "Update IblIndent highlight on colorscheme change",
      })
    end,
  },
}