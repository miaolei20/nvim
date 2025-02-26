return {
  "mistricky/codesnap.nvim", -- 插件名称
  build = "make build_generator", -- 构建插件的命令
  cmd = "CodeSnap", -- 触发插件的命令
  keys = {
    -- 正确映射 Visual 模式需要特殊处理选区范围 --
    { "<leader>cs", ":<C-u>'<,'>CodeSnapSave<CR>", mode = "v", desc = "保存选中代码快照" }, -- 增加范围处理
    { "<leader>ch", ":<C-u>'<,'>CodeSnapSaveHighlight<cr>", mode = "v", desc = "高亮代码快照" }
  },
  config = function()
    require("codesnap").setup {
      save_path = "/mnt/c/Users/ml200/Pictures/CodeSnaps/", -- 快照保存路径
      post_save_cmd = function(filepath)
        vim.fn.jobstart(
          "powershell.exe -Command " .. 
          vim.fn.shellescape(
            [[
              Add-Type -AssemblyName System.Windows.Forms;
              $image = [System.Drawing.Image]::FromFile(']] .. filepath .. [[');
              [System.Windows.Forms.Clipboard]::SetImage($image)
            ]]
          ),
          { detach = true }
        )
      end,
      file_extension = "png", -- 快照文件扩展名
      code_font_family = "JetBrainsMono Nerd Font", -- 主字体
      watermark_font_family = "JetBrainsMono Nerd Font Propo", -- 水印/图标字体
      code_font_size = 16, -- 代码字体大小
      line_height = 1.4, -- 行高
      code_font_fallback = { -- 字体回退链
        "Sarasa Term SC",
        "Microsoft YaHei",
        "Noto Sans CJK SC"
      },
      has_breadcrumbs = true, -- 启用面包屑
      has_line_number = true, -- 启用行号
      watermark = "", -- 水印文本
      bg_color = "#535c68", -- 背景颜色
      bg_padding = 0, -- 背景填充
      prefix = "📸 ", -- 快照前缀
      -- 关键修复配置 新增以下设置 --
      has_highlight = true, -- 启用高亮识别
      highlight_group = "IncSearch", -- 指定有效的高亮组
      highlight_options = { -- 添加高亮渲染参数
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
