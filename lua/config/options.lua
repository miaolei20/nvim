-- Core Settings
vim.g.loaded_man = 1
vim.g.loaded_man_plugin = 1
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.clipboard = "unnamedplus"
vim.opt.showmode = false
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.shortmess:append("c")
vim.opt.updatetime = 300
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"
vim.opt.confirm = true

-- Auto-save on specific events
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged", "FocusLost" }, {
  pattern = "*",
  callback = function()
    if vim.bo.modified and vim.bo.modifiable then
      vim.cmd("silent! write")
    end
  end,
})

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
  callback = function()
    vim.highlight.on_yank { timeout = 300 }
  end,
})

-- Clipboard integration (WSL-specific)
vim.g.clipboard = {
  name = "win32yank",
  copy = {
    ["+"] = "win32yank.exe -i --crlf",
    ["*"] = "win32yank.exe -i --crlf",
  },
  paste = {
    ["+"] = "win32yank.exe -o --lf",
    ["*"] = "win32yank.exe -o --lf",
  },
  cache_enabled = 0,
}

-- Compile and Run
local function compile_and_run()
  if vim.bo.modified then pcall(vim.cmd.write) end

  local file_path = vim.fn.expand("%:p")
  local file_name = vim.fn.fnamemodify(file_path, ":t")
  local file_base = vim.fn.fnamemodify(file_path, ":t:r")
  local ext = vim.fn.fnamemodify(file_path, ":e"):lower()
  local dir = vim.fn.fnamemodify(file_path, ":p:h")

  local runners = {
    c = { cmd = "gcc", args = '"%s" -o "%s" && "./%s"', output = file_base },
    cpp = { cmd = "g++", args = '"%s" -o "%s" && "./%s"', output = file_base },
    py = { cmd = "python3", args = '"%s"' },
  }

  local runner = runners[ext]
  if not runner then
    print("[Error] Unsupported file: " .. file_name)
    return
  end

  local cmd = string.format(
    'cd "%s" && %s %s',
    dir,
    runner.cmd,
    string.format(runner.args, file_name, runner.output or "", runner.output or "")
  )

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = 85,
    height = 15,
    col = (vim.o.columns - 85) / 2,
    row = (vim.o.lines - 15) / 2,
    style = "minimal",
    border = "rounded",
  })

  vim.fn.termopen(cmd, {
    on_exit = function(_, code)
      if code ~= 0 then
        vim.api.nvim_buf_set_lines(buf, -1, -1, true, { "[Error] Exit code: " .. code })
      end
    end,
  })
  vim.cmd.startinsert()
end

vim.api.nvim_create_user_command("RunCode", compile_and_run, { desc = "Run current file" })
vim.keymap.set("n", "<F5>", ":RunCode<CR>", { silent = true, desc = "Run Code" })

-- Open URL
vim.api.nvim_create_user_command("OpenURL", function(opts)
  local url = opts.args
  if url == "" then
    local line = vim.api.nvim_get_current_line()
    local url_pattern = "https?://[%w-_%.%?%#%=%&%/]+"
    url = line:match(url_pattern) or vim.fn.expand("<cWORD>"):match(url_pattern) or "https://www.google.com"
  end
  vim.fn.jobstart({ "/mnt/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe", url }, { detach = true })
end, { nargs = "?" })
