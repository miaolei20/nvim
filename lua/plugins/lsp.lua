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

      -- LSP Saga 配置
      modules.saga.setup({
        symbol_in_winbar = {
          enable = true,
          show_file = true,
          separator = icons.symbol.Separator,
          hide_keyword = true,
          color_mode = true,
          file_formatter = function(path)
            local sep = package.config:sub(1, 1)
            local parts = vim.split(path, sep)
            return #parts > 2
                and table.concat({ "...", parts[#parts - 1], parts[#parts] }, sep)
                or path
          end
        },
        lightbulb = {
          enable = false,
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

      -- 智能格式化函数
      local lsp_format = function(bufnr)
        vim.lsp.buf.format({
          filter = function(client)
            local filetype = vim.bo[bufnr].filetype
            if filetype == "python" then
              return client.name == "pyright"
            elseif filetype == "lua" then
              return client.name == "lua_ls"
            elseif filetype:match("^c%a*") then
              return client.name == "clangd"
            end
            return client.name ~= "tsserver"
          end,
          bufnr = bufnr,
          async = true,
          timeout_ms = 3000
        })
      end

      -- 键位映射工厂函数
      local create_keymap = function(client, bufnr)
        local map = function(mode, keys, func, desc)
          vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc })
        end

        -- 核心功能映射
        map("n", "gd", "<cmd>Lspsaga peek_definition<CR>", "Peek Definition")
        map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
        map("n", "gr", "<cmd>Lspsaga finder<CR>", "Find References")
        map("n", "K", "<cmd>Lspsaga hover_doc<CR>", "Hover Documentation")
        map("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", "Code Action")
        map("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", "Rename Symbol")
        map("n", "<leader>lf", function()
          lsp_format(bufnr)
          vim.defer_fn(function()
            if vim.api.nvim_buf_get_option(bufnr, 'modified') then
              vim.cmd('silent w')
            end
          end, 500) -- 延迟 500ms 确保格式化完成
        end, "Format buffer and save")

        -- 诊断导航
        map("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", "Prev Diagnostic")
        map("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", "Next Diagnostic")

        -- 动态路径显示
        map("n", "<leader>wp", function()
          local current = modules.saga.config.symbol_in_winbar.show_file
          modules.saga.setup({ symbol_in_winbar = { show_file = not current } })
          vim.notify("Path display: " .. (not current and "ON" or "OFF"), vim.log.levels.INFO)
        end, "Toggle path display")
      end

      -- 能力配置
      local capabilities = vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),
        modules.cmp_nvim_lsp.default_capabilities(),
        {
          textDocument = {
            foldingRange = {
              dynamicRegistration = false,
              lineFoldingOnly = true
            }
          },
          -- 新增 LSP 对折叠的支持
          experimental = {
            foldingRange = true,
            foldingUp = true,
            foldingDown = true
          }
        }
      )

      -- 公共on_attach配置
      local common_on_attach = function(client, bufnr)
        create_keymap(client, bufnr)
        -- 初始化折叠
        if client.supports_method("textDocument/foldingRange") then
          require("ufo").attach(bufnr)
        end
        -- 自动格式化配置
        --  if client.supports_method("textDocument/formatting") then
        --    vim.api.nvim_create_autocmd("BufWritePre", {
        --`      group = vim.api.nvim_create_augroup("LspFormat", { clear = true }),
        --      buffer = bufnr,
        --      callback = function() lsp_format(bufnr) end
        --    })
        --  end
      end

      -- Neovim开发配置
      modules.dev.setup({
        library = {
          plugins = { "nvim-dap-ui" },
          types = true
        }
      })

      -- Mason LSP配置
      modules.mason_lsp.setup({
        ensure_installed = {
          "lua_ls",  -- Lua
          "clangd",  -- C/C++
          "pyright", -- Python
          "bashls",  -- Bash
          "jsonls",  -- JSON
          "yamlls"   -- YAML
        },
        automatic_installation = true
      })

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
              telemetry = { enable = false },
              format = {
                enable = true,
                defaultConfig = {
                  indent_style = "space",
                  indent_size = "2",
                  quote_style = "auto"
                }
              }
            }
          }
        },
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=never",
            "--completion-style=detailed"
          },
          filetypes = { "c", "cpp", "objc", "objcpp" },
          capabilities = {
            offsetEncoding = "utf-8",
            textDocument = {
              completion = {
                editsNearCursor = true
              }
            }
          }
        },
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace"
              },
              formatting = {
                provider = "black",
                args = { "--line-length", "120", "--quiet" }
              }
            }
          }
        }
      }

      -- 应用服务器配置
      for server, config in pairs(servers) do
        lspconfig[server].setup(vim.tbl_deep_extend("force", {
          on_attach = common_on_attach,
          capabilities = capabilities,
          flags = {
            debounce_text_changes = 150
          }
        }, config))
      end

      -- 文件类型特定配置
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "c", "cpp" },
        callback = function()
          vim.bo.tabstop = 4
          vim.bo.shiftwidth = 4
          vim.bo.softtabstop = 4
          vim.bo.expandtab = true
        end
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "python",
        callback = function()
          vim.bo.tabstop = 4
          vim.bo.shiftwidth = 4
          vim.bo.softtabstop = 4
          vim.bo.expandtab = true
        end
      })
    end
  }
}
