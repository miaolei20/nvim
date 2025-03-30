return {
  "lukas-reineke/indent-blankline.nvim",
  event = "BufReadPost",
  main = "ibl",
  opts = {
    indent = {
      char = "┆",  -- VS Code 风格的细虚线字符
      highlight = { "CursorLine" },  -- 关联到光标行颜色
    },
    scope = {
      enabled = false,
      show_start = false,
      show_end = false
    },
    exclude = {
      filetypes = { "help", "dashboard", "neo-tree", "Trouble", "lazy" }
    }
  },
  config = function(_, opts)
    local colors = require("onedarkpro.helpers").get_colors()
    
    -- 使用 VS Code 风格的较深灰色
    vim.api.nvim_set_hl(0, "IblIndent", {
      fg = colors.gray or colors.comment,
      nocombine = true
    })

    -- 现代化的一站式配置
    require("ibl").setup(vim.tbl_deep_extend("force", opts, {
      indent = { highlight = "IblIndent" }
    }))

    -- 自适应颜色更新
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        local c = require("onedarkpro.helpers").get_colors()
        vim.api.nvim_set_hl(0, "IblIndent", { 
          fg = c.gray or c.comment,
          nocombine = true 
        })
      end
    })
  end
}