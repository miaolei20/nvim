return {{
  "HiPhish/rainbow-delimiters.nvim",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    local ok, rd = pcall(require, "rainbow-delimiters")
    if not ok then
      vim.notify("Failed to load rainbow-delimiters.nvim", vim.log.levels.ERROR)
      return
    end

    local selected_theme_file = vim.fn.stdpath("config") .. "/selected_theme.txt"
    local function get_current_theme()
      return vim.g.colors_name or (
        vim.fn.filereadable(selected_theme_file) == 1 and
        vim.fn.readfile(selected_theme_file)[1]:match("^colorscheme (%w[%w%-]*)$")
      ) or "onedark"
    end

    local palettes = {
      onedark = {
        red = "#e06c75", yellow = "#e5c07b", blue = "#61afef", green = "#98c379",
        cyan = "#56b6c2", purple = "#c678dd", orange = "#d19a66"
      },
      catppuccin = {
        red = "#f38ba8", yellow = "#f9e2af", blue = "#89b4fa", green = "#a6e3a1",
        cyan = "#94e2d5", purple = "#f5c2e7", orange = "#fab387"
      },
      ["catppuccin-latte"] = {
        red = "#d20f39", yellow = "#df8e1d", blue = "#1e66f5", green = "#40a02b",
        cyan = "#14b8a6", purple = "#8839ef", orange = "#e64553"
      },
      tokyonight = {
        red = "#f7768e", yellow = "#e0af68", blue = "#7aa2f7", green = "#9ece6a",
        cyan = "#7dcfff", purple = "#bb9af7", orange = "#ff9e64"
      },
      gruvbox = {
        red = "#cc241d", yellow = "#fabd2f", blue = "#458588", green = "#b8bb26",
        cyan = "#83a598", purple = "#b16286", orange = "#d65d0e"
      },
      ["rose-pine"] = {
        red = "#eb6f92", yellow = "#f6c177", blue = "#9ccfd8", green = "#31748f",
        cyan = "#c4a7e7", purple = "#c4a7e7", orange = "#f6c177"
      },
      everforest = {
        red = "#e67e80", yellow = "#dbbc7f", blue = "#7fbbb3", green = "#a7c080",
        cyan = "#83c092", purple = "#d699b6", orange = "#e69875"
      }
    }

    local function set_highlights()
      local c = palettes[get_current_theme()] or palettes.onedark
      for name, color in pairs({
        Red = c.red, Yellow = c.yellow, Blue = c.blue,
        Green = c.green, Cyan = c.cyan, Violet = c.purple, Orange = c.orange
      }) do
        vim.api.nvim_set_hl(0, "RainbowDelimiter" .. name, { fg = color })
      end
    end

    vim.api.nvim_create_autocmd("ColorScheme", { callback = set_highlights })
    set_highlights()

    vim.g.rainbow_delimiters = {
      strategy = {
        [""] = rd.strategy["global"],
        vim = rd.strategy["local"],
        lua = rd.strategy["local"],
        python = rd.strategy["local"]
      },
      query = {
        [""] = "rainbow-delimiters",
        javascript = "rainbow-parens",
        tsx = "rainbow-parens"
      },
      highlight = {
        "RainbowDelimiterRed", "RainbowDelimiterYellow", "RainbowDelimiterBlue",
        "RainbowDelimiterGreen", "RainbowDelimiterCyan", "RainbowDelimiterViolet",
        "RainbowDelimiterOrange"
      },
      blacklist = { "html" }
    }
  end
}}
