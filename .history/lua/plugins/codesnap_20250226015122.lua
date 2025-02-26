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
        
        -- 混合剪贴板方案 ------------------------
        -- 方案A：win32yank直接复制文件内容
        local cmd_yank = "cat " .. vim.fn.shellescape(filepath) .. " | win32yank.exe -i --image"
        -- 方案B：PowerShell图像复制
        local ps_script = string.format([[
          Add-Type -AssemblyName System.Windows.Forms
          $img = [Drawing.Image]::FromFile('%s')
          [Windows.Forms.Clipboard]::SetImage($img)
          $img.Dispose()
        ]], filepath:gsub("/mnt/c/", "C:\\"):gsub("/", "\\"))
        
        -- 执行双方案确保成功
        vim.fn.jobstart(cmd_yank, { 
          detach = true,
          on_exit = function(_, code, _)
            if code ~= 0 then
              print("[方案A失败] 退出码:", code)
              vim.fn.jobstart("powershell.exe -Command " .. vim.fn.shellescape(ps_script), {
                detach = true,
                on_exit = function(_, ps_code, _)
                  print("[方案B退出码]", ps_code)
                end
              })
            end
          end
        })
      end
    }
  end
}