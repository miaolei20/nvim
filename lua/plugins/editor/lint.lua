return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufWritePost" }, -- Lazy-load on save
    dependencies = { "williamboman/mason.nvim" }, -- Ensure Mason is available
    config = function()
      local lint = require("lint")

      -- Use Neovim diagnostics API
      vim.g.lint_use_diagnostics = true

      -- Configure linters by filetype, using Mason-installed tools
      lint.linters_by_ft = {
        c = { "cpplint" },
        cpp = { "cpplint" },
        python = { "flake8" },
      }

      -- Customize linter arguments (optional)
      lint.linters.cpplint.args = {
        "--filter=-legal/copyright,-build/include_order", -- Ignore specific checks
        "--linelength=120", -- Allow longer lines for STM32 code
      }
      lint.linters.flake8.args = {
        "--max-line-length=88", -- PEP 8 standard
        "--ignore=E203,W503", -- Ignore specific errors
      }

      -- Ensure Mason-installed linters are in PATH
      local mason_registry = require("mason-registry")
      local function get_mason_bin(name)
        local package = mason_registry.get_package(name)
        if package:is_installed() then
          return package:get_install_path() .. "/bin/" .. name
        end
        return name -- Fallback to system binary
      end
      lint.linters.cpplint.cmd = get_mason_bin("cpplint")
      lint.linters.flake8.cmd = get_mason_bin("flake8")

      -- Trigger linting on save
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}