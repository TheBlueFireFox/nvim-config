
" general
set ignorecase
set number
set relativenumber
set nowrap

set scrolloff=8

" handle tabs
set tabstop=4
set softtabstop=4
set expandtab

" bash-like tab completion
set wildmode=longest,list

" syntax hightlighting
syntax on

" enable mouse click
set mouse=a

" fix leader
let mapleader = ","

"" nvim-cmp
set completeopt=menu,menuone,noselect

" force vim to use a single column for both number and error
" hightlighting
set signcolumn=number

" have Vim jump to the last position when reopening a file
" au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

"" Autoformat
" auto format for everything
" au BufWrite * :Autoformat

" Deactivate the fallback autoindent of vim
let g:autoformat_autoindent = 0
let g:autoformat_retab = 0
let g:autoformat_remove_trailing_spaces = 0

" python fix
let g:python3_host_prog="/home/adrian/.pyenv/shims/python3"

"" NERDTree
" Start NERDTree, unless a file or session is specified, eg. vim -S session_file.vim.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') && v:this_session == '' | NERDTree | endif

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

"" theme
" Available values: 'hard', 'medium'(default), 'soft'
let g:gruvbox_material_background = 'hard'

" For better performance
let g:gruvbox_material_better_performance = 1

" set color
colorscheme gruvbox-material

" set up plugings etc.
lua require("config")
