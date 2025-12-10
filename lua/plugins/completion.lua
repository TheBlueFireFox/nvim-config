return {
    -- code completion
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "hrsh7th/cmp-cmdline" },
            { "hrsh7th/cmp-nvim-lua" },
            -- snippets
            {
                "onsails/lspkind-nvim",
            },
            {
                "L3MON4D3/LuaSnip",
                version = "v2.*",
                build = "make install_jsregexp",
                dependencies = {
                    "rafamadriz/friendly-snippets",
                    "saadparwaiz1/cmp_luasnip" -- luasnip
                },
                opts = function()
                    require("luasnip.loaders.from_vscode").lazy_load()
                end,
            },
        },
        init = function()
            --  nvim-cmp
            vim.opt.completeopt = { "menu", "menuone", "noselect" }
        end,
        opts = function()
            -- Setup nvim-cmp.
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local lspkind_comparator = function(conf)
                local lsp_types = require('cmp.types').lsp
                return function(entry1, entry2)
                    if entry1.source.name ~= 'nvim_lsp' then
                        if entry2.source.name == 'nvim_lsp' then
                            return false
                        else
                            return nil
                        end
                    end
                    local kind1 = lsp_types.CompletionItemKind[entry1:get_kind()]
                    local kind2 = lsp_types.CompletionItemKind[entry2:get_kind()]

                    local priority1 = conf.kind_priority[kind1] or 0
                    local priority2 = conf.kind_priority[kind2] or 0
                    if priority1 == priority2 then
                        return nil
                    end
                    return priority2 < priority1
                end
            end

            local label_comparator = function(entry1, entry2)
                return entry1.completion_item.label < entry2.completion_item.label
            end

            return {
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body) -- For `luasnip` users.
                    end,
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
                sorting = {
                    comparators = {
                        lspkind_comparator({
                            kind_priority = {
                                Field = 11,
                                Property = 11,
                                Constant = 10,
                                Enum = 10,
                                EnumMember = 10,
                                Event = 10,
                                Function = 10,
                                Method = 10,
                                Operator = 10,
                                Reference = 10,
                                Struct = 10,
                                Variable = 9,
                                File = 8,
                                Folder = 8,
                                Class = 5,
                                Color = 5,
                                Module = 5,
                                Keyword = 2,
                                Constructor = 1,
                                Interface = 1,
                                Snippet = 0,
                                Text = 1,
                                TypeParameter = 1,
                                Unit = 1,
                                Value = 1,
                            },
                        }),
                        label_comparator,
                    },
                },
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "nvim_lua" },
                }, {
                    { name = "buffer" },
                }),
            }
        end,
        config = function(_, opts)
            local cmp = require("cmp")
            cmp.setup(opts)

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
    },
}
