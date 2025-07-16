return {
    -- Collection of configurations for the built-in LSP client
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = {
            { "neovim/nvim-lspconfig" },
            { "mason-org/mason.nvim", opts = {} },
        },
        lazy = false,
        opts = function()
            return {
                ensure_installed = { "lua_ls", "vimls" },
                automatic_enable = {
                    exclude = {
                        "rust_analyzer",
                        "hls",
                    },
                }
            }
        end,
        enabled = not require("core.utils").is_diff_mode,
    },
    -- lsp inlay hints
    {
        "MysticalDevil/inlay-hints.nvim",
        event = "LspAttach",
        dependencies = { "neovim/nvim-lspconfig" },
        config = function()
            require("inlay-hints").setup()
        end,
        enabled = not require("core.utils").is_diff_mode,
    },
    -- rust analyzer super powers
    {
        "mrcjkb/rustaceanvim",
        version = "^6", -- Recommended
        ft = { "rust" },
        enabled = not require("core.utils").is_diff_mode,
    },
    {
        "saecki/crates.nvim",
        tag = "stable",
        event = { "BufRead Cargo.toml" },
        config = function()
            require("crates").setup()
        end,
        enabled = not require("core.utils").is_diff_mode,
    },
}
