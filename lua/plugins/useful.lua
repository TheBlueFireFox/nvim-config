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
        cmd = "Trouble",
        opts = {},
        keys = {
            {
                "<leader>tr",
                "<cmd>Trouble diagnostics toggle<cr>",
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
                    for _, client in pairs(vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })) do
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
