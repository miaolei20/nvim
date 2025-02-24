-- file: plugins/spectre.lua
return {
  {
    "nvim-pack/nvim-spectre",
    keys = { "<leader>S" }, -- 主快捷键
    config = function()
      local colors = require("onedark.palette").dark

      require("spectre").setup({
        color_devicons = true,
        highlight = {
          ui = "String",
          search = "DiffAdd",
          replace = "DiffDelete"
        },
        mapping = {
          ["toggle_line"] = { map = "dd" }, -- 切换整行匹配
          ["enter_file"] = { map = "<cr>" }, -- 打开文件
        },
        replace_engine = { -- 支持 sed/perl 模式
          sed = { cmd = "sed" },
          perl = { cmd = "perl" }
        },
        theme = {
          winblend = 10, -- 窗口透明度
          border = "rounded", -- 圆角边框
          search = { fg = colors.fg, bg = colors.bg1 }, -- 搜索框颜色
          replace = { fg = colors.red, bg = colors.bg1 } -- 替换框颜色
        }
      })

      -- 快捷键配置
      vim.keymap.set("n", "<leader>S", function()
        require("spectre").open()
      end, { desc = "Open Spectre" })
    end
  }
}
