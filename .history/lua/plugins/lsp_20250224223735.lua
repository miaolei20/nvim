return {
    "neovim/nvim-lspconfig",  -- 主插件
    dependencies = {
        "williamboman/mason-lspconfig.nvim",  -- LSP 安装管理插件
        "hrsh7th/cmp-nvim-lsp",  -- 提供 LSP 补全能力
        "glepnir/lspsaga.nvim",  -- lspsaga 插件
        "ray-x/lsp_signature.nvim",  -- lsp_signature 插件
    },
    event = {"BufReadPre", "BufNewFile"},  -- 在读取缓冲区或新建文件时加载插件
    config = function()
        local lspconfig = require("lspconfig")
        local saga = require("lspsaga")
        local lsp_signature = require("lsp_signature")

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
            -- 创建用户命令 Format，调用 lsp_format 函数
            vim.api.nvim_buf_create_user_command(bufnr, "Format", function()
                lsp_format(bufnr)
            end, {
                desc = "Format current buffer with LSP"
            })

            -- 启动 lsp_signature
            lsp_signature.on_attach({
                bind = true,  -- This is mandatory, otherwise border config won't get registered.
                handler_opts = {
                    border = "rounded"  -- 可调整边框样式
                },
                hint_enable = true,
            })

            -- 配置 lspsaga
            saga.init_lsp_saga({
                -- 自定义配置
                error_sign = "✖",
                warn_sign = "⚠",
                hint_sign = "💡",
                infor_sign = "ℹ",
                action_fix = "⚙️"
            })
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
                cmd = {"clangd", "--offset-encoding=utf-16", "--clang-tidy", "--header-insertion=never",
                       "--query-driver=/usr/bin/clang"},
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
    end
}
