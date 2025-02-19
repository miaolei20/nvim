return {
    "mistricky/codesnap.nvim",
    build = "make build_generator",
    cmd = "CodeSnap",
    keys = {
        -- 正确映射 Visual 模式需要特殊处理选区范围 --
        { "<leader>cs", ":<C-u>'<,'>CodeSnapSave<CR>", mode = "v", desc = "保存选中代码快照" }, -- 增加范围处理
        { "<leader>ch", ":<C-u>'<,'>CodeSnapSaveHighlight<cr>", mode = "v", desc = "高亮代码快照" }
    },
    config = function()
        require("codesnap").setup {
            save_path = "/mnt/c/Users/ml200/Pictures/CodeSnaps/",
            file_extension = "png",
            code_font_family = "JetBrainsMono Nerd Font",              -- 主字体
            watermark_font_family = "JetBrainsMono Nerd Font Propo", -- 水印/图标字体
            code_font_size = 16,
            line_height = 1.4,
            code_font_fallback = { -- 字体回退链
                "Sarasa Term SC",
                "Microsoft YaHei",
                "Noto Sans CJK SC"
            },
            has_breadcrumbs = true,
            has_line_number = true,
            watermark = "",
            bg_color = "#535c68",
            bg_padding = 0,
            prefix = "📸 ",
             -- 关键修复配置 新增以下设置 --
            has_highlight = true,         -- 启用高亮识别
            highlight_group = "IncSearch",-- 指定有效的高亮组
            highlight_options = {         -- 添加高亮渲染参数
            delay = 100,
            timeout = 1000
        },
            -- prompt = "Enter a name for the snapshot: ",
            -- file_path = "~/Desktop/",
            -- file_name = nil,
            -- highlight = "Visual",
            -- highlight_group = "Visual",
            -- highlight_file = nil,
            -- highlight_format = "png",
            -- highlight_options = {},
            -- silent = false,       
        }
    end,
}
