return {
    -- code completion
    {
        "hrsh7th/nvim-cmp",
        event = "VeryLazy",
        dependencies = {
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "hrsh7th/cmp-cmdline" },
            { "hrsh7th/cmp-nvim-lua" },
            {
                "petertriho/cmp-git",
                dependencies = {
                    { "nvim-lua/plenary.nvim" },
                },
            },
            -- snippets
            {
                "onsails/lspkind-nvim",
                dependencies = { "saadparwaiz1/cmp_luasnip" }
            },
            { "L3MON4D3/LuaSnip" },
            --          { "rafamadriz/friendly-snippets" },
            --          {
            --              "ray-x/lsp_signature.nvim",
            --              event = "VeryLazy",
            --              opts = {}
            --          },
        },
        config = function(_, opts)
            local cmp = require("cmp")
            cmp.setup(opts)

            -- Set configuration for specific filetype.
            cmp.setup.filetype("gitcommit", {
                sources = cmp.config.sources({
                    -- { name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
                }, {
                    { name = "buffer" },
                }),
            })

            -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline("/", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer" },
                },
            })

            -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources(
                    { { name = "path" } },
                    { { name = "cmdline" } }),
            })
        end,
        init = function()
            --  nvim-cmp
            vim.opt.completeopt = { "menu", "menuone", "noselect" }
        end,
        opts = function()
            -- Setup nvim-cmp.
            local cmp = require("cmp")

            return {
                snippet = {
                    -- REQUIRED - you must specify a snippet engine
                    expand = function(args)
                        -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
                        require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
                        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
                        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
                    end,
                },
                window = {
                    -- completion = cmp.config.window.bordered(),
                    -- documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    -- Accept currently selected item. Set`select` to `false` to only confirm explicitly
                    -- selected items.
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                }),
                formatting = {
                    format = require("lspkind").cmp_format({
                        mode = "symbol_text",
                        menu = {
                            nvim_lua = "[Lua]",
                            nvim_lsp = "[LSP]",
                            luasnip = "[LuaSnip]",
                            buffer = "[Buffer]",
                        },
                    }),
                },
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    -- { name = 'vsnip' }, -- For vsnip users.
                    { name = "luasnip" }, -- For luasnip users.
                    -- { name = 'ultisnips' }, -- For ultisnips users.
                    -- { name = 'snippy' }, -- For snippy users.
                    -- { name = "cmp_git" }, -- For cmp git users.
                    { name = "nvim_lua" }, -- For nvim lua users.
                }, {
                    { name = "buffer" },
                }),
            }
        end,
    },
}
