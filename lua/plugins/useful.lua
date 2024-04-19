return {
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {}
    },
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
        cmd = { "Neoformat" },
        keys = {
            {
                "<leader>F",
                function()
                    -- vim.lsp.buf.format,
                    -- "<cmd>Neoformat<cr>",
                    for _, client in pairs(vim.lsp.get_active_clients()) do
                        if client.server_capabilities.documentFormattingProvider then
                            vim.lsp.buf.format()
                            return
                        end
                    end
                    vim.cmd([[
                        silent Neoformat
                    ]])
                end,
                desc = "Format File",
            },
        },
    }
}
