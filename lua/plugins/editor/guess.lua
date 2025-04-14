return {
  {
    "NMAC427/guess-indent.nvim",
    event = { "BufReadPost", "BufNewFile" }, -- Load on file open or creation
    opts = {
      auto_cmd = false, -- Disable built-in autocmds
      override_editorconfig = false, -- Respect .editorconfig if present
      filetype_exclude = {
        "netrw",
        "tutor",
        "alpha",
        "dashboard",
        "lazy",
        "mason",
        "help",
        "qf",
        "terminal",
      }, -- Skip non-code buffers
      buftype_exclude = {
        "help",
        "nofile",
        "terminal",
        "prompt",
      }, -- Skip special buffers
    },
    config = function(_, opts)
      local guess = require("guess-indent")
      guess.setup(opts)

      -- Autocmd for existing files
      vim.api.nvim_create_autocmd("BufReadPost", {
        group = vim.api.nvim_create_augroup("GuessIndent", { clear = true }),
        desc = "Guess indentation when loading a file",
        callback = function(args)
          guess.set_from_buffer(args.buf, true, true) -- Apply and silent
        end,
      })

      -- Autocmd for new files
      vim.api.nvim_create_autocmd("BufNewFile", {
        group = vim.api.nvim_create_augroup("GuessIndent", { clear = true }),
        desc = "Guess indentation when saving a new file",
        callback = function(args)
          vim.api.nvim_create_autocmd("BufWritePost", {
            buffer = args.buf,
            once = true, -- Run only once per buffer
            desc = "Guess indentation on first save",
            callback = function(wargs)
              guess.set_from_buffer(wargs.buf, true, true)
            end,
          })
        end,
      })
    end,
    -- Optional Which-Key integration
    init = function()
      local wk = require("which-key")
      wk.add({
        { "<leader>c", group = "Code", icon = "󰅱" }, -- Ensure Code group exists
        {
          "<leader>ci",
          "<cmd>GuessIndent<CR>",
          desc = "Guess Indent",
          icon = "󰌶",
          mode = "n",
        },
      })
    end,
  },
}
