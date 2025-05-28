-- 全局设置
vim.g.mapleader = " "         -- 设置 leader 键为空格
vim.g.maplocalleader = "\\"   -- 设置本地 leader 键为反斜杠
vim.g.python3_host_prog = vim.fn.executable("/usr/bin/python3") and "/usr/bin/python3" or nil

-- 加载核心配置并处理错误
for _, module in ipairs({ "config.options", "config.keymaps" }) do
    local ok, err = pcall(require, module)
    if not ok then
        vim.notify(string.format("无法加载 %s: %s", module, err), vim.log.levels.WARN)
    end
end

-- 安装 lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local out = vim.fn.system({
        "git", "clone", "--filter=blob:none", "--branch=stable",
        "https://github.com/folke/lazy.nvim.git", lazypath
    })
    if vim.v.shell_error ~= 0 then
        vim.notify("无法克隆 lazy.nvim:\n" .. out, vim.log.levels.ERROR)
        vim.fn.input("按回车退出...")
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- 设置 lazy.nvim
require("lazy").setup({
    spec = {
        { import = "plugins.UI.theme" },
        { import = "plugins.UI.heirline" },
        { import = "plugins.UI.alpha" },
        { import = "plugins.UI.neotree" },
        { import = "plugins.UI.rainbow" },
        { import = "plugins.UI.aerial" },
        { import = "plugins.UI.indent" },
        { import = "plugins.editor.treesitter" },
        { import = "plugins.editor.treesitter-context" },
        { import = "plugins.editor.cmp" },
        { import = "plugins.editor.comment" },
        { import = "plugins.editor.gitsigns" },
        { import = "plugins.editor.hlslens" },
        { import = "plugins.editor.avante"},
        { import = "plugins.editor.visual-multi" },
        { import = "plugins.lsp.mason" },
        { import = "plugins.lsp.lsp" },
        { import = "plugins.tools.formatter" },
        { import = "plugins.editor.lint" },
        { import = "plugins.tools.telescope" },
        { import = "plugins.tools.harpoon" },
        { import = "plugins.tools.lazygit" },
        { import = "plugins.tools.lastplace" },
        { import = "plugins.tools.leetcode" },
    },
    install = {
        colorscheme = {
            "onedark", "catppuccin", "catppuccin-latte",
            "tokyonight", "gruvbox", "habamax"
        }
    },
    checker = {
        enabled = true,
        notify = false,
        frequency = 259200, -- 每3天检查更新
    },
    performance = {
        cache = { enabled = true },
        reset_packpath = false,
        rtp = {
            disabled_plugins = {
                "gzip", "matchit", "matchparen", "netrw", "netrwPlugin",
                "tarPlugin", "tohtml", "tutor", "zipPlugin", "rplugin",
                "editorconfig", "spellfile"
            }
        }
    },
    ui = {
        border = "rounded",
        title = "Lazy",
        pills = true
    },
    diff = { cmd = "diffview.nvim" },
    profiling = {
        loader = false,
        require = false
    }
})

-- 读取保存的主题
local selected_theme_file = vim.fn.stdpath("config") .. "/selected_theme.txt"
local default_theme = "colorscheme onedark"
if vim.fn.filereadable(selected_theme_file) == 1 then
    local success, lines_or_err = pcall(vim.fn.readfile, selected_theme_file)
    if not success then
        vim.notify("读取主题文件失败: " .. tostring(lines_or_err), vim.log.levels.ERROR)
        vim.cmd(default_theme)
    else
        local cmd = lines_or_err[1] or ""
        -- 更新正则以支持包含连字符的主题名
        if cmd:match("^colorscheme [%w%-]+$") then
            local ok, apply_err = pcall(vim.cmd, cmd)
            if not ok then
                vim.notify("应用主题失败: " .. tostring(apply_err), vim.log.levels.ERROR)
                vim.cmd(default_theme)
            end
        else
            vim.notify("无效的主题命令: " .. cmd, vim.log.levels.WARN)
            vim.cmd(default_theme)
        end
    end
else
    vim.cmd(default_theme)
end

