return {
  {
    "folke/persistence.nvim",  -- 主插件
    event = "BufReadPre",  -- 在读取缓冲区之前加载插件
    config = function()
      local persistence = require("persistence")
      
      -- 初始化插件配置（即使使用默认参数也推荐显式调用）
      persistence.setup({
        -- 可在此添加自定义配置（例如：目录白名单/黑名单）
        -- dir = vim.fn.expand(vim.fn.getcwd() .. "/.nvim/"),
      })

      -- 定义带安全检查和确认提示的辅助函数
      local function safe_load(conf)
        if vim.fn.argc() == 0 then  -- 只在没有文件参数时加载会话
          if vim.fn.confirm("Load session? Unsaved changes may be lost!", "&Yes\n&No", 2) == 1 then
            persistence.load(conf)
          end
        end
      end

      -- 会话管理快捷键（添加描述元数据方便 which-key 等插件识别）
      vim.keymap.set("n", "<leader>qs", function()
        safe_load()  -- 带确认提示的加载
      end, { desc = "[S]ession load current" })

      vim.keymap.set("n", "<leader>qS", function()
        persistence.select()  -- 交互式选择会话
      end, { desc = "[S]ession select" })

      vim.keymap.set("n", "<leader>ql", function()
        safe_load({ last = true })  -- 加载最后一次会话
      end, { desc = "[S]ession load [L]ast" })

      vim.keymap.set("n", "<leader>qd", function()
        persistence.stop()  -- 禁用自动保存
        vim.notify("Session autosaving disabled", vim.log.levels.INFO)
      end, { desc = "[S]ession [D]isable" })

      -- 添加自动保存提示（适配退出事件）
      vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
          if persistence then
            persistence.save()
            vim.notify("Session automatically saved", vim.log.levels.INFO)
          end
        end
      })
    end
  },
}
