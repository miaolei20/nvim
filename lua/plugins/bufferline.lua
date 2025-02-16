-- file: plugins/bufferline.lua
return {
    {
        "akinsho/bufferline.nvim",                                       -- 插件名称
        event = "VeryLazy",                                              -- 延迟加载插件
        dependencies = { "nvim-web-devicons" },                          -- 依赖的插件
        keys = {
            { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" }, -- Shift+h 切换到上一个缓冲区
            { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" }, -- Shift+l 切换到下一个缓冲区
        },
        config = function()
            local colors = require("onedark.palette").dark -- 获取配色方案

            -- 基础保障配置
            vim.opt.termguicolors = true -- 启用终端真彩色
            vim.opt.showtabline = 2 -- 始终显示标签栏

            require("bufferline").setup({
                options = {
                    mode = "buffers", -- 模式设置为缓冲区
                    numbers = "none", -- 不显示缓冲区编号
                    close_command = "bdelete! %d", -- 关闭缓冲区的命令
                    offsets = { {
                        filetype = "NvimTree", -- 针对 NvimTree 文件类型的偏移设置
                        text = "  Explorer ", -- 显示的文本
                        highlight = "Comment", -- 高亮组
                        text_align = "left", -- 文本对齐方式
                        padding = 1 -- 填充
                    } },
                    separator_style = "thin", -- 分隔符样式
                    always_show_bufferline = true, -- 始终显示缓冲区线
                    show_buffer_close_icons = false, -- 不显示缓冲区关闭图标
                    show_close_icon = false, -- 不显示关闭图标
                    diagnostics = "nvim_lsp", -- 启用 LSP 诊断
                    diagnostics_indicator = function(_, _, diag)
                        return (diag.error and " " or "") .. (diag.warning and " " or "") -- 显示诊断图标
                    end,
                    custom_areas = {
                        right = function()
                            return {
                                {
                                    text = " 󰍛 " .. vim.fn.system("free -h | grep Mem | awk '{print $3}'"):gsub("\n", ""), -- 显示已使用内存
                                    highlight = "WarningMsg"
                                }

                            }
                        end
                    }
                },
                highlights = {
                    fill = { bg = colors.bg0 }, -- 填充背景颜色
                    background = {
                        bg = colors.bg0,
                        fg = colors.gray
                    },
                    buffer_selected = {
                        bg = colors.bg0,
                        fg = colors.fg,
                        bold = true,
                        italic = false
                    },
                    modified = {
                        fg = colors.green,
                        bg = colors.bg0
                    },
                    diagnostic = {
                        fg = colors.yellow,
                        bg = colors.bg0
                    }
                }
            })

            -- 强制刷新保障
            vim.api.nvim_create_autocmd("VimEnter", {
                callback = function()
                    vim.schedule(function()
                        require("bufferline").refresh() -- 刷新 bufferline
                    end)
                end
            })
        end
    }
}
