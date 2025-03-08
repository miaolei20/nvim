return {
  {
    "navarasu/onedark.nvim",
    priority = 1000,
    lazy = false,  -- 确保主题优先加载
    init = function()
      -- 预加载终端颜色设置
      vim.g.onedark_terminal_italics = 1
      vim.g.onedark_termcolors = 256
    end,
    config = function()
      -- 安全加载 onedark 模块
      local ok, onedark = pcall(require, "onedark")
      if not ok then
        vim.notify("OneDark 主题加载失败!", vim.log.levels.ERROR)
        return
      end

      -- 定义颜色变量，便于统一管理和后续扩展
      local colors = {
        base = {
          bg     = "#282c34",
          fg     = "#abb2bf",
          red    = "#e06c75",
          green  = "#98c379",
          yellow = "#e5c07b",
          blue   = "#61afef",
          purple = "#c678dd",
          cyan   = "#56b6c2",
          grey   = "#5c6370",
        },
        extended = {
          bg2   = "#21252b",
          bg3   = "#181a1f",
          grey2 = "#7f848e",
        },
      }

      -- 核心配置
      onedark.setup({
        style = "dark",
        transparent = false,
        term_colors = true,
        ending_tildes = false,  -- 禁用行尾波浪线
        diagnostics = {
          darker = true,     -- 诊断信息使用深色背景
          undercurl = true,  -- 使用下划线风格
        },
        highlights = {
          -- 基础语法高亮增强
          Comment    = { fg = colors.base.grey, italic = true, sp = colors.base.cyan },
          Type       = { fg = colors.base.yellow, bold = true },
          Constant   = { fg = colors.base.purple },
          String     = { fg = colors.base.green },
          Number     = { fg = colors.base.purple },
          -- 界面元素适配
          BufferLineBackground     = { bg = colors.extended.bg2 },
          BufferLineBufferSelected = { bg = colors.base.bg },
          TabLineSel               = { bg = colors.base.bg, fg = colors.base.blue },
          -- 缩进线配置
          IblIndent1 = { fg = colors.extended.bg2 },
          IblIndent2 = { fg = colors.extended.bg3 },
          IblScope   = { fg = colors.base.cyan, nocombine = true },
          -- 高级语法增强
          ["@function.builtin"] = { fg = colors.base.cyan },
          ["@parameter"]        = { fg = colors.base.fg, italic = true },
          ["@field"]            = { fg = colors.base.green },
          ["@property"]         = { fg = colors.base.cyan },
          -- 匹配括号优化
          MatchParen = {
            bg = colors.extended.bg2,
            underline = true,
            sp = colors.base.cyan,
          },
          -- LSP 诊断优化
          DiagnosticUnderlineError = { undercurl = true, sp = colors.base.red },
          DiagnosticUnderlineWarn  = { undercurl = true, sp = colors.base.yellow },
          DiagnosticUnderlineInfo  = { undercurl = true, sp = colors.base.blue },
        },
        -- 代码折叠及风格设置
        code_style = {
          comments  = "italic",
          keywords  = "bold",
          functions = "bold,italic",
          strings   = "none",
          variables = "none",
        },
      })

      -- 应用主题，若加载失败则发出提示
      local load_ok, err = pcall(onedark.load)
      if not load_ok then
        vim.notify("OneDark 主题应用失败: " .. err, vim.log.levels.ERROR)
        return
      end

      -- 后期调色：自动调整浮动窗口背景及搜索高亮
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "onedark",
        callback = function()
          vim.api.nvim_set_hl(0, "NormalFloat", { bg = colors.extended.bg2 })
          vim.api.nvim_set_hl(0, "IncSearch", { bg = colors.base.yellow, fg = colors.base.bg })
        end,
      })
    end,
  },
}
