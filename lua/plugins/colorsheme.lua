return {
    -- design
    {
        "sainnhe/gruvbox-material",
        lazy = false,
        init = function()
            -- Available values: 'material', 'mix', 'original'
            vim.g.gruvbox_material_palette = "material"

            -- Available values: 'hard', 'medium'(default), 'soft'
            vim.g.gruvbox_material_background = "hard"

            vim.g.gruvbox_material_enable_italic = false

            -- " For better performance
            vim.g.gruvbox_material_better_performance = 1
            -- vim.cmd.colorscheme('gruvbox-material')
        end,
    },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        init = function()
            -- Example config in Lua
            vim.g.tokyonight_style = "night"
        end,
    },
    {
        "catppuccin/nvim",
        lazy = false,
        name = "catppuccin",
        opts = {
			no_italic = true,
			term_colors = true,
			transparent_background = false,
			styles = {
				comments = {},
				conditionals = {},
				loops = {},
				functions = {},
				keywords = {},
				strings = {},
				variables = {},
				numbers = {},
				booleans = {},
				properties = {},
				types = {},
			},
			color_overrides = {
				mocha = {
					base = "#000000",
					mantle = "#000000",
					crust = "#000000",
				},
			},
			integrations = {
				telescope = {
					enabled = true,
					style = "nvchad",
				},
				dropbar = {
					enabled = true,
					color_mode = true,
				},
			},
		},
        init = function()
            -- set color
            vim.cmd.colorscheme("catppuccin-mocha")
        end
    },
    {
        "rafi/awesome-vim-colorschemes",
        lazy = false,
    }
}
