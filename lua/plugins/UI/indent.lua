return {
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" }, -- 延迟加载
    main = "ibl",
    opts = {
      indent = {
        char = "┆", -- VSCode 风格细虚线
        highlight = "IblIndent",
      },
      scope = { enabled = false }, -- 禁用范围显示，模仿 VSCode
      exclude = {
        filetypes = { "help", "dashboard", "neo-tree", "Trouble", "lazy", "terminal" },
      },
    },
    config = function(_, opts)
      -- 定义高亮组，模仿 VSCode 浅灰色缩进线
      local set_highlight = function()
        local colors = vim.api.nvim_get_hl(0, { name = "Comment" }) -- 默认使用 Comment 颜色
        vim.api.nvim_set_hl(0, "IblIndent", {
          fg = colors.fg or "#4B5263", -- 回退到 VSCode 常见灰色
          nocombine = true,
        })
      end

      set_highlight()
      require("ibl").setup(opts)

      -- 主题切换时更新高亮
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("IndentBlanklineColors", { clear = true }),
        callback = set_highlight,
        desc = "Update indent highlight",
      })
    end,
  },
}
