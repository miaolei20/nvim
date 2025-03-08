local M = {}

-- 获取调色板配置：优先使用 onedark 调色板，否则回退到默认配置
local function get_palette()
  local default_palette = {
    base = {
      bg     = "#282c34",
      grey   = "#5c6370",
      blue   = "#61afef",
      cyan   = "#56b6c2",
      green  = "#98c379",
      yellow = "#e5c07b",
    },
    extended = {
      indent = {
        level1 = "#3a3f4b",  -- 深灰蓝
        level2 = "#4a505d",  -- 中灰蓝
        level3 = "#5a6170",  -- 浅灰蓝
        level4 = "#6a7282",  -- 亮灰蓝
      },
      bg2   = "#21252b",
      bg3   = "#181a1f",
      grey2 = "#7f848e",
    },
  }

  local ok, onedark_palette = pcall(require, "onedark.palette")
  if ok and type(onedark_palette.dark) == "table" then
    return vim.tbl_deep_extend("keep", onedark_palette.dark, default_palette)
  else
    return default_palette
  end
end

-- 生成现代风格缩进样式：利用不同透明度让缩进线更柔和
local function generate_modern_indent_styles(palette)
  local blends = { 30, 25, 20, 15 }
  local styles = {}
  for i, blend in ipairs(blends) do
    styles[i] = { fg = palette.extended.indent["level" .. i], bg = "NONE", blend = blend }
  end
  return styles
end

function M.setup()
  -- 禁用 "no parser for xxx" 消息，避免无关提示打扰
  vim.schedule(function()
    vim.notify = function(msg, ...)
      if msg:match("no parser for") then
        return
      end
      return require("notify")(msg, ...)
    end
  end)

  local palette = get_palette()
  local opts = {
    indent = {
      enable         = true,
      chars          = { "▏" },
      style          = generate_modern_indent_styles(palette),
      use_treesitter = true,
      exclude_filetypes = { "help", "dashboard", "NvimTree", "TelescopePrompt" },
      priority       = 95,
    },
    line_num = {
      enable         = true,
      right_align    = true,
      use_treesitter = true,
      custom_match   = function()
        local is_relative = vim.wo.relativenumber
        local base_color = is_relative and palette.extended.grey2 or palette.base.grey

        vim.api.nvim_set_hl(0, "CursorLineNr", { fg = palette.base.blue, bold = true, italic = true })
        vim.api.nvim_set_hl(0, "LineNr",       { fg = base_color })
        vim.api.nvim_set_hl(0, "LineNrAbove",  { fg = base_color, italic = true })
        vim.api.nvim_set_hl(0, "LineNrBelow",  { fg = base_color, italic = true })
      end,
    },
    chunk = {
      enable = true,
      -- 统一背景设置为编辑器背景，避免突出显示
      style  = {
        { fg = palette.base.cyan,  bg = palette.base.bg },
        { fg = palette.base.green, bg = palette.base.bg },
        { fg = palette.base.yellow, bg = palette.base.bg },
      },
      textobject        = "]]",
      support_filetypes = { "*" },
      notify            = true,
    },
    blank = {
      enable = false,
      chars  = { "" },
      style  = { fg = palette.extended.grey2 },
    },
    ui = {
      border       = "rounded",
      winblend     = 30,         -- 增加透明度，让 UI 更柔和
      hl_normal    = "NormalFloat",
      col_increase = 15,
    },
  }

  require("hlchunk").setup(opts)

  -- 通过自动命令更新每个缩进层级的透明度，确保显示柔和
  vim.api.nvim_create_autocmd("WinEnter", {
    callback = function()
      local blends = { 30, 25, 20, 15 }
      for i, blend in ipairs(blends) do
        vim.api.nvim_set_hl(0, "HLIndent" .. i, { blend = blend })
      end
    end,
  })
end

return {
  {
    "shellRaining/hlchunk.nvim",
    event = "VeryLazy",
    config = M.setup,
  },
}
