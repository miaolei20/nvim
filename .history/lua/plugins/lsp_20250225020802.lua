-- file: plugins/lsp.lua
return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "glepnir/lspsaga.nvim",
      "ray-x/lsp_signature.nvim",
      "folke/trouble.nvim",        -- 新增 Quickfix 增强
      "AndrewRadev/sideways.vim"   -- 新增参数导航
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lspconfig = require("lspconfig")
      local saga = require("lspsaga")
      local trouble = require("trouble")
      local signature = require("lsp_signature")

      -- 配置 Trouble (Quickfix 增强)
      trouble.setup({
        position = "bottom",
        height = 15,
        icons = true,
        mode = "document_diagnostics",
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
        }
      })

      -- LspSaga 配置
      saga.setup({
        symbol_in_winbar = {
          enable = true,
          separator = "  ",
          hide_keyword = true
        },
        lightbulb = {
          enable = true,
          sign = "",
          virtual_text = false
        },
        diagnostic = {
          show_code_action = true,
          show_source = true,
          jump_num_shortcut = true
        }
      })

      -- LSP 签名提示
      signature.setup({
        bind = true,
        doc_lines = 3,
        floating_window = true,
        fix_pos = false,
        hint_enable = true,
        hint_prefix = " ",
        hi_parameter = "LspSignatureActiveParameter",
        handler_opts = {
          border = "rounded"
        }
      })

      -- 公共配置
      local on_attach = function(client, bufnr)
        -- 创建用户命令
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

        -- 基础 LSP 操作
        map("n", "gd", "<cmd>Lspsaga peek_definition<CR>", "Peek Definition")
        map("n", "gr", "<cmd>Lspsaga lsp_finder<CR>", "References")
        map("n", "K", "<cmd>Lspsaga hover_doc<CR>", "Hover Doc")
        map("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", "Code Action")

        -- Trouble 集成
        map("n", "<leader>xx", "<cmd>TroubleToggle<CR>", "Toggle Trouble")
        map("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<CR>", "Workspace Issues")
        map("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<CR>", "Document Issues")

        -- 参数导航
        map("n", "<A-,>", "<cmd>SidewaysLeft<CR>", "Move Parameter Left")
        map("n", "<A-.>", "<cmd>SidewaysRight<CR>", "Move Parameter Right")

        -- 签名帮助
        signature.on_attach({}, bufnr)
      end

      -- 增强的 LSP 能力
      local capabilities = vim.tbl_deep_extend(
        "force",
        require("cmp_nvim_lsp").default_capabilities(),
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
              diagnostics = { globals = { "vim" } },
              workspace = { checkThirdParty = false },
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

      -- 初始化服务器
      require("mason-lspconfig").setup()
      require("mason-lspconfig").setup_handlers({
        function(server)
          lspconfig[server].setup({
            on_attach = on_attach,
            capabilities = capabilities,
            settings = servers[server] or {}
          })
        end
      })
    end
  }
}