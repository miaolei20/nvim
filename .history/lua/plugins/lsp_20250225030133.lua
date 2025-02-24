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

      -- 模块化加载
      local modules = {
        saga = require("lspsaga"),
        signature = require("lsp_signature"),
        mason_lsp = require("mason-lspconfig"),
        cmp_nvim_lsp = require("cmp_nvim_lsp"),
        dev = require("neodev")
      }

      -- 图标系统
      local icons = {
        diagnostics = {
          Error = " ", Warn = " ", Hint = "󰌵 ", Info = " "
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

      -- LSP Saga 配置（含路径显示）
      modules.saga.setup({
        symbol_in_winbar = {
          enable = true,
          show_file = true,
          separator = icons.symbol.Separator,
          hide_keyword = true,
          color_mode = true,
          file_formatter = function(path)
            local sep = package.config:sub(1,1) -- 自动检测系统分隔符
            local parts = vim.split(path, sep)
            return #parts > 2 
              and table.concat({"...", parts[#parts-1], parts[#parts]}, sep)
              or path
          end
        },
        lightbulb = {
          enable = true,
          sign = icons.code_action,
          virtual_text = false,
          sign_priority = 20
        },
        diagnostic = {
          show_code_action = true,
          show_source = true,
          jump_num_shortcut = true,
          diagnostic_prefix = icons.diagnostics
        },
        finder = {
          default = "def+ref+imp",
          keys = {
            shuttle = "<leader>sf",
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
        }
      })

      -- 签名提示优化
      modules.signature.setup({
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

      -- 智能格式化
      local lsp_format = function(bufnr)
        vim.lsp.buf.format({
          filter = function(client)
            return client.name ~= "tsserver"
          end,
          bufnr = bufnr,
          async = true
        })
      end

      -- 键位映射工厂函数
      local create_keymap = function(client, bufnr)
        local map = function(mode, keys, func, desc)
          vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc })
        end

        -- 导航增强
        map("n", "gd", "<cmd>Lspsaga peek_definition<CR>", "󰈬 Peek Definition")
        map("n", "gD", vim.lsp.buf.declaration, "󰈬 Goto Declaration")
        map("n", "gr", "<cmd>Lspsaga finder<CR>", "󰍉 Find References")
        map("n", "K", "<cmd>Lspsaga hover_doc<CR>", "󰋖 Hover Documentation")
        map("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", "󰌵 Code Action")
        map("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", "󰏖 Rename Symbol")

        -- 诊断导航
        map("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", " Prev Diagnostic")
        map("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", " Next Diagnostic")

        -- 动态路径显示开关
        map("n", "<leader>wp", function()
          local current = modules.saga.config.symbol_in_winbar.show_file
          modules.saga.setup({ symbol_in_winbar = { show_file = not current } })
          vim.notify("Path display: " .. (not current and "ON" or "OFF"), vim.log.levels.INFO)
        end, "Toggle path display")
      end

      -- 能力配置
      local capabilities = vim.tbl_deep_extend(
        "force",
        modules.cmp_nvim_lsp.default_capabilities(),
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

      -- Mason 自动化配置
      modules.mason_lsp.setup({
        ensure_installed = vim.tbl_keys(servers),
        automatic_installation = true,
        handlers = {
          function(server)
            lspconfig[server].setup({
              on_attach = create_keymap,
              capabilities = capabilities,
              settings = servers[server]
            })
          end
        }
      })

      -- 诊断符号配置
      for type, icon in pairs(icons.diagnostics) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      -- 全局诊断样式
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

      -- 延迟加载 Neovim 开发配置
      vim.defer_fn(function()
        modules.dev.setup({
          library = {
            plugins = { "nvim-dap-ui" },
            types = true
          }
        })
      end, 1000)
    end
  }
}