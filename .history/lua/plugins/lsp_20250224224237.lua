return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "glepnir/lspsaga.nvim",  -- 新增 lspsaga.nvim 插件
        "ray-x/lsp_signature.nvim"  -- 新增 lsp_signature.nvim 插件
    },
    event = {"BufReadPre", "BufNewFile"},
    config = function()
        local lspconfig = require("lspconfig")
        local saga = require("lspsaga")
        local lsp_signature = require("lsp_signature")

        -- 初始化 lspsaga
        saga.setup({})

        -- 配置 lsp_signature
        lsp_signature.setup({
            bind = true,  -- 这是推荐配置， bind为true表示自动绑定
            doc_lines = 2,  -- 显示的文档行数，可在 hovering中查看
            floating_window = true,  -- 是否使用浮动窗口显示签名信息
            fix_pos = false,  -- 浮动窗口是否固定位置
            hint_enable = true,  -- 显示参数提示
            hint_prefix = "🐼 ",  -- 提示信息前缀
            hi_parameter = "LspSignatureActiveParameter",  -- 高亮当前参数
            max_height = 12,
            max_width = 80,  -- 浮动窗口最大宽度
            handler_opts = {
                border = "single"  -- 边框类型：single, double, shadow, none
            },
            extra_trigger_chars = {},  -- 除了函数调用的"()”字符外的触发字符
            zindex = 200,
            padding = '', -- 如果你发现浮动窗口文本边界没有缩进可以设置这个
        })

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

            -- 启用 lspsaga 和 lsp_signature
            lsp_signature.on_attach({}, bufnr)
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