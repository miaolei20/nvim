return {
    "mistricky/codesnap.nvim",
    build = "make build_generator",
    -- opts = {
    -- },
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
            -- prompt = "Enter a name for the snapshot: ",
            -- file_path = "~/Desktop/",
            -- file_name = nil,
            -- highlight = "Visual",
            -- highlight_group = "Visual",
            -- highlight_file = nil,
            -- highlight_format = "png",
            -- highlight_options = {},
            -- silent = false,
            -- callback = nil,
            
        }
    end,
}
