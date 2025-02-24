-- file: plugins/lsp.lua
return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "glepnir/lspsaga.nvim",
      "ray-x/lsp_signature.nvim",
      "folke/neodev.nvim"  -- 新增 Lua 开发增强
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

      -- 初始化 LSP Saga
      saga.setup({
        symbol_in_winbar = {
          enable = true,
          separator = "  ",
          hide_keyword = true
        },
        lightbulb = {
          enable = true,
          sign = "",
          virtual_text = false
        },
        diagnostic = {
          show_code_action = true,
          show_source = true,
          jump_num_shortcut = true
        }
      })

      -- 配置签名提示
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

      -- 公共配置
      local on_attach = function(client, bufnr)
        -- 创建格式化命令
        vim.api.nvim_buf_create_user_command(bufnr, "Format", function()
          lsp_format(bufnr)
        end, { desc = "Format buffer with LSP" })

        -- 智能键位映射
        local map = function(mode, keys, func, desc)
          vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc })
        end

        -- 导航增强
        map("n", "gd", "<cmd>Lspsaga peek_definition<CR>", "Peek Definition")
        map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
        map("n", "gr", "<cmd>Lspsaga finder<CR>", "Find References")
        map("n", "K", "<cmd>Lspsaga hover_doc<CR>", "Hover Documentation")
        map("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", "Code Action")
        map("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", "Rename Symbol")

        -- 诊断导航
        map("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", "Prev Diagnostic")
        map("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", "Next Diagnostic")

        -- 启用签名帮助
        signature.on_attach({}, bufnr)
      end

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
        ensure_installed = vim.tbl_keys(servers)
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

      -- 延迟加载 Neovim Lua 开发配置
      vim.defer_fn(function()
        require("neodev").setup({
          library = { plugins = { "nvim-dap-ui" }, types = true }
        })
      end, 1000)
    end
  }
}