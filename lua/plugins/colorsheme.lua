return {
    -- design
    {
        "sainnhe/gruvbox-material",
        init = function()
            -- Available values: 'material', 'mix', 'original'
            vim.g.gruvbox_material_palette = "material"

            -- Available values: 'hard', 'medium'(default), 'soft'
            vim.g.gruvbox_material_background = "hard"

            vim.g.gruvbox_material_enable_italic = false

            -- " For better performance
            vim.g.gruvbox_material_better_performance = 1
            vim.cmd.colorscheme('gruvbox-material')
        end,
    },
    {
        "folke/tokyonight.nvim",
        init = function()
            -- Example config in Lua
            vim.g.tokyonight_style = "night"
        end,
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        init = function()
            -- set color
            -- vim.cmd.colorscheme "catppuccin-mocha"
        end
    }
}
