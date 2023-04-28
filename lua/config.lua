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

-- Disable virtual_text since it's redundant due to lsp_lines.
vim.diagnostic.config({
	virtual_text = false,
})
-- change diagnostics error prefix symbol
vim.diagnostic.config({
 virtual_text = {
     prefix = "◯ ",
 },
})

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

-- examples for your init.lua

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup()

-- OR setup with some options
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})

---- Other configurations
-- have Vim jump to the last position when reopening a file
vim.api.nvim_create_autocmd(
	"BufReadPost",
	{ command = [[if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif]] }
)

--- NERDTree
-- Exit Vim if NERDTree is the only window remaining in the only tab.
-- vim.api.nvim_create_autocmd("BufEnter", {
-- 	pattern = "*",
-- 	command = [[ if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif ]],
-- })

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
		sort_by = "tabs",
		offsets = {
			{
				filetype = "NERDTree",
				text = "File Explorer",
				highlight = "Directory",
				text_align = "left",
			},
			{
				filetype = "nerdtree",
				text = "File Explorer",
				highlight = "Directory",
				text_align = "left",
			},
		},
	},
})

-- Dashboard
do
	local conf = require("alpha.themes.dashboard")
	local buttons = {
		type = "group",
		val = {
			conf.button("e", "  New file", "<cmd>ene <CR>"),
			conf.button(vim.g.mapleader .. "ff", "  Find file"),
			conf.button(vim.g.mapleader .. "fh", "  Recently opened files"),
			conf.button(vim.g.mapleader .. "fg", "  Live Grep"),
			conf.button(vim.g.mapleader .. "sl", "  Open last session"),
		},
		opts = {
			spacing = 1,
		},
	}

	conf.config.layout = {
		{ type = "padding", val = 2 },
		conf.section.header,
		{ type = "padding", val = 2 },
		buttons,
		conf.section.footer,
	}

	require("alpha").setup(conf.config)

	require("session_manager").setup({
		autoload_mode = require("session_manager.config").AutoloadMode.Disabled,
	})
end

-- Crates.nvim (rust helper)
vim.api.nvim_create_autocmd("FileType", {
	pattern = "toml",
	callback = function()
		require("cmp").setup.buffer({
			sources = {
				{ name = "crates" },
			},
		})
	end,
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
		win_options = {
			-- Window transparency (0-100)
			winblend = 0,
		},
	},
	select = {
		enabled = false,
	},
})

-- https://github.com/nvim-telescope/telescope.nvim#themes
-- https://github.com/nvim-telescope/telescope.nvim#layout-display
-- https://github.com/nvim-telescope/telescope.nvim#pickers
require("telescope").setup({
	defaults = {
		prompt_prefix = " ",
	},
	extensions = {
		["ui-select"] = {
			require("telescope.themes").get_cursor({}),
		},
	},
})

-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require("telescope").load_extension("fzf")
require("telescope").load_extension("ui-select")

require("trouble").setup()

require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"bash",
		"bibtex",
		"cmake",
		"make",
		"c",
		"cpp",
		"css",
		"dockerfile",
		"html",
		"javascript",
		"json",
		"rust",
		"haskell",
		"lua",
		"toml",
		"yaml",
	},
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
})

require("legendary").setup({})

local opt = { noremap = true, silent = true }
do
	local helpers = require("legendary.toolbox")
	local keymaps = {
		-- general
		{ "<leader>te", "<cmd>tabnew<CR><bar><cmd>NvimTreeFocus<CR>", description = "New Tab", opts = opt },
		{ "<leader>tc", "<cmd>tabclose<CR>", description = "Close Tab", opts = opt },
		{ "<leader>h", "<cmd>nohlsearch<CR>", description = "Stop hightlighting", opts = opt },
		-- lspconfig
		{ "<leader>e", vim.diagnostic.open_float, description = "Open diagnostic window", opts = opt },
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
		-- toggle lsp lines
		-- { "<leader>tl", require("lsp_lines").toggle, description = "Toggle Lsp Lines", opts = opt },
		-- nerdtree shortcut
		{ "<leader>ne", "<cmd>NvimTreeToggle<cr>", description = "Open NERDTree", opts = opt },
		-- trouble shortcut
		{ "<leader>tr", "<cmd>TroubleToggle<cr>", description = "Toggle Trouble", opts = opt },
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
		-- load last session
		{
			"<leader>sl",
			"<cmd>SessionManager load_last_session<CR>",
			description = "Open last session",
			opts = opt,
		},
	}

	require("legendary").keymaps(keymaps)

	-- special terminal one
	vim.api.nvim_set_keymap("t", "<Esc>", "<C-\\><C-n>", opt)
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
		{ "<leader>a", vim.lsp.buf.code_action, description = "Code Action", opts = opt },
		{ "gs", vim.lsp.buf.signature_help, description = "Show Signature Help", opts = opt },
		{ "gr", vim.lsp.buf.references, description = "List all references", opts = opt },
	}

	require("legendary").keymaps(keymaps)

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

require("mason").setup({})


do
	local lsp_config = require("lspconfig")
	local mason_config = require("mason-lspconfig")
	mason_config.setup({})

	lsp_config.util.default_config = vim.tbl_extend("force", lsp_config.util.default_config, {
		on_attach = on_attach,
		capabilities = require("cmp_nvim_lsp").default_capabilities(),
	})

	-- Register a handler that will be called for each installed server when it's ready (i.e.
	-- when installation is finished or if the server is already installed).
	for _, server in ipairs(mason_config.get_installed_servers()) do
		if server == "rust_analyzer" then
			require("rust-tools").setup({
				server = {
					on_attach = on_attach,
					capabilities = require("cmp_nvim_lsp").default_capabilities(),
					settings = {
						["rust-analyzer"] = {
							inlayHints = { locationLinks = false },
						},
					},
				},
			})
		elseif server == "hls" then
			require("haskell-tools").setup({
				hls = {
					on_attach = function(client, buffnr)
						local helpers = require("legendary.toolbox")
						local opts = vim.tbl_extend("keep", opt, { buffer = buffnr })
						local keymaps = {
							{ "<leader>ca", vim.lsp.codelens.run, description = "Run The CodeLens", opts = opts },
							{
								"<leader>hs",
								helpers.lazy_required_fn("haskell-tools", "hoogle.hoogle_signature"),
								description = "Haskell: Hoogle signature",
								opts = opts,
							},
						}
						require("legendary").keymaps(keymaps)
						on_attach(client, buffnr)
					end,
					capabilities = require("cmp_nvim_lsp").default_capabilities(),
				},
			})
		else
			lsp_config[server].setup({})
		end
	end
end
