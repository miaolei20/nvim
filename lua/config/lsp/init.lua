-- ~/.config/nvim/lua/config/lsp/init.lua

local M = {}

local lspconfig = require("lspconfig")
local mason_lspconfig = require("mason-lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local wk = require("which-key")

-- 💡 LSP 附加功能配置
local function on_attach(client, bufnr)
    wk.register({
        ["<leader>l"] = { name = "LSP 💡" },
        ["<leader>lg"] = { name = "Goto 🔍" },
        ["<leader>lgd"] = { "<cmd>Telescope lsp_definitions<CR>", "Go to Definition" },
        ["<leader>lgr"] = { "<cmd>Telescope lsp_references<CR>", "References" },
        ["<leader>lh"] = { vim.lsp.buf.hover, "Hover Documentation" },
        ["<leader>lr"] = { vim.lsp.buf.rename, "Rename Symbol" },
        ["<leader>lc"] = { vim.lsp.buf.code_action, "Code Action" },
        ["<leader>lf"] = {
            function()
                require("conform").format({ async = true, lsp_fallback = true })
            end,
            "Format Buffer"
        },
    }, { buffer = bufnr })
end

-- 🚀 主配置入口
function M.setup()
    -- Diagnostic 符号设置
    local signs = {
        { name = "DiagnosticSignError", text = "" },
        { name = "DiagnosticSignWarn", text = "" },
        { name = "DiagnosticSignInfo", text = "" },
        { name = "DiagnosticSignHint", text = "" },
    }
    for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, {
            texthl = sign.name,
            text = sign.text,
            numhl = sign.name,
        })
    end

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

