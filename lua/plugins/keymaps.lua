return {
    {
        "mrjones2014/legendary.nvim",
        priority = 1000,
        lazy = false,
        keys = function()
            local keys = {
                -- general
                {
                    "<leader>tc",
                    "<cmd>tabclose<cr>",
                    desc = "Close Tab",
                },
                {
                    "<leader>h",
                    "<cmd>nohlsearch<cr>",
                    desc = "Stop hightlighting",
                },
                {
                    "gj",
                    vim.diagnostic.goto_prev,
                    desc = "Diagnostics go to previous",
                },
                {
                    "gk",
                    vim.diagnostic.goto_next,
                    desc = "Diagnostics go to next",
                },
                {
                    "<leader>e",
                    vim.diagnostic.open_float,
                    desc = "Open diagnostic window",
                },
                -- legendary
                {
                    "<leader>l",
                    function()
                    require("legendary").find("keymaps")
                end,
                    desc = "Legendary: search keymaps",
                },
                {
                    "<leader>ll",
                    function()
                        require("legendary").find()
                    end,
                    desc = "Legendary: search all",
                },
                -- lsp
                {
                    "K",
                    vim.lsp.buf.hover,
                    desc = "Display hover information",
                },
                {
                    "<leader>rn",
                    vim.lsp.buf.rename,
                    desc = "Rename",
                },
                {
                    "gD",
                    vim.lsp.buf.declaration,
                    desc = "Jump to symbol declaration",
                },
                {
                    "gd",
                    vim.lsp.buf.definition,
                    desc = "Jump to symbol definition",
                },
                {
                    "<leader>D",
                    vim.lsp.buf.type_definition,
                    desc = "Jump to type definition",
                },
                {
                    "gi",
                    vim.lsp.buf.implementation,
                    desc = "List all implementations for the symbol",
                },
                {
                    "<leader>a",
                    vim.lsp.buf.code_action,
                    desc = "Code Action",
                },
                {
                    "gs",
                    vim.lsp.buf.signature_help,
                    desc = "Show Signature Help",
                },
                {
                    "gr",
                    vim.lsp.buf.references,
                    desc = "List all references",
                },
                {
                    "<leader>F",
                    vim.lsp.buf.format,
                    desc = "Format File with lsp",
                },
            }

            -- special terminal one
            local opt = { noremap = true, silent = true }
            vim.api.nvim_set_keymap("t", "<Esc>", "<C-\\><C-n>", opt)

            return keys
        end,
        opts = {
            lazy_nvim = {
                auto_register = true,
            },
        },
    },
}
