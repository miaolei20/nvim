return {
  {
    "nvim-tree/nvim-tree.lua",                  -- 主插件
    cmd = { "NvimTreeToggle", "NvimTreeOpen" }, -- 命令名称
    keys = { "<F3>" },                          -- 快捷键
    dependencies = {
      "nvim-tree/nvim-web-devicons",            -- 图标插件
    },
    keys = {
      { "<F3>", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file tree" }, -- 显式声明快捷键
    },
    config = function()
      vim.g.loaded_netrw = 1       -- 禁用 netrw
      vim.g.loaded_netrwPlugin = 1 -- 禁用 netrw 插件

      require("nvim-tree").setup({
        view = {
          width = 30,                  -- 文件树宽度
          side = "left",               -- 文件树位置
          number = false,              -- 不显示行号
          relativenumber = false,      -- 不显示相对行号
          signcolumn = "yes",          -- 显示符号列
          float = {                    -- LazyVim 风格浮动配置
            enable = false,            -- 禁用浮动窗口
            quit_on_focus_loss = true, -- 失去焦点时关闭浮动窗口
            open_win_config = {
              width = 40,              -- 浮动窗口宽度
              height = 30,             -- 浮动窗口高度
              col = 1,                 -- 浮动窗口列位置
              row = 1,                 -- 浮动窗口行位置
            },
          },
        },
        renderer = {
          indent_markers = {
            enable = true, -- 启用缩进标记
          },
          icons = {
            git_placement = "after", -- Git 图标位置
            show = {
              folder_arrow = false,  -- 不显示文件夹箭头
            },
            glyphs = {
              folder = {
                arrow_closed = "▶", -- 关闭文件夹箭头图标
                arrow_open = "▼", -- 打开文件夹箭头图标
              },
            },
          },
          highlight_git = true, -- 高亮 Git 状态
          group_empty = true,   -- 分组显示空文件夹
        },
        actions = {
          open_file = {
            quit_on_open = true, -- 打开文件后关闭文件树
            window_picker = {
              enable = false,    -- 禁用窗口选择器
            },
          },
          change_dir = {
            enable = false, -- 禁用目录切换
          },
        },
        update_focused_file = {
          enable = true,       -- 自动聚焦当前文件
          update_root = false, -- 不更新根目录
        },
        git = {
          enable = true, -- 启用 Git 集成
          ignore = false, -- 不忽略 Git 忽略的文件
          timeout = 200, -- Git 操作超时时间
        },
        diagnostics = { -- 诊断集成
          enable = true, -- 启用诊断
          show_on_dirs = false, -- 不在目录上显示诊断
          icons = {
            hint = "󰌵", -- 提示图标
            info = "", -- 信息图标
            warning = "", -- 警告图标
            error = "", -- 错误图标
          },
        },
      })

      -- 增强版快捷键 (LazyVim 风格)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "NvimTree",
        callback = function()
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = true, desc = desc })
          end
          map("n", "l", "<CR>", "Open")                    -- l 键打开文件
          map("n", "h", "-", "Collapse")                   -- h 键折叠文件夹
          map("n", "q", "<cmd>NvimTreeClose<CR>", "Close") -- q 键关闭文件树
        end
      })
    end
  }
}

