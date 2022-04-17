-- automatically install and set up packer.nvim on any machine you clone your configuration to
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local packer_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	packer_bootstrap = vim.fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
end

local packer = require("packer").startup(function(use)
	-- Package manager
	use("wbthomason/packer.nvim")

	-- Collection of configurations for the built-in LSP client
	use("neovim/nvim-lspconfig")
	use("williamboman/nvim-lsp-installer")

	-- for rust specific tools
	use("simrat39/rust-tools.nvim")

	-- usefull
	use("jiangmiao/auto-pairs")
	use("Chiel92/vim-autoformat")
	use("Yggdroot/indentLine")

	-- code completion
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-cmdline")
	use("hrsh7th/nvim-cmp")
	use("hrsh7th/cmp-nvim-lua")
	use({
		"petertriho/cmp-git",
		requires = "nvim-lua/plenary.nvim",
	})

	-- snippets
	use("L3MON4D3/LuaSnip")
	use("rafamadriz/friendly-snippets")
	use("saadparwaiz1/cmp_luasnip")
	use("onsails/lspkind-nvim")
	use("ray-x/lsp_signature.nvim")

	-- code actions
	use("tami5/lspsaga.nvim")
	use({
		"folke/trouble.nvim",
		requires = "kyazdani42/nvim-web-devicons",
	})
	use({
		"nvim-telescope/telescope.nvim",
		requires = {
			{ "nvim-lua/plenary.nvim" },
		},
	})
	use({
		"preservim/nerdtree",
		requires = {
			{ "ryanoasis/vim-devicons" },
			{ "Xuyuanp/nerdtree-git-plugin" },
		},
	})

	-- design
	use("rebelot/kanagawa.nvim")
	use("sainnhe/gruvbox-material")
	use("sainnhe/sonokai")
	use("projekt0n/github-nvim-theme")

	-- for vertical line
	use("davepinto/virtual-column.nvim")

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
	if packer_bootstrap then
		require("packer").sync()
	end
end)

--  run :PackerCompile whenever plugins.lua is updated with an autocommand:
vim.cmd([[
augroup packer_user_config
  autocmd!
  autocmd BufWritePost plugins.lua source <afile> | PackerCompile
augroup end
]])

return packer
