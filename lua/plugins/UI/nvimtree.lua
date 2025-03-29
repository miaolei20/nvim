return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<C-b>", "<cmd>NvimTreeToggle<CR>", desc = "Toggle File Tree" },
    { "<leader>e", "<cmd>NvimTreeFocus<CR>", desc = "Focus File Tree" },
    { "<leader>r", "<cmd>NvimTreeFindFile<CR>", desc = "Reveal File" },
  },
  cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile" },
  init = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
  end,
  opts = {
    hijack_cursor = true,
    sync_root_with_cwd = true,
    update_focused_file = { enable = true, update_root = true },
    view = { width = 32, side = "left" },
    renderer = {
      indent_width = 2,
      indent_markers = { enable = true },
      icons = {
        glyphs = {
          default = "󰈚",
          symlink = "󰌹",
          folder = { default = "", open = "", arrow_closed = "", arrow_open = "" },
          git = { unstaged = "", staged = "󰄬", untracked = "󰐕" },
        },
      },
    },
    diagnostics = { enable = true, icons = { error = "", warning = "", info = "" } },
    filters = { custom = { "^.git$" } },
    git = { enable = true, ignore = false },
    actions = { open_file = { quit_on_open = true } },
  },
  config = function(_, opts)
    require("nvim-tree").setup(opts)

    -- Dynamically adjust the width of the NvimTree window
    vim.api.nvim_create_autocmd("WinEnter", {
      callback = function()
        if vim.bo.filetype == "NvimTree" then
          local new_width = math.max(30, math.min(40, math.floor(vim.o.columns / 4)))
          vim.api.nvim_win_set_width(0, new_width)
        end
      end,
    })

    -- Ensure NvimTree closes properly when it's the last window
    vim.api.nvim_create_autocmd("QuitPre", {
      callback = function()
        local tree_wins = {}
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "NvimTree" then
            table.insert(tree_wins, win)
          end
        end
        if #tree_wins == 1 and #vim.api.nvim_list_wins() == 1 then
          vim.cmd("quit")
        end
      end,
    })
  end,
}