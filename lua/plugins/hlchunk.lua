-- file: plugins/hlchunk.lua
local M = {}

-- 现代风格颜色配置系统
local function get_palette()
  local default_palette = {
    base = {
      bg = "#282c34",
      grey = "#5c6370",
      blue = "#61afef",
      cyan = "#56b6c2",
      green = "#98c379",
      yellow = "#e5c07b"
    },
    extended = {
      -- 新增现代化缩进专用颜色
      indent = {
        level1 = "#3a3f4b",  -- 深灰蓝
        level2 = "#4a505d",  -- 中灰蓝
        level3 = "#5a6170",  -- 浅灰蓝
        level4 = "#6a7282"   -- 亮灰蓝
      },
      -- 保留原有扩展颜色
      bg2 = "#21252b",
      bg3 = "#181a1f",
      grey2 = "#7f848e"
    }
  }

  local ok, onedark_palette = pcall(require, "onedark.palette")
  if not ok or type(onedark_palette.dark) ~= "table" then
    return default_palette
  end

  -- 深度合并时保护缩进颜色配置
  return vim.tbl_deep_extend("keep", onedark_palette.dark, default_palette)
end

-- 现代层级缩进生成器
local function generate_modern_indent_styles(palette)
  return {
    { fg = palette.extended.indent.level1, bg = "NONE", blend = 30 },  -- 一级
    { fg = palette.extended.indent.level2, bg = "NONE", blend = 25 },  -- 二级
    { fg = palette.extended.indent.level3, bg = "NONE", blend = 20 },  -- 三级
    { fg = palette.extended.indent.level4, bg = "NONE", blend = 15 }   -- 四级
  }
end

-- 核心配置
function M.setup()
  local palette = get_palette()
  
  require("hlchunk").setup({
    indent = {
      enable = true,
      chars = { "▏" },  -- 保持细线字符
      style = generate_modern_indent_styles(palette),
      use_treesitter = true,
      exclude_filetypes = { "help", "dashboard", "NvimTree", "TelescopePrompt" },
      priority = 95     -- 提高渲染优先级
    },

    line_num = {
      enable = true,
      right_align = true,
      use_treesitter = true,
      custom_match = function()
        local is_relative = vim.wo.relativenumber
        local base_color = is_relative and palette.extended.grey2 or palette.base.grey
        
        vim.api.nvim_set_hl(0, "CursorLineNr", {
          fg = palette.base.blue,
          bold = true,
          italic = true
        })

        vim.api.nvim_set_hl(0, "LineNr", { fg = base_color })
        vim.api.nvim_set_hl(0, "LineNrAbove", { fg = base_color, italic = true })
        vim.api.nvim_set_hl(0, "LineNrBelow", { fg = base_color, italic = true })
      end
    },

    chunk = {
      enable = true,
      style = {
        { fg = palette.base.cyan, bg = palette.extended.bg2 },
        { fg = palette.base.green, bg = palette.extended.bg3 },
        { fg = palette.base.yellow, bg = palette.base.grey }
      },
      textobject = "]]",
      support_filetypes = { "*" },
      notify = true
    },

    blank = {
      enable = false,
      chars = { "" },
      style = { fg = palette.extended.grey2 }
    },

    ui = {
      border = "rounded",
      winblend = 20,
      hl_normal = "NormalFloat",
      col_increase = 15
    }
  })

  -- 增强视觉效果：缩进线透明度动画
  vim.api.nvim_create_autocmd("WinEnter", {
    callback = function()
      vim.api.nvim_set_hl(0, "HLIndent1", { blend = 30 })
      vim.api.nvim_set_hl(0, "HLIndent2", { blend = 25 })
      vim.api.nvim_set_hl(0, "HLIndent3", { blend = 20 })
      vim.api.nvim_set_hl(0, "HLIndent4", { blend = 15 })
    end
  })

end

-- 主题响应式配置
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("ModernIndentReload", {}),
  callback = function()
    package.loaded["hlchunk"] = nil
    vim.defer_fn(M.setup, 50)
  end
})

return {
  {
    "shellRaining/hlchunk.nvim",
    event = "VeryLazy",
    config = M.setup
  }
}
