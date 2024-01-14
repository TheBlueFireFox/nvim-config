---- General configuration
-- general
vim.opt.ignorecase = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.scrolloff = 8

-- bash-like tab completion
vim.opt.wildmode = { "longest", "list" }

-- handle tabs
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.magic = true

-- enable mouse click and scrolling
vim.opt.mouse = "a"

-- fix leader
vim.g.mapleader = ","

-- force vim to use a single column for both number and error hightlighting
vim.opt.signcolumn = "number"

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- allow for clipboard support on wsl
if require("core.utils").is_wsl then
    -- WSL yank support
    vim.opt.clipboard:append { 'unnamed', 'unnamedplus' }
    vim.g.clipboard = {
        name = 'win32yank-wsl',
        copy = {
            ['+'] = 'win32yank.exe -i --crlf',
            ['*'] = 'win32yank.exe -i --crlf',
        },
        paste = {
            ["+"] = 'win32yank.exe -o --lf',
            ["*"] = 'win32yank.exe -o --lf',
        },
        cache_enabled = 0,
    }
    -- get browser working
    vim.g.netrw_browsex_viewer = "cmd.exe /C start"
end
