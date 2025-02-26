-- ~/.config/nvim/lua/plugins/codesnap.lua
return {
  "mistricky/codesnap.nvim",
  build = "make build_generator",
  cmd = "CodeSnap",
  keys = {
    { "<leader>cs", ":<C-u>'<,'>CodeSnapSave<CR>", mode = "v", desc = "保存代码快照" },
    { "<leader>ch", ":<C-u>'<,'>CodeSnapSaveHighlight<CR>", mode = "v", desc = "高亮快照" }
  },
  config = function()
    require("codesnap").setup {
      -- 基础配置
      save_path = "/mnt/c/Users/ml200/Pictures/CodeSnaps/", -- 替换为你的Windows用户名
      file_extension = "png",
      code_font_family = "JetBrainsMono Nerd Font",
      code_font_size = 16,
      bg_color = "#2e3440", -- 深色背景更清晰
      has_line_number = true,

      -- 关键：截图后自动复制到剪贴板
      post_save_cmd = function(filepath)
        -- 添加延迟确保文件写入完成
        vim.defer_fn(function()
          -- 转换 WSL 路径为 Windows 路径
          local win_path = filepath:gsub("/mnt/c/", "C:\\"):gsub("/", "\\")
          
          -- 构建 PowerShell 命令
          local ps_script = string.format([[
            Add-Type -AssemblyName System.Windows.Forms
            $image = [System.Drawing.Image]::FromFile('%s')
            [System.Windows.Forms.Clipboard]::SetImage($image)
            $image.Dispose()
          ]], win_path)

          -- 执行命令并捕获错误
          local handle = io.popen("powershell.exe -Command " .. vim.fn.shellescape(ps_script) .. " 2>&1")
          local result = handle:read("*a")
          handle:close()

          -- 显示操作结果
          if result:match("Exception") then
            vim.notify("❌ 复制失败: " .. result, vim.log.levels.ERROR)
          else
            vim.notify("✅ 截图已复制到剪贴板！", vim.log.levels.INFO)
          end
        end, 500) -- 延迟 500ms
      end
    }
  end
}