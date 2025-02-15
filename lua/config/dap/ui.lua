local M = {}

function M.setup()
  require("dapui").setup({
    icons = { expanded = "▾", collapsed = "▸" },
    layouts = {
      {
        elements = { "scopes", "breakpoints", "stacks", "watches" },
        size = 40,
        position = "left",
      },
      { elements = { "repl" }, size = 10, position = "bottom" }
    }
  })

  -- 自动打开/关闭 UI
  local dap = require("dap")
  local dapui = require("dapui")
  dap.listeners.after.event_initialized["dapui_config"] = dapui.open
  dap.listeners.before.event_terminated["dapui_config"] = dapui.close
  dap.listeners.before.event_exited["dapui_config"] = dapui.close
end

return M
