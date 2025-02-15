local M = {}

function M.setup()
  local dap = require("dap")

  -- 自定义调试图标 (移除 LazyVim 依赖)
  vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "DiagnosticError", linehl = "", numhl = "" })
  vim.fn.sign_define("DapStopped", { text = "👉", texthl = "DiagnosticWarn", linehl = "Visual", numhl = "DiagnosticWarn" })

  -- 基本快捷键
  vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
  vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Start/Continue" })
  vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step Into" })
  vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Step Over" })
  vim.keymap.set("n", "<leader>dq", dap.terminate, { desc = "Terminate" })

  -- 高亮配置
  vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
end

return M
