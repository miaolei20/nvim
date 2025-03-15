return {
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    cmd = { "NvimTreeToggle", "NvimTreeOpen" },
    keys = {
      { "<C-b>", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file tree" },
      { "<leader>e", "<cmd>NvimTreeFocus<CR>", desc = "Focus file tree" },
      { "<leader>r", "<cmd>NvimTreeFindFile<CR>", desc = "Reveal current file" },
    },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      config = function()
        require("nvim-web-devicons").setup({
          override = { txt = { icon = " ", color = "#428850" } },
        })
      end,
    },
    config = function()
      -- 禁用 netrw
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      local api = require("nvim-tree.api")

      -- 精简按键映射
      local function on_attach(bufnr)
        local mappings = {
          { "n", "<CR>", api.node.open.edit, "Open" },
          { "n", "o", api.node.open.edit, "Open" },
          { "n", "<C-v>", api.node.open.vertical, "Open Vertical" },
          { "n", "<C-s>", api.node.open.horizontal, "Open Horizontal" },
          { "n", "a", api.fs.create, "Create" },
          { "n", "d", api.fs.trash, "Trash" },
          { "n", "r", api.fs.rename, "Rename" },
          { "n", "R", api.tree.reload, "Refresh" },
          { "n", "y", api.fs.copy.absolute_path, "Copy Path" },
          { "n", "q", api.tree.close, "Close" },
        }
        for _, map in ipairs(mappings) do
          vim.keymap.set(map[1], map[2], map[3], {
            buffer = bufnr,
            noremap = true,
            silent = true,
            desc = "NvimTree: " .. map[4],
          })
        end
      end

      -- NvimTree 配置
      require("nvim-tree").setup({
        on_attach = on_attach,
        hijack_cursor = true,
        sync_root_with_cwd = true,
        update_focused_file = { enable = true, update_root = true },
        view = {
          adaptive_size = true,
          width = { min = 30, max = 50 },
          side = "left",
          number = false,
          relativenumber = false,
        },
        renderer = {
          indent_width = 2,
          indent_markers = { enable = true },
          icons = {
            glyphs = {
              default = "",
              symlink = "",
              folder = {
                arrow_closed = "",
                arrow_open = "",
                default = "",
                open = "",
              },
              git = { unstaged = "✗", staged = "✓", untracked = "★" },
            },
          },
          highlight_git = true,
          group_empty = true,
        },
        diagnostics = {
          enable = true,
          severity = { min = vim.diagnostic.severity.HINT },
          icons = { error = "" },
        },
        filters = {
          custom = { "^.git$", "^node_modules$" },
          exclude = { ".env" },
        },
        actions = {
          open_file = { quit_on_open = false, window_picker = { enable = true } },
        },
        git = { enable = true, timeout = 200, ignore = false },
        filesystem_watchers = {
          enable = true,
          debounce_delay = 500,
          ignore_dirs = { "node_modules" },
        },
        trash = { cmd = "gio trash", require_confirm = true },
      })

      -- 窗口关闭策略
      vim.api.nvim_create_autocmd("BufEnter", {
        nested = true,
        callback = function()
          if #vim.api.nvim_list_wins() == 1 and vim.bo.ft == "NvimTree" then
            vim.cmd("quit")
          end
        end,
      })
    end,
  },
}