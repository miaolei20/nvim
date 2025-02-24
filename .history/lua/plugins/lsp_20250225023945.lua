-- file: plugins/lsp.lua
return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "glepnir/lspsaga.nvim",
      "ray-x/lsp_signature.nvim",
      "folke/neodev.nvim"
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- 安全加载检查
      local ok, lspconfig = pcall(require, "lspconfig")
      if not ok then return end

      local saga = require("lspsaga")
      local signature = require("lsp_signature")
      local mason_lsp = require("mason-lspconfig")
      local cmp_nvim_lsp = require("cmp_nvim_lsp")

      -- 自定义图标配置（保持原样）
      local icons = {
        diagnostics = {
          Error = " ",
          Warn = " ",
          Hint = "󰌵 ",
          Info = " "
        },
        code_action = "󰌵",
        symbol = {
          File = "󰈔 ",
          Module = "󰆧 ",
          Namespace = "󰅩 ",
          Package = "󰏖 ",
          Class = "󰠱 ",
          Method = "󰆧 ",
          Property = "󰜢 ",
          Field = "󰜢 ",
          Constructor = " ",
          Enum = "󰕘 ",
          Interface = "󰕘 ",
          Function = "󰊕 ",
          Variable = "󰫧 ",
          Constant = "󰏿 ",
          String = "󰉿 ",
          Number = "󰎠 ",
          Boolean = "󰨙 ",
          Array = "󰅪 ",
          Object = "󰅩 ",
          Key = "󰌋 ",
          Null = "󰟢 ",
          EnumMember = " ",
          Struct = "󰠱 ",
          Event = " ",
          Operator = "󰆕 ",
          TypeParameter = "󰗴 ",
          Separator = "  "
        }
      }

      -- 初始化 LSP Saga（修复代码块选中问题）
      saga.setup({
        symbol_in_winbar = {
          enable = true,
          separator = icons.symbol.Separator,
          hide_keyword = true,
          show_file = false,
          color_mode = true
        },
        lightbulb = {
          enable = true,
          sign = icons.code_action,
          virtual_text = false,
          sign_priority = 20
        },
        ui = {
          code_action = '󰌵',
          -- 修复选中块颜色配置
          kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind(),
          border = "single"
        },
        diagnostic = {
          show_code_action = true,
          show_source = true,
          jump_num_shortcut = true,
          diagnostic_prefix = {
            error = icons.diagnostics.Error,
            warn = icons.diagnostics.Warn,
            hint = icons.diagnostics.Hint,
            info = icons.diagnostics.Info
          }
        },
        finder = {
          default = "def+ref+imp",
          keys = {
            shuttle = "<leader>ff",
            toggle_or_open = "o",
            vsplit = "v",
            split = "s",
            tabe = "t",
            quit = "q"
          },
          layout = "float",
          title = " 🕵️ LSP Finder ",
          force_max_height = true,
          max_height = 0.6
        },
        definition = {
          edit = "<C-c>o",
          vsplit = "<C-c>v",
          split = "<C-c>s",
          tabe = "<C-c>t",
          quit = "q",
          close = "<Esc>"
        }
      })

      -- 配置签名提示（保持原样）
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
          title_pos = "center"
        },
        extra_trigger_chars = { "(", "," },
        zindex = 200,
        padding = '',
        transparency = 10
      })

      -- 增强的格式化功能
      local lsp_format = function(bufnr)
        vim.lsp.buf.format({
          filter = function(client)
            return client.name ~= "tsserver"
          end,
          bufnr = bufnr,
          async = true
        })
      end

      -- 公共配置（添加高亮修复）
      local on_attach = function(client, bufnr)
        -- 创建格式化命令
        vim.api.nvim_buf_create_user_command(bufnr, "Format", function()
          lsp_format(bufnr)
        end, { desc = "󰉢 Format buffer with LSP" })

        -- 智能键位映射
        local map = function(mode, keys, func, desc)
          vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc })
        end

        -- 导航增强（修复高亮问题）
        map("n", "gd", "<cmd>Lspsaga peek_definition<CR>", "󰈬 Peek Definition")
        map("n", "gD", vim.lsp.buf.declaration, "󰈬 Goto Declaration")
        map("n", "gr", "<cmd>Lspsaga finder<CR>", "󰍉 Find References")
        map("n", "K", "<cmd>Lspsaga hover_doc<CR>", "󰋖 Hover Documentation")
        map("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", "󰌵 Code Action")
        map("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", "󰏖 Rename Symbol")

        -- 诊断导航（添加高亮修复）
        map("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", " Prev Diagnostic")
        map("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", " Next Diagnostic")

        -- 启用签名帮助（添加高亮修复）
        signature.on_attach({}, bufnr)
        
        -- 设置代码块高亮
        if client.supports_method("textDocument/documentHighlight") then
          vim.cmd [[
            hi! link LspSagaFinderSelection Visual
            hi! link LspSagaCodeActionTitle Title
            hi! link TargetWord FloatBorder
            autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()
            autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
            autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
          ]]
        end
      end

      -- 剩余配置保持不变...
      -- [此处保持原有的 capabilities、servers、mason配置等不变]
      -- 确保不要省略任何原有配置部分

      -- 能力配置
      local capabilities = vim.tbl_deep_extend(
        "force",
        cmp_nvim_lsp.default_capabilities(),
        {
          textDocument = {
            foldingRange = {
              dynamicRegistration = false,
              lineFoldingOnly = true
            }
          }
        }
      )

      -- 语言服务器配置
      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              diagnostics = { globals = { "vim" } },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false
              },
              telemetry = { enable = false }
            }
          }
        },
        clangd = {
          cmd = {
            "clangd",
            "--offset-encoding=utf-16",
            "--clang-tidy",
            "--header-insertion=never"
          }
        },
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                diagnosticMode = "workspace"
              }
            }
          }
        }
      }

      -- 初始化 Mason LSP
      mason_lsp.setup({
        ensure_installed = vim.tbl_keys(servers),
        automatic_installation = true
      })

      mason_lsp.setup_handlers({
        function(server)
          lspconfig[server].setup({
            on_attach = on_attach,
            capabilities = capabilities,
            settings = servers[server] or {}
          })
        end
      })

      -- 设置诊断符号
      for type, icon in pairs(icons.diagnostics) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      -- 全局诊断配置（美化）
      vim.diagnostic.config({
        virtual_text = {
          prefix = "●",
          spacing = 4,
          source = "if_many"
        },
        float = {
          border = "rounded",
          header = { " Diagnostics:", "Normal" },
          prefix = function(diag)
            return icons.diagnostics[diag.severity] .. " "
          end
        },
        severity_sort = true,
        update_in_insert = false
      })

      -- 延迟加载 Neovim Lua 开发配置
      vim.defer_fn(function()
        require("neodev").setup({
          library = {
            plugins = { "nvim-dap-ui" },
            types = true
          }
        })
      end, 1000)
    end
  }
}