local M = {}

function M.setup()
  local dap = require("dap")

  -- 配置 codelldb
  dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
      command = vim.fn.stdpath("data") .. "/mason/bin/codelldb", -- 使用 Mason 安装路径
      args = { "--port", "${port}" }
    }
  }

  -- 通用 C/C++ 调试配置
  local config = {
    name = "Launch (C/C++)",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    args = function()
      local input = vim.fn.input("Program arguments: ")
      return vim.split(input, " ", { trimempty = true })
    end,
  }

  dap.configurations.cpp = { config }
  dap.configurations.c = dap.configurations.cpp
end

return M
