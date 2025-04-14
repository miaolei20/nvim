return {
  -- Render Markdown Configuration
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",  -- Triggers plugin for markdown filetypes
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons"
    },
    opts = {
      performance = {
        debounce = 300,
        max_workers = 2,
        incremental_update = true,
      },
      rendering = {
        syntax_highlight = true,
        code_blocks = true,
        disable = { folds = true },
      },
      styles = {
        border = "none",
        padding = { 1, 2 },
        wrap = true,
        transparency = 0.95,
      },
    },
    config = function(_, opts)
      require("render-markdown").setup(opts)
      vim.api.nvim_set_hl(0, "RenderMarkdownCode", { link = "Comment" })
      vim.api.nvim_set_hl(0, "RenderMarkdownHeading", { bold = true, fg = "#89B4FA" })
    end,
  },

  -- CopilotChat Configuration
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      "zbirenbaum/copilot.lua",  -- Copilot engine
      "nvim-lua/plenary.nvim"    -- Required utilities
    },
    build = "make tiktoken",     -- Build command (MacOS/Linux)
    cmd = { "CopilotChat", "CopilotChatOpen" },  -- Lazy-load on commands
    opts = {
      window = {
        width = 0.4,           -- 35% editor width
      }
    },
    config = function(_, opts)
      require("CopilotChat").setup(opts)

      -- Set markdown filetype for CopilotChat buffers
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "copilot-chat",  -- Original filetype from plugin
        callback = function(args)
          vim.bo[args.buf].filetype = "markdown"  -- Force markdown rendering
        end,
      })
    end,
  }
}
