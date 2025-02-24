return {
    "neovim/nvim-lspconfig",  -- 主插件
    dependencies = {
        "williamboman/mason-lspconfig.nvim",  -- LSP 安装管理插件
        "hrsh7th/cmp-nvim-lsp"  -- 提供 LSP 补全能力
        "glepnir/lspsaga.nvim",
        "ray-x/lsp_signature.nvim",
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

        
        -- 初始化 LSP Saga
        require("lspsaga").setup({
            symbol_in_winbar = { enable = false }, -- 按需配置
            finder = { keys = { toggle_or_open = "o" } },
            lightbulb = { enable = false } -- 可启用代码灯泡提示
        })

        -- 初始化 LSP 签名提示
        require("lsp_signature").setup({
            bind = true,
            hint_enable = false, -- 关闭浮动提示（可选）
            handler_opts = { border = "rounded" }
        })

        -- 公共配置
        local on_attach = function(client, bufnr)
            -- 绑定 LSP Saga 快捷键
            local opts = { buffer = bufnr, noremap = true }
            vim.keymap.set("n", "gh", "<cmd>Lspsaga lsp_finder<CR>", opts)
            vim.keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts)
            vim.keymap.set("n", "gr", "<cmd>Lspsaga rename<CR>", opts)
            vim.keymap.set("n", "<leader>d", "<cmd>Lspsaga show_line_diagnostics<CR>", opts)

            -- 用户命令 Format
            vim.api.nvim_buf_create_user_command(bufnr, "Format", function()
                vim.lsp.buf.format({
                    filter = function(client)
                        return client.name ~= "tsserver"
                    end,
                    bufnr = bufnr,
                    async = true
                })
            end, { desc = "Format current buffer with LSP" })
            
            -- 自动绑定签名提示（由 lsp_signature 处理）
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
