return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        -- 新增的两个插件
        {
            "glepnir/lspsaga.nvim",
            event = "LspAttach",
            config = true,
            dependencies = { {"nvim-tree/nvim-web-devicons"} }
        },
        {
            "ray-x/lsp_signature.nvim",
            event = "VeryLazy",
            opts = {
                hint_enable = false,  -- 禁用虚拟提示（避免与 cmp 冲突）
                handler_opts = {
                    border = "rounded"  -- 浮动窗口边框样式
                }
            }
        }
    },
    event = {"BufReadPre", "BufNewFile"},
    config = function()
        local lspconfig = require("lspconfig")
        
        -- 定义格式化函数，过滤掉 tsserver
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
            -- LspSaga 快捷键绑定
            local map = function(keys, func, desc)
                vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
            end
            
            map("gh", "<cmd>Lspsaga lsp_finder<CR>", "LSP Finder")
            map("K", "<cmd>Lspsaga hover_doc<CR>", "Hover Doc")
            map("gd", "<cmd>Lspsaga peek_definition<CR>", "Peek Definition")
            map("<leader>cd", "<cmd>Lspsaga show_line_diagnostics<CR>", "Line Diagnostics")
            map("[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", "Prev Diagnostic")
            map("]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", "Next Diagnostic")
            map("<leader>ca", "<cmd>Lspsaga code_action<CR>", "Code Action")

            -- LspSignature 自动触发
            require("lsp_signature").on_attach({
                bind = true,
                handler_opts = { border = "rounded" },
                hint_prefix = "󰘦 "  -- 提示前缀图标
            }, bufnr)

            -- 创建用户命令 Format
            vim.api.nvim_buf_create_user_command(bufnr, "Format", function()
                lsp_format(bufnr)
            end, { desc = "Format current buffer with LSP" })
        end
        
        -- 各语言独立配置
        local servers = {
            lua_ls = {
                settings = {
                    Lua = {
                        format = {
                            defaultConfig = {
                                indent_style = "space",
                                indent_size = "2"
                            }
                        }
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
                },
                settings = {
                    format = {
                        style = "LLVM",
                        indentWidth = 4,
                        UseTab = "Never"
                    }
                }
            }
        }

        -- 应用配置
        for server, config in pairs(servers) do
            lspconfig[server].setup(vim.tbl_deep_extend("force", {
                on_attach = on_attach,
                capabilities = require("cmp_nvim_lsp").default_capabilities()
            }, config))
        end

        -- LspSaga 独立配置
        require("lspsaga").setup({
            lightbulb = {
                enable = false,  -- 禁用代码灯泡图标（避免与其他插件冲突）
            },
            outline = {
                keys = {
                    toggle_or_jump = "<CR>",  -- Enter 键展开/跳转
                }
            },
            symbol_in_winbar = {
                enable = false  -- 禁用路径栏符号（按需开启）
            }
        })
    end
}