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
      -- 核心配置 --------------------------------
      save_path = "/mnt/c/Users/ml200/Pictures/CodeSnaps/", -- 严格匹配Windows路径
      file_extension = "png",
      code_font_family = "JetBrainsMono NF",
      code_font_size = 18,
      bg_color = "#1e1e2e",  -- 深色背景优化显示
      bg_padding = 20,
      
      -- 调试增强配置 ----------------------------
      post_save_cmd = function(filepath)
        -- 调试输出原始路径
        print("[DEBUG] Original path:", filepath)
        
        -- 双重路径验证
        local wsl_test_cmd = "ls -l " .. vim.fn.shellescape(filepath)
        local win_test_cmd = "powershell.exe Test-Path -Path '" .. filepath:gsub("/mnt/c/", "C:\\"):gsub("/", "\\") .. "'"
        
        vim.fn.jobstart(wsl_test_cmd, {
          on_stdout = function(_, data, _)
            print("[WSL路径验证]", vim.inspect(data))
          end
        })
        
        vim.fn.jobstart(win_test_cmd, {
          on_stdout = function(_, data, _)
            print("[Windows路径验证]", vim.inspect(data))
          end
        })
        
        -- 方案C：xclip备用方案
vim.defer_fn(function()
  vim.fn.jobstart(
    "xclip -selection clipboard -t image/png -i " .. vim.fn.shellescape(filepath),
    { detach = true }
  )
end, 1000)  -- 延迟1秒执行
      end
    }
  end
}