-- file: plugins/scrollbar.lua

return {
  {
    "petertriho/nvim-scrollbar",
    event = "BufReadPost",
    dependencies = { "navarasu/onedark.nvim","kevinhwang91/nvim-hlslens" }, -- 明确声明主题依赖
    config = function()
      -- 安全获取主题颜色
      local ok, onedark = pcall(require, "onedark")
      if not ok then
        vim.notify("未找到 onedark 主题!", vim.log.levels.WARN)
        return
      end

      -- 使用主题原始配色方案
      local colors = {
        grey = "#5c6370",
        red = "#e06c75",
        yellow = "#e5c07b",
        blue = "#61afef",
        cyan = "#56b6c2",
        purple = "#c678dd"
      }

      ---------------------------
      -- 核心配置
      ---------------------------
      require("scrollbar").setup({
        handle = {
          color = colors.grey,
          blend = 50,         -- 正确使用 blend 控制透明度
          symbol = "▏",
          hide_if_all_visible = true
        },
        marks = {
          Error = { color = colors.red, symbol = "●" },
          Warn = { color = colors.yellow, symbol = "◆" },
          Info = { color = colors.blue, symbol = "■" },
          Hint = { color = colors.cyan, symbol = "▲" },
          Search = { color = colors.purple, symbol = "◈" }
        },
        excluded_filetypes = {
          "NvimTree", "TelescopePrompt",
          "alpha", "dashboard", "lazy"
        },
        handlers = {
          diagnostic = true,
          search = true,
          gitsigns = true -- 暂时禁用需要额外插件的功能
        }
      })

      ---------------------------
      -- 高亮组安全配置
      ---------------------------
      vim.api.nvim_set_hl(0, "ScrollbarHandle", {
  bg = colors.grey,  -- 与 handle.color 保持一致
  -- bg = colors.blue, -- 或使用主题蓝色
  -- bg = colors.cyan, -- 或使用主题青色
  blend = 30,
  nocombine = true
})
    end
  }
}
