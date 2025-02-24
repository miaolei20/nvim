-- file: plugins/lsp.lua
return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "glepnir/lspsaga.nvim",
      "ray-x/lsp_signature.nvim",
      "folke/trouble.nvim",
      "SmiteshP/nvim-navic",
      "sidebar-nvim/sidebar.nvim"
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- 基础模块加载
      local lspconfig = require("lspconfig")
      local mason = require("mason")
      local mason_lsp = require("mason-lspconfig")
      local saga = require("lspsaga")
      local trouble = require("trouble")
      local signature = require("lsp_signature")
      local navic = require("nvim-navic")

      -- 初始化 Mason
      mason.setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      })

      -- Trouble 配置 (Quickfix 增强)
      trouble.setup({
        position = "bottom",
        height = 15,
        width = 50,
        icons = true,
        mode = "workspace_diagnostics",
        auto_open = false,
        auto_close = true,
        action_keys = {
          close = "q",
          cancel = "<esc>",
          refresh = "r",
          jump = { "<cr>", "<tab>" },
          open_split = { "<c-x>" },
          open_vsplit = { "<c-v>" },
          open_tab = { "<c-t>" },
          toggle_mode = "m",
        },
        use_diagnostic_signs = true
      })

      -- LspSaga 配置
      saga.setup({
        symbol_in_winbar = {
          enable = true,
          separator = "  ",
          show_file = false
        },
        lightbulb = {
          enable = true,
          sign = "",
          virtual_text = false
        },
        diagnostic = {
          show_code_action = true,
          show_source = true,
          jump_num_shortcut = true,
          max_width = 0.6,
          max_height = 0.5
        },
        finder = {
          max_height = 0.5,
          keys = {
            toggle_or_open = "o",
            vsplit = "v",
            split = "s",
            tabe = "t",
            quit = "q",
          }
        }
      })

      -- 签名提示配置
      signature.setup({
        bind = true,
        doc_lines = 2,
        floating_window = true,
        fix_pos = false,
        hint_enable = true,
        hint_prefix = " ",
        hi_parameter = "LspSignatureActiveParameter",
        handler_opts = {
          border = "rounded"
        },
        extra_trigger_chars = { "(", "," }
      })

      -- 公共配置
      local on_attach = function(client, bufnr)
        -- 启用文档符号
        if client.server_capabilities.documentSymbolProvider then
          navic.attach(client, bufnr)
        end

        -- 用户命令
        vim.api.nvim_buf_create_user_command(bufnr, "Format", function()
          vim.lsp.buf.format({
            async = true,
            filter = function(c)
              return c.name ~= "tsserver"
            end
          })
        end, { desc = "LSP Format" })

        -- 快捷键映射
        local map = function(mode, keys, func, desc)
          vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc })
        end

        -- 基础 LSP 功能
        map("n", "gd", "<cmd>Lspsaga peek_definition<CR>", "Peek Definition")
        map("n", "gr", "<cmd>Lspsaga lsp_finder<CR>", "Find References")
        map("n", "K", "<cmd>Lspsaga hover_doc<CR>", "Hover Documentation")
        map("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", "Code Action")
        map("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", "Rename Symbol")

        -- 诊断相关
        map("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", "Previous Diagnostic")
        map("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", "Next Diagnostic")
        map("n", "<leader>cd", "<cmd>Lspsaga show_line_diagnostics<CR>", "Line Diagnostics")

        -- Trouble 集成
        map("n", "<leader>xx", function() trouble.toggle() end, "Toggle Trouble List")
        map("n", "<leader>xw", function() trouble.toggle("workspace_diagnostics") end, "Workspace Issues")
        map("n", "<leader>xd", function() trouble.toggle("document_diagnostics") end, "Document Issues")
        map("n", "<leader>xq", function() trouble.toggle("quickfix") end, "Quickfix List")

        -- 侧边栏集成
        map("n", "<leader>sb", "<cmd>SidebarNvimToggle<CR>", "Toggle Sidebar")

        -- 签名帮助
        signature.on_attach({}, bufnr)
      end

      -- LSP 能力配置
      local capabilities = vim.tbl_deep_extend(
        "force",
        require("cmp_nvim_lsp").default_capabilities(),
        {
          textDocument = {
            foldingRange = {
              dynamicRegistration = false,
              lineFoldingOnly = true
            }
          },
          workspace = {
            didChangeWatchedFiles = {
              dynamicRegistration = true
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
            "--header-insertion=never",
            "--query-driver=/usr/bin/clang"
          }
        },
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true
              }
            }
          }
        }
      }

      -- 初始化 Mason LSP
      mason_lsp.setup({
        ensure_installed = vim.tbl_keys(servers)
      })

      mason_lsp.setup_handlers({
        function(server_name)
          lspconfig[server_name].setup({
            on_attach = on_attach,
            capabilities = capabilities,
            settings = servers[server_name] or {}
          })
        end
      })

      -- 全局诊断配置
      vim.diagnostic.config({
        virtual_text = false,
        float = { border = "rounded" },
        signs = true,
        update_in_insert = false,
        severity_sort = true
      })

      -- 自定义诊断符号
      local signs = { Error = "", Warn = "", Hint = "", Info = "" }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end
    end
  }
}