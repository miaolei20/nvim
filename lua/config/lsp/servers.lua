local M = {}

M.lua_ls = {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim" } },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = { enable = false },
      format = {
        enable = true,
        defaultConfig = {
          indent_style = "space",
          indent_size = "2",
          quote_style = "auto",
        },
      },
    },
  },
}

M.clangd = {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=never",
    "--completion-style=detailed",
  },
  filetypes = { "c", "cpp", "objc", "objcpp" },
  capabilities = {
    offsetEncoding = "utf-8",
    textDocument = {
      completion = {
        editsNearCursor = true,
      },
    },
  },
}

M.pyright = {
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace",
      },
      formatting = {
        provider = "black",
        args = { "--line-length", "120", "--quiet" },
      },
    },
  },
}

return M
