return {
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    cmd = { "NvimTreeToggle", "NvimTreeOpen" },
    keys = {
      { "<C-b>", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file tree" },  -- 改为更符合现代编辑习惯的 Ctrl+b
      { "<leader>e", "<cmd>NvimTreeFocus<CR>", desc = "Focus file tree" },
      { "<leader>r", "<cmd>NvimTreeFindFile<CR>", desc = "Reveal current file" }  -- 改为更易记的 r(reveal)
    },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      config = function()
        require("nvim-web-devicons").setup({
          color_icons = true,
          default = true,
          override = {
            txt = { icon = " ", color = "#428850", name = "Text" },  -- 更美观的文本图标
            lock = { icon = "", color = "#e55f86" },  -- 新增锁文件图标
          }
        })
      end
    },
    config = function()
      -- Disable netrw
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      local function on_attach(bufnr)
        local api = require("nvim-tree.api")
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, {
            buffer = bufnr,
            noremap = true,
            silent = true,
            desc = "NvimTree: " .. desc,
          })
        end

        -- 优化后的快捷键体系
        map("n", "<CR>", api.node.open.edit, "Open")
        map("n", "o", api.node.open.edit, "Open")
        map("n", "<C-v>", api.node.open.vertical, "Open Vertical")
        map("n", "<C-s>", api.node.open.horizontal, "Open Horizontal")
        map("n", "a", api.fs.create, "Create File/Dir")
        map("n", "d", api.fs.trash, "Trash")
        map("n", "r", api.fs.rename, "Rename")  -- 修正为正确的 rename API
        map("n", "R", api.tree.reload, "Refresh")
        map("n", "y", api.fs.copy.absolute_path, "Copy Path")
        map("n", "?", api.tree.toggle_help, "Help")
        map("n", "q", api.tree.close, "Close Tree")
        map("n", "H", api.tree.collapse_all, "Collapse All")
        map("n", "L", api.tree.expand_all, "Expand All")
        map("n", ">", api.node.navigate.sibling.next, "Next Sibling")
        map("n", "<", api.node.navigate.sibling.prev, "Previous Sibling")
      end

      require("nvim-tree").setup({
        on_attach = on_attach,
        sort_by = "case_sensitive",
        sync_root_with_cwd = true,
        hijack_cursor = true,
        update_focused_file = {
          enable = true,
          update_root = true
        },

        view = {
          adaptive_size = true,  -- 自动调整宽度
          width = {
            min = 30,
            max = 50
          },
          side = "left",
          float = {
            enable = false,
            quit_on_focus_loss = true,
          },
          number = false,
          relativenumber = false,
          signcolumn = "yes",
        },

        renderer = {
          indent_width = 2,
          indent_markers = {
            enable = true,
            inline_arrows = true,
            icons = {
              corner = "└",
              edge = "│",
              item = "├",
              none = " ",
            }
          },
          icons = {
            webdev_colors = true,
            git_placement = "after",
            show = {
              git = true,
              folder = true,
              file = true,
              folder_arrow = true,
            },
            glyphs = {
              default = "",
              symlink = "",
              bookmark = "",
              folder = {
                arrow_closed = "",
                arrow_open = "",
                default = "",
                open = "",
                empty = "",
                empty_open = "",
                symlink = "",
                symlink_open = "",
              },
              git = {
                unstaged = "✗",
                staged = "✓",
                unmerged = "",
                renamed = "➜",
                untracked = "★",
                deleted = "",
                ignored = "◌",
              }
            }
          },
          highlight_git = true,
          highlight_opened_files = "name",
          group_empty = true,
        },

        diagnostics = {
          enable = true,
          show_on_dirs = true,
          severity = {
            min = vim.diagnostic.severity.HINT,
            max = vim.diagnostic.severity.ERROR,
          },
          icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",  -- 更醒目的错误图标
          }
        },

        filters = {
          dotfiles = false,
          custom = { "^.git$", "^node_modules$" },
          exclude = { ".env" }  -- 新增排除文件类型
        },

        actions = {
          open_file = {
            quit_on_open = false,  -- 保持树窗口打开
            resize_window = true,
            window_picker = {
              enable = true,
              chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
              exclude = {
                filetype = { "notify", "qf", "diff", "fugitive", "fugitiveblame" },
                buftype = { "nofile", "terminal", "help" },
              }
            }
          },
          remove_file = {
            close_window = false,
          }
        },

        git = {
          enable = true,
          ignore = false,
          show_on_dirs = true,
          timeout = 200,
        },

        filesystem_watchers = {
          enable = true,
          debounce_delay = 150,
          ignore_dirs = { "node_modules", ".git" }
        },

        trash = {
          cmd = "gio trash",  -- 更通用的 Linux 回收站命令
          require_confirm = true,
        }
      })

      -- 智能窗口关闭策略（仅当树窗口是最后一个时退出）
      vim.api.nvim_create_autocmd("BufEnter", {
        nested = true,
        callback = function()
          if #vim.api.nvim_list_wins() == 1 and vim.bo[vim.api.nvim_get_current_buf()].filetype == "NvimTree" then
            vim.cmd "quit"
          end
        end
      })
    end
  }
}
