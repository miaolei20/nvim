return {
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LspAttach",
    config = function()
      require("tiny-inline-diagnostic").setup({
        virtual_text = true,
        virtual_lines = false,
        delay = 50,
        styles = {
          error = "Underline",
          warning = "Underline",
          information = "Underline",
          hint = "Underline",
        },
        signs = {
          error = "",
          warning = "",
          information = "",
          hint = "󰌵",
        },
        highlights = {
          error = "DiagnosticUnderlineError",
          warning = "DiagnosticUnderlineWarn",
          information = "DiagnosticUnderlineInfo",
          hint = "DiagnosticUnderlineHint",
        },
        priority = 200,
        on_init = function(client)
          if client.supports_method("textDocument/publishDiagnostics") then
            client.resolved_capabilities.document_formatting = false
          end
        end,
      })

      vim.diagnostic.config({
        virtual_text = false,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })
    end,
  },
}
