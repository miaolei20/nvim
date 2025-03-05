local signature = require("lsp_signature")

signature.setup({
  bind = true,
  doc_lines = 2,
  floating_window = true,
  fix_pos = false,
  hint_enable = true,
  hint_prefix = "󰛨 ",
  hint_scheme = "String",
  hi_parameter = "LspSignatureActiveParameter",
  handler_opts = {
    border = "rounded",
    title = " 📝 Signature Help ",
    title_pos = "center",
  },
  extra_trigger_chars = { "(", "," },
  zindex = 200,
  padding = "",
  transparency = 10,
})
