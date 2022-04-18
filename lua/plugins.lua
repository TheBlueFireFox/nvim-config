local packer = { bootstrap = false, callback = nil }

function packer:startup()
	local pframe = require("packer").startup(function(use)
		-- Package manager
		use("wbthomason/packer.nvim")

		-- Collection of configurations for the built-in LSP client
		use("neovim/nvim-lspconfig")
		use("williamboman/nvim-lsp-installer")

		-- for rust specific tools
		use("simrat39/rust-tools.nvim")

		-- usefull
		use("jiangmiao/auto-pairs")
		-- use("Chiel92/vim-autoformat")
		use("sbdchd/neoformat")
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

	self.packer = pframe
end

function packer:install()
	-- based on https://github.com/wbthomason/packer.nvim#bootstrapping
	-- automatically install and set up packer.nvim on any machine you clone your configuration to
	local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

	if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
		self.bootstrap = vim.fn.system({
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

local function RandomVariable(length)
	math.randomseed(os.time())
	local res = ""
	for _ = 1, length do
		res = res .. string.char(math.random(97, 122))
	end
	return res
end

function packer:run()
	self:install()

	self:startup()

	--  run :PackerCompile whenever plugins.lua is updated with an autocommand:
	vim.cmd([[
        augroup packer_user_config
          autocmd!
          autocmd BufWritePost plugins.lua source <afile> | PackerCompile
        augroup end
    ]])

	if not self.bootstrap then
		self.callback()
		return
	end
	-- generate random string as a global variable
	-- so that the global namespace will not be poluted
	-- too much
	local name = RandomVariable(20)
	_G[name] = function()
		require("packer.display").quit()
		self.callback()
	end

	vim.cmd("autocmd User PackerComplete lua " .. name .. "()")
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
