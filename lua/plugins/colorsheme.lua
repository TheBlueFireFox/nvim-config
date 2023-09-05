return {
    -- design
    {
        "sainnhe/gruvbox-material",
        config = function()
            -- Available values: 'material', 'mix', 'original'
            vim.g.gruvbox_material_palette = "material"

            -- Available values: 'hard', 'medium'(default), 'soft'
            vim.g.gruvbox_material_background = "hard"

            -- " For better performance
            vim.g.gruvbox_material_better_performance = 1
        end,
    },
    {
        "folke/tokyonight.nvim",
        config = function()
            -- Example config in Lua
            vim.g.tokyonight_style = "night"

    end,
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        config = function()
            -- set color
            vim.cmd.colorscheme "catppuccin-mocha"
        end
    }
}
