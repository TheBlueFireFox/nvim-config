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
        version = "^4", -- Recommended
        ft = { "rust" },
    },
    {
        "saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        dependencies = {
            { "nvim-lua/plenary.nvim" },
        },
        init = function()
            -- Crates.nvim (rust helper)
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "toml",
                callback = function()
                    require("cmp").setup.buffer({
                        sources = {
                            { name = "crates" },
                        },
                    })
                end,
            })
        end,
    },
    -- haskell super powers
    {
        "mrcjkb/haskell-tools.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope.nvim",
                optional = true,
            },
        },
        version = "^4",
        ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
    },
}
