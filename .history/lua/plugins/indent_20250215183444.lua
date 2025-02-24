-- file: plugins/indent.lua
return {
  {
    "lukas-reineke/indent-blankline.nvim",  -- 主插件
    main = "ibl",  -- 主模块
    event = "BufReadPost",  -- 在缓冲区读取后加载插件
    dependencies = { "nvim-treesitter/nvim-treesitter" },  -- 依赖的插件
    config = function()
      local colors = require("onedark.palette").dark  -- 获取配色方案
      
      -- 自定义缩进线颜色 (LazyVim 风格)
      vim.api.nvim_set_hl(0, "IblIndent1", { fg = colors.bg2, nocombine = true })  -- 设置 IblIndent1 颜色
      vim.api.nvim_set_hl(0, "IblIndent2", { fg = colors.bg3, nocombine = true })  -- 设置 IblIndent2 颜色
      vim.api.nvim_set_hl(0, "IblScope", { fg = colors.cyan, nocombine = true })  -- 设置 IblScope 颜色

      require("ibl").setup({
        indent = {
          char = "▏",  -- 缩进字符
          highlight = { "IblIndent1", "IblIndent2" },  -- 多级缩进颜色
          repeat_linebreak = true  -- 重复换行符
        },
        scope = {
          show_start = false,  -- 不显示作用域开始
          show_end = false,  -- 不显示作用域结束
          highlight = "IblScope",  -- 当前作用域颜色
          injected_languages = true  -- 支持嵌入语言
        },
        exclude = {
          filetypes = {
            "help",  -- 排除帮助文件
            "dashboard",  -- 排除仪表板文件
            "neo-tree",  -- 排除 neo-tree 文件
            "Trouble",  -- 排除 Trouble 文件
            "lazy",  -- 排除 lazy 文件
            "mason"  -- 排除 mason 文件
          }
        }
      })
    end
  }
}