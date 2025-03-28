return {
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile" },
    keys = {
      { "<C-b>", "<cmd>NvimTreeToggle<CR>", desc = "Toggle File Tree" },
      { "<leader>e", "<cmd>NvimTreeFocus<CR>", desc = "Focus File Tree" },
      { "<leader>r", "<cmd>NvimTreeFindFile<CR>", desc = "Reveal Current File" },
    },
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
    },
    config = function()
      -- 禁用 netrw 以确保 nvim-tree 正常工作
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      local api = require("nvim-tree.api")

      -- 精简 on_attach 函数，仅保留常用映射
      local function on_attach(bufnr)
        local opts = function(desc)
          return { desc = "NvimTree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end
        vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open"))
        vim.keymap.set("n", "o", api.node.open.edit, opts("Open"))
        vim.keymap.set("n", "<C-v>", api.node.open.vertical, opts("Open Vertical"))
        vim.keymap.set("n", "<C-s>", api.node.open.horizontal, opts("Open Horizontal"))
        vim.keymap.set("n", "a", api.fs.create, opts("Create"))
        vim.keymap.set("n", "d", api.fs.trash, opts("Delete"))
        vim.keymap.set("n", "r", api.fs.rename, opts("Rename"))
        vim.keymap.set("n", "R", api.tree.reload, opts("Refresh"))
        vim.keymap.set("n", "y", api.fs.copy.absolute_path, opts("Copy Path"))
        vim.keymap.set("n", "q", api.tree.close, opts("Close"))
      end

      require("nvim-tree").setup({
        on_attach = on_attach,
        hijack_cursor = true,
        update_focused_file = { enable = true, update_root = true },
        view = {
          adaptive_size = true,
          width = { min = 30, max = 50 },
          side = "left",
        },
        renderer = {
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
        filesystem_watchers = { enable = true, debounce_delay = 500, ignore_dirs = { "node_modules" } },
        trash = { cmd = "gio trash", require_confirm = true },
      })
    end,
  },
}
