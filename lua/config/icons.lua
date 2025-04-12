-- ~/.config/nvim/lua/config/icons.lua
return {
    misc = {
      vim = "",       -- Vim 图标
      clock = "",      -- 时钟图标
      branch = "",     -- Git分支图标
      lsp = "",
      ui = { close = "✗", separator = "│" },
    },
    kinds = {          -- LSP 符号类型图标
      Array = "",
      Boolean = "",
      Class = "",
      Function = "󰊕",
      Method = "󰊕",
      Interface = "",
      Constructor = "",
      Enum = "",
      Module = "",
      Struct = "",
      -- 其他图标可在此补充
    },
    diagnostics = {    -- 诊断图标
      Error = "",
      Warn = "",
      Info = "",
      Hint = "",
    },
    git = {            -- Git 状态图标
      added = "",
      modified = "",
      removed = "",
    }
  }