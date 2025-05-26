return {
    -- Collection of configurations for the built-in LSP client
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = {
            { "neovim/nvim-lspconfig" },
            { "mason-org/mason.nvim", opts = {} },
        },
        lazy = false,
        opts = {
            ensure_installed = { "lua_ls", "vimls" },
            automatic_enable = {
                exclude = {
                    "rust_analyzer",
                    "hls"
                }
            }
        },
    },
    -- lsp inlay hints
    {
        "MysticalDevil/inlay-hints.nvim",
        event = "LspAttach",
        dependencies = { "neovim/nvim-lspconfig" },
        config = function()
            require("inlay-hints").setup()
        end,
    },
    -- rust analyzer super powers
    {
        "mrcjkb/rustaceanvim",
        version = "^6", -- Recommended
        ft = { "rust" },
    },
    {
        'saecki/crates.nvim',
        tag = 'stable',
        event = { "BufRead Cargo.toml" },
        config = function()
            require('crates').setup()
        end,
    }
}
