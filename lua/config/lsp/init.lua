local M = {}

local lspconfig = require("lspconfig")
local mason_lspconfig = require("mason-lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

-- 💡 LSP 附加功能配置
local function on_attach(client, bufnr)
    -- 定义按键映射
    local mappings = {
        { modes = { "n" }, lhs = "<leader>lgd", rhs = "<cmd>Telescope lsp_definitions<CR>", desc = "跳转到定义" },
        { modes = { "n" }, lhs = "<leader>lgr", rhs = "<cmd>Telescope lsp_references<CR>", desc = "引用" },
        { modes = { "n" }, lhs = "<leader>lh", rhs = vim.lsp.buf.hover, desc = "悬浮文档" },
        { modes = { "n" }, lhs = "<leader>lr", rhs = vim.lsp.buf.rename, desc = "重命名符号" },
        { modes = { "n" }, lhs = "<leader>lc", rhs = vim.lsp.buf.code_action, desc = "代码操作" },
        { modes = { "n" }, lhs = "<leader>lf", rhs = function()
            require("conform").format({ async = true, lsp_fallback = true })
        end, desc = "格式化缓冲区" },
    }

    -- 设置按键映射
    for _, mapping in ipairs(mappings) do
        vim.keymap.set(mapping.modes, mapping.lhs, mapping.rhs, { buffer = bufnr, desc = mapping.desc, noremap = true, silent = true })
    end
end

-- 🚀 主配置入口
function M.setup()
    -- 诊断符号设置
   vim.diagnostic.config({
    virtual_text = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "",
        },
        texthl = {
            [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
            [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
            [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
            [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
        },
        numhl = {
            [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
            [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
            [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
            [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
        },
    },
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
        focusable = true,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
    },
})

    vim.diagnostic.config({
        virtual_text = true,
        signs = {
            active = signs,
        },
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        float = {
            focusable = true,
            style = "minimal",
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
        },
    })

    -- 通用 Capabilities
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- LSP 服务器配置表
    local servers = {
        lua_ls = {
            settings = {
                Lua = {
                    diagnostics = { globals = { "vim" } },
                    workspace = { checkThirdParty = false },
                    telemetry = { enable = false },
                    format = { enable = false },
                },
            },
        },
        clangd = {
            capabilities = {
                offsetEncoding = { "utf-16" },
            },
            cmd = { "clangd", "--background-index", "--clang-tidy" },
        },
        pyright = {
            settings = {
                python = {
                    analysis = {
                        autoSearchPaths = true,
                        useLibraryCodeForTypes = true,
                    },
                },
            },
        },
        jsonls = {
            settings = {
                json = {
                    schemas = require("schemastore").json.schemas(),
                    validate = { enable = true },
                },
            },
        },
        yamlls = {
            settings = {
                yaml = {
                    schemas = require("schemastore").yaml.schemas(),
                },
            },
        },
        bashls = {},
    }

    -- 安装所有 servers（按配置表键名）
    mason_lspconfig.setup({
        ensure_installed = vim.tbl_keys(servers),
    })

    -- 遍历每个服务器并设置
    for server_name, server_opts in pairs(servers) do
        local opts = {
            on_attach = on_attach,
            capabilities = vim.tbl_deep_extend("force", capabilities, server_opts.capabilities or {}),
            settings = server_opts.settings or {},
            cmd = server_opts.cmd,
        }
        lspconfig[server_name].setup(opts)
    end
end

return M