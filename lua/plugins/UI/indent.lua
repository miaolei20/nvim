return {{
    "lukas-reineke/indent-blankline.nvim",
    event = {"BufReadPost", "BufNewFile"}, -- 延迟加载
    main = "ibl",
    opts = {
        indent = {
            char = "┆", -- VSCode 风格细虚线
            highlight = "IblIndent" -- 自定义缩进线的高亮组
        },
        scope = {
            enabled = false
        }, -- 禁用范围显示，模仿 VSCode
        exclude = {
            filetypes = {"help", "dashboard", "neo-tree", "Trouble", "lazy", "terminal"}
        }
    },
    config = function(_, opts)
        -- 设置缩进线高亮的颜色
        local function set_highlight()
            local colors = vim.api.nvim_get_hl(0, {
                name = "Comment"
            }) -- 获取当前主题的 Comment 颜色
            vim.api.nvim_set_hl(0, "IblIndent", {
                fg = colors.fg or "#4B5263", -- 如果未找到颜色则使用默认的灰色
                nocombine = true
            })
        end

        -- 初始设置高亮
        set_highlight()
        require("ibl").setup(opts)

        -- 主题切换时自动更新高亮
        vim.api.nvim_create_autocmd("ColorScheme", {
            group = vim.api.nvim_create_augroup("IndentBlanklineColors", {
                clear = true
            }),
            callback = set_highlight,
            desc = "Update indent highlight on theme change"
        })
    end
}}
