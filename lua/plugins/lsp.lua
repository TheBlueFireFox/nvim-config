return {
    -- Collection of configurations for the built-in LSP client
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            { "neovim/nvim-lspconfig" },
            { "williamboman/mason.nvim" },
        },
        event = { "VeryLazy" },
        opts = {},
        config = function()
            local lsp_config = require("lspconfig")
            local mason_config = require("mason-lspconfig")
            mason_config.setup({})

            lsp_config.util.default_config = vim.tbl_extend("force", lsp_config.util.default_config, {
                capabilities = require("cmp_nvim_lsp").default_capabilities(),
            })
            require("mason").setup({})

            -- Register a handler that will be called for each installed server when it's ready (i.e.
            -- when installation is finished or if the server is already installed).
            mason_config.setup_handlers({
                function(server_name)
                    require("lspconfig")[server_name].setup({})
                end,
                ["rust_analyzer"] = function()
                end,
                ["hls"] = function()
                end
            })
        end,
    },
    -- lsp inlay hints
    {
        "MysticalDevil/inlay-hints.nvim",
        event = "LspAttach",
        dependencies = { "neovim/nvim-lspconfig" },
        config = function()
            require("inlay-hints").setup()
        end
    },
    -- rust analyzer super powers
    {
        "mrcjkb/rustaceanvim",
        version = "^5", -- Recommended
        ft = { "rust" },
        init = function()
            -- Add workaround for https://github.com/neovim/neovim/issues/30985
            for _, method in ipairs({ 'textDocument/diagnostic', 'workspace/diagnostic' }) do
                local default_diagnostic_handler = vim.lsp.handlers[method]
                vim.lsp.handlers[method] = function(err, result, context, config)
                    if err ~= nil and err.code == -32802 then
                        return
                    end
                    return default_diagnostic_handler(err, result, context, config)
                end
            end
        end
    },
}
