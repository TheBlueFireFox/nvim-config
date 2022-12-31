local packer = { bootstrap = false, callback = nil }

function packer:startup()
	self.packer = require("packer").startup(function(use)
		-- Package manager
		use("wbthomason/packer.nvim")

		-- Collection of configurations for the built-in LSP client
		use("neovim/nvim-lspconfig")
		use("williamboman/mason.nvim")
		use("williamboman/mason-lspconfig.nvim")

		-- rust analyzer super powers
		use("simrat39/rust-tools.nvim")

		-- haskell super powers
        use('MrcJkb/haskell-tools.nvim')

		-- usefull
		use("windwp/nvim-autopairs")
		use("sbdchd/neoformat")
		use("mrjones2014/legendary.nvim")
		-- use("https://git.sr.ht/~whynothugo/lsp_lines.nvim")

		-- dashboard
		use({
			"goolord/alpha-nvim",
			requires = {
				{ "kyazdani42/nvim-web-devicons" },
			},
		})
		use({
			"Shatur/neovim-session-manager",
			requires = {
				{ "nvim-lua/plenary.nvim" },
			},
		})

		-- code completion
		use("hrsh7th/cmp-nvim-lsp")
		use("hrsh7th/cmp-buffer")
		use("hrsh7th/cmp-path")
		use("hrsh7th/cmp-cmdline")
		use("hrsh7th/nvim-cmp")
		use("hrsh7th/cmp-nvim-lua")
		use({
			"petertriho/cmp-git",
			requires = {
				{ "nvim-lua/plenary.nvim" },
			},
		})

		use({
			"saecki/crates.nvim",
			event = { "BufRead Cargo.toml" },
			requires = { { "nvim-lua/plenary.nvim" } },
			config = function()
				require("crates").setup()
			end,
		})

		-- snippets
		use("L3MON4D3/LuaSnip")
		use("rafamadriz/friendly-snippets")
		use("saadparwaiz1/cmp_luasnip")
		use("onsails/lspkind-nvim")
		use("ray-x/lsp_signature.nvim")

		-- code actions
		use({
			"folke/trouble.nvim",
			requires = {
				{ "kyazdani42/nvim-web-devicons" },
			},
		})
		use({
			"nvim-telescope/telescope.nvim",
			requires = {
				{ "nvim-lua/plenary.nvim" },
				{ "stevearc/dressing.nvim" },
				{ "nvim-telescope/telescope-ui-select.nvim" },
				{ "nvim-telescope/telescope-symbols.nvim" },
				{ "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
			},
		})
		use({
			"preservim/nerdtree",
			requires = {
				{ "ryanoasis/vim-devicons" },
				{ "Xuyuanp/nerdtree-git-plugin" },
			},
		})
		use({
			"nvim-treesitter/nvim-treesitter",
			run = ":TSUpdate",
		})

		-- design
		use("sainnhe/gruvbox-material")
		use("folke/tokyonight.nvim")

		-- header and bottom
		use({
			"nvim-lualine/lualine.nvim",
			requires = {
				{ "kyazdani42/nvim-web-devicons", opt = true },
			},
		})
		use({
			"akinsho/bufferline.nvim",
			tag = "*",
			requires = { "kyazdani42/nvim-web-devicons" },
		})
		use("nvim-lua/lsp-status.nvim")

		-- Automatically set up your configuration after cloning packer.nvim
		-- Put this at the end after all plugins
		if self.bootstrap then
			require("packer").sync()
		end
	end)
end

function packer:install()
	-- based on https://github.com/wbthomason/packer.nvim#bootstrapping
	-- automatically install and set up packer.nvim on any machine you clone your configuration to
	local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

	if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
		self.bootstrap = true

		vim.fn.system({
			"git",
			"clone",
			"--depth",
			"1",
			"https://github.com/wbthomason/packer.nvim",
			install_path,
		})
		-- Ref: https://github.com/wbthomason/packer.nvim/issues/739#issuecomment-1019280631
		vim.o.runtimepath = vim.fn.stdpath("data") .. "/site/pack/*/start/*," .. vim.o.runtimepath
	end
end

function packer:autorun()
	--  run :PackerCompile whenever plugins.lua is updated with an autocommand:
	local packer_autoconf = vim.api.nvim_create_augroup("packer_user_config", { clear = true })
	vim.api.nvim_create_autocmd("BufWritePost", {
		pattern = "plugins.lua",
		command = "source <afile> | PackerCompile",
		group = packer_autoconf,
	})

	self.callback()
end

function packer:run()
	self:install()

	self:startup()

	if not self.bootstrap then
		self:autorun()
		return
	end

	vim.api.nvim_create_autocmd("User", {
		pattern = "PackerComplete",
		callback = function()
			require("packer.display").quit()
			self:autorun()
		end,
	})
end

function packer:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	self.bootstrap = false
	self.callback = self.callback or function() end
	return o
end

return {
	run = function(o)
		local a = packer:new(o)
		a:run()

		return a
	end,
}
