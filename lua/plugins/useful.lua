return {
	{ "windwp/nvim-autopairs" },
	-- code actions
	{
		"folke/trouble.nvim",
		dependencies = {
			{ "nvim-tree/nvim-web-devicons" },
		},
		keys = {
			{
				"<leader>tr",
				"<cmd>TroubleToggle<cr>",
				desc = "Toggle Trouble",
			},
		},
	},
	-- Formatting
	{
		"sbdchd/neoformat",
		keys = {
			{
				"<leader>Fn",
				"<cmd>Neoformat<cr>",
				desc = "Format File with neoformat",
			},
		},
	},
}
