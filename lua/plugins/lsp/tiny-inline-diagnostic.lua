return {
    {
      "rachartier/tiny-inline-diagnostic.nvim",
      event = "LspAttach",
      config = function()
        require("tiny-inline-diagnostic").setup({
          -- 基础配置
          virtual_text = true,
          virtual_lines = false,
          delay = 50,
  
          -- 样式配置
          styles = {
            error = "Underline",
            warning = "Underline",
            information = "Underline",
            hint = "Underline",
          },
  
          -- 符号配置
          signs = {
            error = "",
            warning = "",
            information = "",
            hint = "󰌵",
          },
  
          -- 颜色配置
          highlights = {
            error = "DiagnosticUnderlineError",
            warning = "DiagnosticUnderlineWarn",
            information = "DiagnosticUnderlineInfo",
            hint = "DiagnosticUnderlineHint",
          },
  
          -- 诊断优先级
          priority = 200,
  
          -- 与现有LSP诊断集成
          on_init = function(client)
            if client.supports_method("textDocument/publishDiagnostics") then
              client.resolved_capabilities.document_formatting = false
            end
          end,
        })
  
        -- 覆盖默认的diagnostic配置
        vim.diagnostic.config({
          virtual_text = false,
          underline = true,
          update_in_insert = false,
          severity_sort = true,
        })
      end
    }
  }