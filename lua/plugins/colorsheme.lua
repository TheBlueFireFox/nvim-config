return {
    -- design
    {
        "sainnhe/gruvbox-material",
        lazy = true,
        init = function()
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
        lazy = true,
        init = function()
            -- Example config in Lua
            vim.g.tokyonight_style = "night"
        end,
    },
    {
        "catppuccin/nvim",
        lazy = true,
        name = "catppuccin",
        init = function()
            -- set color
            vim.cmd.colorscheme "catppuccin-mocha"
        end
    }
}
