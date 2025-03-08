local M = {}

function M.setup()
  vim.opt.laststatus = 3 -- 全局状态栏
  vim.opt.showmode = false -- 隐藏默认模式提示

  -- 主题 & 颜色
  local palette = require("onedark.palette").dark
  local colors = {
    bg       = palette.bg,
    fg       = palette.fg,
    blue     = palette.blue,
    green    = palette.green,
    yellow   = palette.yellow,
    red      = palette.red,
    cyan     = palette.cyan,
    grey     = palette.grey,
    white    = palette.white,
  }

  -- 图标
  local icons = {
    mode        = " ",
    branch      = " ",
    diagnostics = { Error = " ", Warn = " ", Info = " ", Hint = "󰛨 " },
    git         = { added = " ", modified = " ", removed = " " },
    misc        = { clock = " ", file = " ", unix = " ", windows = " ", mac = " " },
  }

  -- 模式颜色
  local mode_colors = {
    n    = colors.blue,
    i    = colors.green,
    v    = colors.yellow,
    V    = colors.yellow,
    [""] = colors.yellow,
    c    = colors.red,
  }

  local function get_mode_color()
    return { fg = colors.bg, bg = mode_colors[vim.fn.mode()] or colors.blue, gui = "bold" }
  end

  -- 状态栏切换快捷键
  vim.keymap.set("n", "<leader>lt", function()
    vim.opt.laststatus = vim.opt.laststatus:get() == 3 and 0 or 3
    vim.notify("状态栏: " .. (vim.opt.laststatus:get() == 3 and "显示" or "隐藏"))
  end, { desc = "切换状态栏显示" })

  require("lualine").setup({
    options = {
      theme = "onedark",
      globalstatus = true,
      component_separators = "",
      section_separators   = "",
      disabled_filetypes   = { "alpha", "dashboard", "NvimTree", "neo-tree", "TelescopePrompt", "spectre_panel" },
      refresh = { statusline = 100 },
    },
    sections = {
      lualine_a = {
        {
          "mode",
          icon = icons.mode,
          color = get_mode_color,
          padding = { left = 1, right = 1 },
        },
      },
      lualine_b = {
        {
          "branch",
          icon = icons.branch,
          color = { fg = colors.white },
          padding = { left = 1, right = 1 },
        },
      },
      lualine_c = {
        {
          "diagnostics",
          symbols = icons.diagnostics,
          colored = true,
          update_in_insert = false,
          padding = { left = 1 },
        },
      },
      lualine_x = {
        {
          require("lazy.status").updates,
          cond = require("lazy.status").has_updates,
          color = { fg = colors.cyan },
        },
        {
          "diff",
          symbols = icons.git,
          source = function()
            local gitsigns = vim.b.gitsigns_status_dict
            return gitsigns and {
              added    = gitsigns.added,
              modified = gitsigns.changed,
              removed  = gitsigns.removed,
            }
          end,
          colored = false,
          diff_color = {
            added    = { fg = colors.green },
            modified = { fg = colors.yellow },
            removed  = { fg = colors.red },
          },
          padding = { left = 1, right = 1 },
        },
      },
      lualine_y = {
        {
          "encoding",
          fmt = function(str) return icons.misc.file .. " " .. str:upper() end,
          color = { fg = colors.blue },
        },
        {
          "fileformat",
          symbols = { unix = icons.misc.unix, dos = icons.misc.windows, mac = icons.misc.mac },
          colored = true,
          color = { fg = colors.blue },
          padding = { left = 1 },
        },
        {
          "progress",
          fmt = function() return " %p%%" end,
          color = { fg = colors.cyan },
        },
        { "location", padding = { left = 0, right = 1 } },
      },
      lualine_z = {
        {
          "datetime",
          style = "default",
          fmt = function() return icons.misc.clock .. os.date("%H:%M") end,
          color = { fg = colors.white },
          padding = { left = 1, right = 1 },
        },
      },
    },
    extensions = { "neo-tree", "toggleterm" },
  })

  -- 自动保持全局状态栏
  vim.api.nvim_create_autocmd({ "WinNew", "WinClosed", "BufWinEnter" }, {
    callback = function()
      vim.schedule(function()
        vim.opt.laststatus = 3
        vim.cmd("redrawstatus!")
      end)
    end,
  })
end

return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-web-devicons" },
    config = M.setup,
  },
}
