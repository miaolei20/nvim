local M = {}

-- 颜色定义（直接使用硬编码颜色，避免调色板依赖）
local colors = {
  bg = "#282C34",
  mode = {
    n = "#61AFEF",  -- Normal
    i = "#98C379",  -- Insert
    v = "#E5C07B",  -- Visual
    c = "#E06C75",  -- Command
    V = "#E5C07B",  -- Visual Line
    [""] = "#E5C07B" -- Visual Block
  },
  white = "#ABB2BF",
  cyan = "#56B6C2",
  blue = "#61AFEF",
  green = "#98C379",
  yellow = "#E5C07B",
  red = "#E06C75"
}

-- 图标定义
local icons = {
  mode = " ",
  branch = " ",
  file = " ",
  clock = " ",
  unix = " ",
  windows = " ",
  mac = " ",
  diagnostics = { Error = " ", Warn = " ", Info = " " },
  git = { added = " ", modified = " ", removed = " " }
}

-- 组件生成辅助函数
local function component(name, opts)
  return vim.tbl_extend("force", {
    name,
    padding = { left = 1, right = 1 },
    colored = false
  }, opts or {})
end

function M.setup()
  vim.opt.laststatus = 3
  vim.opt.showmode = false

  require("lualine").setup({
    options = {
      theme = "onedark",
      globalstatus = true,
      component_separators = "",
      section_separators = "",
      disabled_filetypes = { "alpha", "dashboard", "NvimTree", "neo-tree", "TelescopePrompt" },
      refresh = { statusline = 200 } -- 优化刷新间隔
    },

    sections = {
      lualine_a = {
        component("mode", {
          icon = icons.mode,
          color = function()
            local mode = vim.fn.mode()
            return { fg = colors.bg, bg = colors.mode[mode] or colors.mode.n, gui = "bold" }
          end
        })
      },
      lualine_b = {
        component("branch", {
          icon = icons.branch,
          color = { fg = colors.white }
        })
      },
      lualine_c = {
        component("diagnostics", {
          symbols = icons.diagnostics,
          update_in_insert = false -- 减少插入模式刷新
        })
      },
      lualine_x = {
        component(require("lazy.status").updates, {
          cond = require("lazy.status").has_updates,
          color = { fg = colors.cyan }
        }),
        component("diff", {
          symbols = icons.git,
          source = function()
            return vim.b.gitsigns_status_dict or {}
          end,
          diff_color = {
            added = { fg = colors.green },
            modified = { fg = colors.yellow },
            removed = { fg = colors.red }
          }
        })
      },
      lualine_y = {
        component("encoding", {
          fmt = function() return icons.file .. " " .. vim.bo.fenc:upper() end,
          color = { fg = colors.blue }
        }),
        component("fileformat", {
          symbols = { unix = icons.unix, dos = icons.windows, mac = icons.mac },
          color = { fg = colors.blue }
        }),
        component("progress", {
          fmt = function() return " %p%%" end,
          color = { fg = colors.cyan }
        }),
        component("location", { padding = { right = 1 } })
      },
      lualine_z = {
        component("datetime", {
          fmt = function() return icons.clock .. os.date("%H:%M") end,
          color = { fg = colors.black }
        })
      }
    },

    extensions = { "neo-tree", "toggleterm" }
  })

  -- 状态栏切换快捷键
  vim.keymap.set("n", "<C-l>", function()
    vim.opt.laststatus = vim.opt.laststatus:get() == 3 and 0 or 3
    vim.notify("状态栏: " .. (vim.opt.laststatus:get() == 3 and "显示" or "隐藏"))
  end, { desc = "切换状态栏显示" })

  -- 自动命令优化
  vim.api.nvim_create_autocmd({ "WinNew", "BufEnter" }, {
    callback = function()
      vim.opt.laststatus = 3
      vim.cmd.redrawstatus()
    end
  })
end

return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-web-devicons" },
    config = M.setup
  }
}