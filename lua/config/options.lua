-- Core Settings
vim.g.loaded_man = 1 -- Disable man.vim plugin
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

-- Debug logging (conditional)
local function debug_log(msg)
  if vim.g.debug_settings then
    vim.notify("[Settings] " .. msg, vim.log.levels.DEBUG)
  end
end

-- Setup Autocommands
local function setup_autocommands()
  debug_log("Setting up autocommands")

  -- Auto-save on specific events, exclude special buffers
  vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged", "FocusLost" }, {
    pattern = "*",
    callback = function()
      if vim.bo.modified and vim.bo.modifiable and not vim.bo.buftype:match("^(nofile|terminal|prompt)$") then
        pcall(vim.cmd.write)
      end
    end,
    desc = "Auto-save on buffer changes",
  })

  -- Highlight yanked text
  vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
    callback = function()
      vim.highlight.on_yank { timeout = 300 }
    end,
    desc = "Highlight yanked text",
  })
end

-- Clipboard integration (WSL-specific)
local function setup_clipboard()
  if vim.fn.has("wsl") == 1 then
    debug_log("Setting up WSL clipboard integration")
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
  end
end

-- Compile and Run
local function compile_and_run()
  -- Save if modified
  if vim.bo.modified then
    pcall(vim.cmd.write)
  end

  local file = {
    path = vim.fn.expand("%:p"),
    name = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":t"),
    base = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":t:r"),
    ext = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":e"):lower(),
    dir = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":p:h"),
  }

  -- Supported runners
  local runners = {
    c = { cmd = "gcc", args = { file.name, "-o", file.base }, run = "./" .. file.base },
    cpp = { cmd = "g++", args = { file.name, "-o", file.base }, run = "./" .. file.base },
    py = { cmd = "python3", args = { file.name } },
    java = { cmd = "javac", args = { file.name }, run = "java " .. file.base },
    go = { cmd = "go", args = { "run", file.name } },
  }

  local runner = runners[file.ext]
  if not runner then
    vim.notify("[Error] Unsupported file type: " .. file.ext, vim.log.levels.ERROR)
    return
  end

  -- Construct command
  local cmd_parts = { "cd", vim.fn.shellescape(file.dir), "&&", runner.cmd }
  vim.list_extend(cmd_parts, runner.args)
  if runner.run then
    vim.list_extend(cmd_parts, { "&&", runner.run })
  end
  local cmd = table.concat(cmd_parts, " ")

  -- Create floating window
  local width = math.min(85, math.floor(vim.o.columns * 0.8))
  local height = math.min(15, math.floor(vim.o.lines * 0.4))
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = (vim.o.columns - width) / 2,
    row = (vim.o.lines - height) / 2,
    style = "minimal",
    border = "rounded",
  })

  -- Run command in terminal
  vim.fn.termopen(cmd, {
    on_exit = function(_, code)
      if code ~= 0 then
        vim.api.nvim_buf_set_lines(buf, -1, -1, true, { "[Error] Exit code: " .. code })
      end
      vim.api.nvim_buf_set_option(buf, "modifiable", false)
    end,
  })
  vim.cmd.startinsert()
end

-- Open URL (cross-platform)
local function open_url(opts)
  local url = opts.args
  if url == "" then
    local line = vim.api.nvim_get_current_line()
    local url_pattern = "https?://[%w-_%.%?%#%=%&%/]+"
    url = line:match(url_pattern) or vim.fn.expand("<cWORD>"):match(url_pattern) or "https://www.google.com"
  end

  -- Determine opener based on platform
  local opener
  if vim.fn.has("wsl") == 1 then
    opener = { "/mnt/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe", url }
  elseif vim.fn.has("mac") == 1 then
    opener = { "open", url }
  else -- Assume Linux
    opener = { "xdg-open", url }
  end

  local job = vim.fn.jobstart(opener, { detach = true })
  if job <= 0 then
    vim.notify("[Error] Failed to open URL: " .. url, vim.log.levels.ERROR)
  else
    debug_log("Opened URL: " .. url)
  end
end

-- Setup Commands and Keymaps
local function setup_commands()
  debug_log("Setting up commands and keymaps")

  vim.api.nvim_create_user_command("RunCode", compile_and_run, { desc = "Run current file" })
  vim.keymap.set("n", "<F5>", ":RunCode<CR>", { silent = true, desc = "Run Code" })

  vim.api.nvim_create_user_command("OpenURL", open_url, { nargs = "?", desc = "Open URL in browser" })
end

-- Initialize
local function init()
  setup_autocommands()
  setup_clipboard()
  setup_commands()
  debug_log("Initialization complete")
end

init()