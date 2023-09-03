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

--  nvim-cmp
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- force vim to use a single column for both number and error hightlighting
vim.opt.signcolumn = "number"

-- Disable virtual_text since it's redundant due to lsp_lines.
vim.diagnostic.config({
    virtual_text = false,
})
-- change diagnostics error prefix symbol
vim.diagnostic.config({
    virtual_text = {
        -- prefix = "◯ ",
    },
})

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- allow for clipboard support on wsl
-- TODO: change to lua
if require("core.utils").is_wsl then
    vim.cmd([[
   " WSL yank support
    set clipboard+=unnamedplus
    let g:clipboard = {
          \   'name': 'win32yank-wsl',
          \   'copy': {
          \      '+': 'win32yank.exe -i --crlf',
          \      '*': 'win32yank.exe -i --crlf',
          \    },
          \   'paste': {
          \      '+': 'win32yank.exe -o --lf',
          \      '*': 'win32yank.exe -o --lf',
          \   },
          \   'cache_enabled': 0,
          \ }
   " get browser working
   let g:netrw_browsex_viewer="cmd.exe /C start"
   ]])
end
