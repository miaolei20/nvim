local M = {}

M.opts = {
  preset = "modern",
  delay = 300,
  win = {
    border = "rounded",
    padding = { 1, 2 },
    height = { min = 4, max = 25 },
    width = { min = 20, max = 50 },
    title = true,
    title_pos = "center",
  },
  icons = {
    breadcrumb = "»",
    separator = "→",
    group = "+",
    mappings = false,
  },
  layout = {
    align = "center",
    spacing = 4,
  },
  show_help = true,
  show_keys = true,
  triggers = {
    { "<leader>", mode = { "n", "v" } },
    { "<localleader>", mode = { "n", "v" } },
    { "g", mode = { "n", "v" } },
    { "z", mode = "n" },
    { "[", mode = "n" },
    { "]", mode = "n" },
    { "<C-w>", mode = "n" },
    { "<M>", mode = "n" },
  },
}

function M.setup(opts)
  vim.o.timeout = true
  vim.o.timeoutlen = 300
  local wk = require("which-key")
  wk.setup(opts)

  -- Neo-Tree 全局映射
  wk.add({
    { "<leader>e", group = "Explorer", icon = "󰉓" },
    { "<leader>ee", "<cmd>Neotree toggle left<CR>", desc = "切换资源管理器", icon = "󰐿", mode = "n" },
    { "<leader>ef", "<cmd>Neotree focus left<CR>", desc = "聚焦资源管理器", icon = "󰋱", mode = "n" },
    { "<leader>eg", "<cmd>Neotree git_status left<CR>", desc = "Git 状态", icon = "󰜘", mode = "n" },
    { "<leader>eb", "<cmd>Neotree buffers left<CR>", desc = "缓冲区列表", icon = "󰈤", mode = "n" },
  })

  -- Neo-Tree 缓冲区本地映射
  wk.add({
    {
      "<space>",
      "toggle_node",
      desc = "切换节点",
      icon = "󰁙",
      mode = "n",
      cond = function()
        return vim.bo.filetype == "neo-tree"
      end,
    },
    {
      "<cr>",
      "open",
      desc = "打开",
      icon = "󰌑",
      mode = "n",
      cond = function()
        return vim.bo.filetype == "neo-tree"
      end,
    },
    {
      "<tab>",
      "open_with_window_picker",
      desc = "在窗口中打开",
      icon = "󱂬",
      mode = "n",
      cond = function()
        return vim.bo.filetype == "neo-tree"
      end,
    },
    {
      "P",
      "toggle_preview",
      desc = "切换预览",
      icon = "󰋲",
      mode = "n",
      cond = function()
        return vim.bo.filetype == "neo-tree"
      end,
    },
    {
      "a",
      "add",
      desc = "添加文件",
      icon = "󰝒",
      mode = "n",
      cond = function()
        return vim.bo.filetype == "neo-tree"
      end,
    },
    {
      "A",
      "add_directory",
      desc = "添加目录",
      icon = "󰉌",
      mode = "n",
      cond = function()
      return vim.bo.filetype == "neo-tree"
    end,
  },
  {
    "d",
    "delete",
    desc = "删除",
    icon = "󰅖",
    mode = "n",
    cond = function()
      return vim.bo.filetype == "neo-tree"
    end,
  },
  {
    "r",
    "rename",
    desc = "重命名",
    icon = "󰑕",
    mode = "n",
    cond = function()
      return vim.bo.filetype == "neo-tree"
    end,
  },
  {
    "y",
    "copy_to_clipboard",
    desc = "复制到剪贴板",
    icon = "󰅍",
    mode = "n",
    cond = function()
      return vim.bo.filetype == "neo-tree"
    end,
  },
  {
    "x",
    "cut_to_clipboard",
    desc = "剪切到剪贴板",
    icon = "󰆐",
    mode = "n",
    cond = function()
      return vim.bo.filetype == "neo-tree"
    end,
  },
  {
    "p",
    "paste_from_clipboard",
    desc = "从剪贴板粘贴",
    icon = "󰆒",
    mode = "n",
    cond = function()
      return vim.bo.filetype == "neo-tree"
    end,
  },
  {
    "c",
    "copy",
    desc = "复制文件",
    icon = "󰉍",
    mode = "n",
    cond = function()
      return vim.bo.filetype == "neo-tree"
    end,
  },
  {
    "m",
    "move",
    desc = "移动文件",
    icon = "󰹑",
    mode = "n",
    cond = function()
      return vim.bo.filetype == "neo-tree"
    end,
  },
  {
    "q",
    "close_window",
    desc = "关闭资源管理器",
    icon = "󰅘",
    mode = "n",
    cond = function()
      return vim.bo.filetype == "neo-tree"
    end,
  },
  {
    "R",
    "refresh",
    desc = "刷新",
    icon = "󰑐",
    mode = "n",
    cond = function()
      return vim.bo.filetype == "neo-tree"
    end,
  },
  {
    "?",
    "show_help",
    desc = "显示帮助",
    icon = "󰋖",
    mode = "n",
    cond = function()
      return vim.bo.filetype == "neo-tree"
    end,
  },
  {
    "H",
    "toggle_hidden",
    desc = "切换隐藏文件",
    icon = "󰘓",
    mode = "n",
    cond = function()
      return vim.bo.filetype == "neo-tree"
    end,
  },
})
end

return M