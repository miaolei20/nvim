return {
    "neovim/nvim-lspconfig",  -- 主插件
    dependencies = {
        "williamboman/mason-lspconfig.nvim",  -- LSP 安装管理插件
        "hrsh7th/cmp-nvim-lsp"  -- 提供 LSP 补全能力
    },
    event = {"BufReadPre", "BufNewFile"},  -- 在读取缓冲区或新建文件时加载插件
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
            -- 创建用户命令 Format，调用 lsp_format 函数
            vim.api.nvim_buf_create_user_command(bufnr, "Format", function()
                lsp_format(bufnr)
            end, {
                desc = "Format current buffer with LSP"
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
