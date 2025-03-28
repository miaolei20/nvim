local M = {}

-- Color definitions
local colors = {
  bg    = "#282C34",
  black = "#000000",
  white = "#ABB2BF",
  cyan  = "#56B6C2",
  blue  = "#61AFEF",
  green = "#98C379",
  yellow= "#E5C07B",
  red   = "#E06C75",
  mode  = {
    n = "#61AFEF", -- Normal
    i = "#98C379", -- Insert
    v = "#E5C07B", -- Visual
    c = "#E06C75", -- Command
  },
}

-- Icon definitions
local icons = {
  mode        = "",
  branch      = "",
  clock       = "",
  lsp         = "",
  diagnostics = { Error = "", Warn = "", Info = "" },
  git         = { added = "", modified = "", removed = "" },
}

-- Component helper function
local function component(name, opts)
  return vim.tbl_extend("force", {
    name,
    padding = { left = 1, right = 1 }
  }, opts or {})
end

-- LSP clients display (excluding null-ls)
local function lsp_clients()
  local clients = vim.lsp.get_active_clients({ bufnr = vim.api.nvim_get_current_buf() })
  if not clients or vim.tbl_isempty(clients) then
    return icons.lsp .. " No LSP"
  end
  
  local names = {}
  for _, client in ipairs(clients) do
    if client.name ~= "null-ls" then
      table.insert(names, client.name)
    end
  end
  
  return icons.lsp .. " " .. (next(names) and table.concat(names, ", ") or "No LSP")
end

-- Setup function
M.setup = function()
  -- Global statusline settings
  vim.opt.laststatus = 3
  vim.opt.showmode = false

  require("lualine").setup({
    options = {
      theme = "onedark",
      globalstatus = true,
      component_separators = "",
      section_separators = "",
      disabled_filetypes = {
        statusline = { "alpha", "dashboard", "NvimTree", "neo-tree", "TelescopePrompt" }
      },
      refresh = { statusline = 200 },
    },
    sections = {
      lualine_a = {
        component("mode", {
          icon = icons.mode,
          color = function()
            local mode = vim.fn.mode()
            return { fg = colors.bg, bg = colors.mode[mode] or colors.mode.n, gui = "bold" }
          end,
        }),
      },
      lualine_b = {
        component("branch", {
          icon = icons.branch,
          color = { fg = colors.white }
        }),
      },
      lualine_c = {
        component("filename", {
          path = 1,
          color = { fg = colors.white }
        }),
        component("diagnostics", {
          symbols = icons.diagnostics,
          update_in_insert = false,
        }),
        { lsp_clients, color = { fg = colors.blue } },
      },
      lualine_x = {
        component("diff", {
          symbols = icons.git,
          source = function() return vim.b.gitsigns_status_dict or {} end,
          diff_color = {
            added    = { fg = colors.green },
            modified = { fg = colors.yellow },
            removed  = { fg = colors.red },
          },
        }),
      },
      lualine_y = {
        component("progress", {
          fmt = function() return " %p%%" end,
          color = { fg = colors.cyan }
        }),
      },
      lualine_z = {
        component("datetime", {
          fmt = function() return icons.clock .. " " .. os.date("%H:%M") end,
          color = { fg = colors.black },
        }),
      },
    },
    extensions = { "nvim-tree", "toggleterm" }, -- Fixed extension name
  })
end

-- Plugin configuration
return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- Updated dependency name
    config = function()
      M.setup()
    end,
  }
}