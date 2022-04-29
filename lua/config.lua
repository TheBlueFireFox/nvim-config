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

---- theme
-- Available values: 'material', 'mix', 'original'
vim.g.gruvbox_material_palette = "material"

-- Available values: 'hard', 'medium'(default), 'soft'
vim.g.gruvbox_material_background = "hard"

-- " For better performance
vim.g.gruvbox_material_better_performance = 1

-- Example config in Lua
vim.g.tokyonight_style = "night"

-- set color
-- vim.cmd("colorscheme gruvbox-material")
vim.cmd("colorscheme tokyonight")

-- Other configurations
vim.cmd([[ 
" have Vim jump to the last position when reopening a file
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

"" NERDTree
" Start NERDTree, unless a file or session is specified, eg. vim -S session_file.vim.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') && v:this_session == '' | NERDTree | endif

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
]])

-- LSP-Status
local lsp_status = require("lsp-status")
-- completion_customize_lsp_label as used in completion-nvim
-- Optional: customize the kind labels used in identifying the current function.
-- g:completion_customize_lsp_label is a dict mapping from LSP symbol kind
-- to the string you want to display as a label
-- lsp_status.config { kind_labels = vim.g.completion_customize_lsp_label }

-- Register the progress handler
lsp_status.register_progress()

-- remove that dumb looking 'V'
lsp_status.config({
	status_symbol = "",
	diagnostics = false,
})

vim.opt.termguicolors = true

require("nvim-autopairs").setup()

require("bufferline").setup({
	options = {
		mode = "tabs",
		diagnostics = "nvim_lsp",
		separator_style = "slant",
	},
})

require("lualine").setup({
	options = {
		theme = "auto",
	},
	sections = {
		lualine_c = {
			"filename",
			"require('lsp-status').status()",
		},
	},
	tabline = {},
})

require("dressing").setup({
	input = {
		-- Window transparency (0-100)
		winblend = 0,
	},
})

-- https://github.com/nvim-telescope/telescope.nvim#themes
-- https://github.com/nvim-telescope/telescope.nvim#layout-display
-- https://github.com/nvim-telescope/telescope.nvim#pickers
require("telescope").setup({
	pickers = {
		lsp_code_actions = {
			theme = "cursor",
		},
	},
})

-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require("telescope").load_extension("fzf")

require("trouble").setup()

require("legendary").setup()

local opt = { noremap = true, silent = true }
local helpers = require("legendary.helpers")

do
	local keymaps = {
		-- general
		{ "<leader>te", "<cmd>tabnew<CR><bar><cmd>NERDTreeFocus<CR>", description = "New Tab", opts = opt },
		-- lspconfig
		{ "gj", vim.diagnostic.goto_prev, description = "Diagnostics go to previous", opts = opt },
		{ "gk", vim.diagnostic.goto_next, description = "Diagnostics go to next", opts = opt },
		-- autoformat
		{ "<leader>F", "<cmd>Neoformat<CR>", description = "Format File", opts = opt },
		-- find files using Telescope command-line sugar.
		{
			"<leader>ff",
			helpers.lazy_required_fn("telescope.builtin", "find_files"),
			description = "Telescope: Find Files",
			opts = opt,
		},
		{
			"<leader>fg",
			helpers.lazy_required_fn("telescope.builtin", "live_grep"),
			description = "Telescope: Live Grep",
			opts = opt,
		},
		{
			"<leader>fb",
			helpers.lazy_required_fn("telescope.builtin", "buffers"),
			description = "Telescope: Buffers",
			opts = opt,
		},
		{
			"<leader>fh",
			helpers.lazy_required_fn("telescope.builtin", "help_tags"),
			description = "Telescope: Help Tags",
			opts = opt,
		},
		-- nerdtree shortcut
		{ "<leader>ne", "<cmd>NERDTreeToggle<cr>", description = "Open NERDTree", opts = opt },
		-- trouble shortcut
		{ "<leader>tr", "<cmd>TroubleToggle<cr>", description = "Trouble Toggle", opts = opt },
		-- legendary
		{
			"<leader>l",
			helpers.lazy_required_fn("legendary", "find", "keymaps"),
			description = "Legendary: search keymaps",
			opts = opt,
		},
		{
			"<leader>ll",
			helpers.lazy_required_fn("legendary", "find"),
			description = "Legendary: search all",
			opts = opt,
		},
	}

	require("legendary").bind_keymaps(keymaps)
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	--{'<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
	--{'<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
	--{'<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')

	local keymaps = {
		-- Mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		{ "K", vim.lsp.buf.hover, description = "Display hover information", opts = opt },
		{ "<leader>rn", vim.lsp.buf.rename, description = "Rename", opts = opt },
		{ "gD", vim.lsp.buf.declaration, description = "Jump to symbol declaration", opts = opt },
		{ "gd", vim.lsp.buf.definition, description = "Jump to symbol definition", opts = opt },
		{ "<leader>D", vim.lsp.buf.type_definition, description = "Jump to type definition", opts = opt },
		{ "gi", vim.lsp.buf.implementation, description = "List all implementations for the symbol", opts = opt },
		-- { "<leader>a", vim.lsp.buf.code_action, description = "Code Action", opts = opt },
		{
			"<leader>a",
			helpers.lazy_required_fn("telescope.builtin", "lsp_code_actions"),
			description = "Code Action",
			opts = opt,
		},
		{ "gs", vim.lsp.buf.signature_help, description = "Show Signature Help", opts = opt },
		{ "gr", vim.lsp.buf.references, description = "List all references", opts = opt },
	}

	require("legendary").bind_keymaps(keymaps)

	lsp_status.on_attach(client)
end

do
	-- Setup nvim-cmp.
	local cmp = require("cmp")

	cmp.setup({
		snippet = {
			-- REQUIRED - you must specify a snippet engine
			expand = function(args)
				-- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
				require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
				-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
				-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
			end,
		},
		window = {
			-- completion = cmp.config.window.bordered(),
			-- documentation = cmp.config.window.bordered(),
		},
		mapping = cmp.mapping.preset.insert({
			["<C-b>"] = cmp.mapping.scroll_docs(-4),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<C-Space>"] = cmp.mapping.complete(),
			["<C-e>"] = cmp.mapping.abort(),
			-- Accept currently selected item. Set`select` to `false` to only confirm explicitly
			-- selected items.
			["<CR>"] = cmp.mapping.confirm({ select = true }),
		}),
		formatting = {
			format = require("lspkind").cmp_format({
				mode = "symbol_text",
				menu = {
					nvim_lua = "[Lua]",
					nvim_lsp = "[LSP]",
					luasnip = "[LuaSnip]",
					-- latex_symbols = "[Latex]",
					buffer = "[Buffer]",
				},
			}),
		},
		sources = cmp.config.sources({
			{ name = "nvim_lsp" },
			-- { name = 'vsnip' }, -- For vsnip users.
			{ name = "luasnip" }, -- For luasnip users.
			-- { name = 'ultisnips' }, -- For ultisnips users.
			-- { name = 'snippy' }, -- For snippy users.
			-- { name = "cmp_git" }, -- For cmp git users.
			{ name = "nvim_lua" }, -- For nvim lua users.
		}, {
			{ name = "buffer" },
		}),
	})

	-- Set configuration for specific filetype.
	cmp.setup.filetype("gitcommit", {
		sources = cmp.config.sources({
			-- { name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
		}, {
			{ name = "buffer" },
		}),
	})

	-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
	cmp.setup.cmdline("/", {
		mapping = cmp.mapping.preset.cmdline(),
		sources = {
			{ name = "buffer" },
		},
	})

	-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
	cmp.setup.cmdline(":", {
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{ name = "path" },
		}, {
			{ name = "cmdline" },
		}),
	})
end

local lsp_config = require("lspconfig")
local lsp_installer = require("nvim-lsp-installer")

lsp_installer.setup({})

local opts = {
	on_attach = on_attach,
	capabilities = require("cmp_nvim_lsp").update_capabilities(
		-- Setup lspconfig.
		vim.lsp.protocol.make_client_capabilities()
	),
}

-- Register a handler that will be called for each installed server when it's ready (i.e.
-- when installation is finished or if the server is already installed).
require("rust-tools").setup({ server = opts })

for _, server in ipairs(lsp_installer.get_installed_servers()) do
	if server.name ~= "rust_analyzer" then
		lsp_config[server.name].setup(opts)
	end
end
