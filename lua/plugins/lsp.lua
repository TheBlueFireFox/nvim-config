return {
    -- Collection of configurations for the built-in LSP client
    { "neovim/nvim-lspconfig" },
    { "williamboman/mason.nvim" },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
        },
        event = { "VeryLazy", "BufReadPost", "BufNewFile" },
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
                ["rust_analyzer"] = nil,
                ["hls"] = nil,
            })
        end,
    },
    -- lsp inlay hints
    {
        "lvimuser/lsp-inlayhints.nvim",
        event = { "BufReadPost", "BufNewFile" },
        opts = function()
            vim.api.nvim_set_hl(0, "LspInlayHintCustom", { link = "Comment" })
            vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
            vim.api.nvim_create_autocmd("LspAttach", {
                group = "LspAttach_inlayhints",
                callback = function(args)
                    if not (args.data and args.data.client_id) then
                        return
                    end

                    local bufnr = args.buf
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    require("lsp-inlayhints").on_attach(client, bufnr)
                end,
            })

            return {
                inlay_hints = {
                    parameter_hints = {
                        show = true,
                        prefix = "<- ",
                        separator = ", ",
                        remove_colon_start = true,
                        remove_colon_end = true,
                    },
                    type_hints = {
                        -- type and other hints
                        show = true,
                        prefix = "=> ",
                        separator = ", ",
                        remove_colon_start = true,
                        remove_colon_end = false,
                    },
                    -- highlight group
                    highlight = "LspInlayHintCustom",
                },
                debug_mode = true,
            }
        end,
    },

    -- rust analyzer super powers
    {
        "simrat39/rust-tools.nvim",
        opts = {

            tools = {
                inlay_hints = { auto = false },
            },
            server = {
                capabilities = require("cmp_nvim_lsp").default_capabilities(),
                settings = {
                    ["rust-analyzer"] = {
                        inlayHints = { locationLinks = false },
                    },
                },
            },
        },
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
        version = "^2",
        ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
    },
    -- Scala LSP
    {
        "scalameta/nvim-metals",
        name = "metals",
        ft = { "scala", "sbt", "java" },
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local metals_config = require("metals").bare_config()

            -- Example of settings
            metals_config.settings = {
                showImplicitArguments = true,
                excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
            }

            -- *READ THIS*
            -- I *highly* recommend setting statusBarProvider to true, however if you do,
            -- you *have* to have a setting to display this in your statusline or else
            -- you'll not see any messages from metals. There is more info in the help
            -- docs about this
            metals_config.settings = {
                showImplicitArguments = true,
                showImplicitConversionsAndClasses = true,
                showInferredType = true,
                superMethodLensesEnabled = true,
            }
            metals_config.init_options.statusBarProvider = "on"
            metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

            require("metals").initialize_or_attach(metals_config)
        end
    },
}
