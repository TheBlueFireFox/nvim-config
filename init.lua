require('packer').startup(function(use)
        use "rebelot/kanagawa.nvim"
        use 'wbthomason/packer.nvim' -- Package manager
        use {
                'neovim/nvim-lspconfig',
                requires = { '/simrat39/rust-tools.nvim' }
        } -- Collection of configurations for the built-in LSP client
        use 'williamboman/nvim-lsp-installer'
        use 'nvim-lua/lsp-status.nvim'
        use 'preservim/nerdtree'
        use 'Chiel92/vim-autoformat'
        use 'jiangmiao/auto-pairs'
        use {
                'nvim-telescope/telescope.nvim',
                requires = { {'nvim-lua/plenary.nvim'} }
        }
        use {
                'nvim-lualine/lualine.nvim',
                requires = { 'kyazdani42/nvim-web-devicons', opt = true }
        }
        use 'hrsh7th/cmp-nvim-lsp'
        use 'hrsh7th/cmp-buffer'
        use 'hrsh7th/cmp-path'
        use 'hrsh7th/cmp-cmdline'
        use 'hrsh7th/nvim-cmp'
        use 'hrsh7th/cmp-nvim-lsp-signature-help'
        use {
                'L3MON4D3/LuaSnip',
                requires = { 'rafamadriz/friendly-snippets', 'saadparwaiz1/cmp_luasnip', 'onsails/lspkind-nvim', 'ray-x/lsp_signature.nvim' }
        }
end)

vim.cmd([[
" general
set ignorecase
set number
set relativenumber
set nowrap

" disable compability to old-time vi
set nocompatible

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
set mouse=n

" fix leader
let mapleader = ","

" nerdtree shortcut
nmap <leader>ne :NERDTreeFocus<cr>

" TODO: FIX to use lua
" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr

colorscheme kanagawa

" nvim-cmp
set completeopt=menu,menuone,noselect

set signcolumn=number
]])

local lsp_status = require('lsp-status')
-- completion_customize_lsp_label as used in completion-nvim
-- Optional: customize the kind labels used in identifying the current function.
-- g:completion_customize_lsp_label is a dict mapping from LSP symbol kind
-- to the string you want to display as a label
-- lsp_status.config { kind_labels = vim.g.completion_customize_lsp_label }

-- Register the progress handler
lsp_status.register_progress()

local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

        lsp_status.on_attach(client)
end




require('lualine').setup {
        sections = {
                lualine_c = { 'filename', 'require("lsp-status").status()' },
        },
        tabline = {
                lualine_a = {'buffers'},
                lualine_b = {'branch'},
                lualine_c = {'filename'},
                lualine_x = {},
                lualine_y = {},
                lualine_z = {'tabs'}
        },
        extensions = { 'nerdtree' }
}

-- Setup nvim-cmp.
local cmp = require'cmp'

cmp.setup({
        snippet = {
                -- REQUIRED - you must specify a snippet engine
                expand = function(args)
                        -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
                        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
                        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
                end,
        },
        window = {
                -- completion = cmp.config.window.bordered(),
                -- documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        formatting = {
                format = require('lspkind').cmp_format({
                        mode = "symbol_text",
                        menu = ({
                                buffer = "[Buffer]",
                                nvim_lsp = "[LSP]",
                                luasnip = "[LuaSnip]",
                                nvim_lua = "[Lua]",
                                latex_symbols = "[Latex]",
                        })
                }),
        },
        sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                -- { name = 'vsnip' }, -- For vsnip users.
                { name = 'luasnip' }, -- For luasnip users.
                -- { name = 'ultisnips' }, -- For ultisnips users.
                -- { name = 'snippy' }, -- For snippy users.
                { name = 'nvim_lsp_signature_help' } -- For this BS cmp-nvim-lsp-signature-help
        }, {
                { name = 'buffer' },
        })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
        sources = cmp.config.sources({
                { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
        }, {
                { name = 'buffer' },
        })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
                { name = 'buffer' }
        }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
                { name = 'path' }
        }, {
                { name = 'cmdline' }
        })
})

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())


local lsp_installer = require("nvim-lsp-installer")

-- Register a handler that will be called for each installed server when it's ready (i.e. when installation is finished
-- or if the server is already installed).
lsp_installer.on_server_ready(function(server)
        local opts = {
                on_attach = on_attach,
                capabilities = capabilities
        }

        -- (optional) Customize the options passed to the server
        -- if server.name == "tsserver" then
        --     opts.root_dir = function() ... end
        -- end

        -- This setup() function will take the provided server configuration and decorate it with the necessary properties
        -- before passing it onwards to lspconfig.
        -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
        if server.name == "rust_analyzer" then
                -- Initialize the LSP via rust-tools instead
                require("rust-tools").setup {
                        -- The "server" property provided in rust-tools setup function are the
                        -- settings rust-tools will provide to lspconfig during init.            --
                        -- We merge the necessary settings from nvim-lsp-installer (server:get_default_options())
                        -- with the user's own settings (opts).
                        server = vim.tbl_deep_extend("force", server:get_default_options(), opts),
                }
                server:attach_buffers()
                -- Only if standalone support is needed
                require("rust-tools").start_standalone_if_required()
        else
                server:setup(opts)
        end
end)
