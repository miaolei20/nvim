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
      -- 字体兼容性检测
      vim.g.have_nerd_font = (function()
        if vim.fn.has("macunix") == 1 then return true end
        if vim.fn.exists("*nerdfont#find") == 1 then
          return vim.fn.nerdfont#find() ~= ""
        end
        return false
      end)()

      -- 安全加载模块
      local lspconfig = require("lspconfig")
      local saga = require("lspsaga")
      local signature = require("lsp_signature")
      local mason_lsp = require("mason-lspconfig")
      local cmp_nvim_lsp = require("cmp_nvim_lsp")

      -- 优化图标配置
      local icons = {
        diagnostics = {
          Error = vim.g.have_nerd_font and " " or "E",
          Warn = vim.g.have_nerd_font and " " or "W",
          Hint = vim.g.have_nerd_font and "󰌵 " or "H",
          Info = vim.g.have_nerd_font and " " or "I"
        },
        code_action = vim.g.have_nerd_font and "󰌵" or "💡",
        symbol = {
          File = vim.g.have_nerd_font and " " or "F",
          Separator = vim.g.have_nerd_font and "  " or " > ",
          Class = vim.g.have_nerd_font and "󰠱 " or "C"
        }
      }

      -- Lspsaga 配置
      saga.setup({
        symbol_in_winbar = {
          enable = true,
          separator = icons.symbol.Separator,
          show_file = false,
          ignore_patterns = { "%.test.*", "%.mock.*" },
          color_mode = true
        },
        lightbulb = {
          enable = true,
          sign = icons.code_action,
          virtual_text = false,
          sign_priority = 20
        },
        diagnostic = {
          show_code_action = true,
          show_source = false,
          diagnostic_prefix = icons.diagnostics,
          jump_num_shortcut = true
        },
        finder = {
          default = "def+ref",
          layout = "float",
          max_height = 0.6,
          left_width = 0.3
        }
      })

      -- 签名提示配置
      signature.setup({
        bind = true,
        doc_lines = 2,
        floating_window = true,
        hint_enable = true,
        hint_prefix = icons.code_action .. " ",
        hint_scheme = "String",
        handler_opts = {
          border = "single",
          title = " Signature Help ",
          title_pos = "center"
        },
        zindex = 200,
        padding = '',
        transparency = 10
      })

      -- 格式化功能
      local lsp_format = function(bufnr)
        vim.lsp.buf.format({
          filter = function(client)
            return client.name ~= "tsserver"
          end,
          bufnr = bufnr,
          async = true
        })
      end

      -- 通用附加配置
      local on_attach = function(client, bufnr)
        vim.api.nvim_buf_create_user_command(bufnr, "Format", function()
          lsp_format(bufnr)
        end, { desc = "Format buffer with LSP" })

        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        -- 核心键位映射
        map("n", "gd", "<cmd>Lspsaga peek_definition<CR>", "Peek Definition")
        map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
        map("n", "gr", "<cmd>Lspsaga finder<CR>", "Find References")
        map("n", "K", "<cmd>Lspsaga hover_doc<CR>", "Hover Documentation")
        map("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", "Code Action")
        map("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", "Rename Symbol")

        -- 诊断导航
        map("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", "Prev Diagnostic")
        map("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", "Next Diagnostic")

        -- 禁用冲突的默认功能
        client.server_capabilities.documentFormattingProvider = false
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

      -- Mason 配置
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

      -- 诊断符号配置
      for type, icon in pairs(icons.diagnostics) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      -- 全局诊断设置
      vim.diagnostic.config({
        virtual_text = {
          prefix = "●",
          spacing = 4,
          source = "if_many"
        },
        float = {
          border = "single",
          header = "",
          prefix = function(diag)
            return icons.diagnostics[diag.severity] .. " "
          end
        },
        severity_sort = true,
        update_in_insert = false
      })

      -- Neovim 开发配置
      vim.defer_fn(function()
        require("neodev").setup({
          library = {
            plugins = { "nvim-dap-ui" },
            types = true
          }
        })
      end, 1000)

      -- 字体提示
      if not vim.g.have_nerd_font then
        vim.notify(
          "For better icon experience, install Nerd Font:\nhttps://www.nerdfonts.com/",
          vim.log.levels.WARN,
          { title = "LSP Configuration" }
        )
      end
    end
  }
}