return {
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = {
            { "ryanoasis/vim-devicons" },
        },
        keys = {
            {
                "<leader>te",
                "<cmd>tabnew<CR><bar><cmd>NvimTreeFocus<CR>",
                desc = "New Tab",
            },
            {
                "<leader>ne",
                "<cmd>NvimTreeToggle<cr>",
                desc = "Open NvimTree",
            },
        },
        init = function()
            -- disable netrw at the very start of your init.lua (strongly advised)
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1
        end,
        opts = function()
            ---- Other configurations

            -- have Vim jump to the last position when reopening a file
            -- TODO: change to lua
            vim.api.nvim_create_autocmd(
                "BufReadPost",
                { command = [[if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif]] }
            )

            -- TODO: get working
            --- NvimTree
            -- Exit Vim if NERDTree is the only window remaining in the only tab.
            -- vim.api.nvim_create_autocmd("BufEnter", {
            --     pattern = "*",
            --     command = [[ if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NvimTree') && b:NvimTree.isTabTree() | quit | endif ]],
            -- })

            return {
                sort_by = "case_sensitive",
                renderer = {
                    group_empty = true,
                },
                filters = {
                    dotfiles = true,
                },
                actions = {
                    open_file = {
                        quit_on_open = true,
                    },
                },
            }
        end,
    },
    {
        "nvim-telescope/telescope.nvim",
        event = "VeryLazy",
        dependencies = {
            { "nvim-lua/plenary.nvim" },
            { "stevearc/dressing.nvim" },
            { "nvim-telescope/telescope-ui-select.nvim" },
            { "nvim-telescope/telescope-symbols.nvim" },
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        },
        opts = {
            -- https://github.com/nvim-telescope/telescope.nvim#themes
            -- https://github.com/nvim-telescope/telescope.nvim#layout-display
            -- https://github.com/nvim-telescope/telescope.nvim#pickers
            extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_cursor({}),
                },
            },
        },
        config = function(_, opts)
            require("telescope").setup(opts)

            -- To get fzf loaded and working with telescope, you need to call
            -- load_extension, somewhere after setup function:
            require("telescope").load_extension("fzf")
            require("telescope").load_extension("ui-select")
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        cmd = "TSUpdateSync",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            ensure_installed = {
                "bash",
                "bibtex",
                "cmake",
                "make",
                "c",
                "cpp",
                "css",
                "dockerfile",
                "html",
                "javascript",
                "json",
                "rust",
                "haskell",
                "lua",
                "toml",
                "yaml",
            },
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
        },
        config = function(_, opts)
            vim.opt.foldmethod = "expr"
            vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
            vim.wo.foldlevel = 99
            -- vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufWinEnter" }, {
            --     pattern = { "*" },
            --     callback = "normal zR"
            -- })

            require('nvim-treesitter.configs').setup(opts)
        end,
        keys = {
            {
                "<leader>ff",
                function()
                    require("telescope.builtin").find_files()
                end,
                desc = "Telescope: Find Files",
            },
            {
                "<leader>fg",
                function()
                    require("telescope.builtin").live_grep()
                end,
                desc = "Telescope: Live Grep",
            },
            {
                "<leader>fb",
                function()
                    require("telescope.builtin").buffers()
                end,
                desc = "Telescope: Buffers",
            },
            {
                "<leader>fh",
                function()
                    require("telescope.builtin").help_tags()
                end,
                desc = "Telescope: Help Tags",
            },
        },
    },
    -- header and bottom
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = {
            { "nvim-tree/nvim-web-devicons" },
        },
        opts = {
            options = {
                theme = "auto",
            },
            sections = {
                lualine_c = {
                    "filename",
                    "require('lsp-status').status()",
                },
            },
            tabline = {},
        },
    },
    {
        "akinsho/bufferline.nvim",
        event = "VeryLazy",
        version = "*",
        dependencies = "nvim-tree/nvim-web-devicons",
        opts = {
            options = {
                mode = "tabs",
                diagnostics = "nvim_lsp",
                separator_style = "slant",
                sort_by = "tabs",
                offsets = {
                    {
                        filetype = "NvimTree",
                        text = "File Explorer",
                        highlight = "Directory",
                        text_align = "left",
                    },
                    {
                        filetype = "nvimtree",
                        text = "File Explorer",
                        highlight = "Directory",
                        text_align = "left",
                    },
                },
            },
        },
    },
    {
        "nvim-lua/lsp-status.nvim",
        config = function(_, _)
            -- LSP-Status
            local lsp_status = require("lsp-status")
            -- completion_customize_lsp_label as used in completion-nvim
            -- Optional: customize the kind labels used in identifying the current function.
            -- g:completion_customize_lsp_label is a dict mapping from LSP symbol kind
            -- to the string you want to display as a label
            -- lsp_status.config { kind_labels = vim.g.completion_customize_lsp_label }

            -- Register the progress handler
            lsp_status.register_progress()

            -- remove that dumb looking 'V'
            lsp_status.config({
                status_symbol = "",
                diagnostics = false,
            })

            vim.api.nvim_create_augroup("LspAttach_lsp_status", {})
            vim.api.nvim_create_autocmd("LspAttach", {
                group = "LspAttach_lsp_status",
                callback = function(args)
                    if not (args.data and args.data.client_id) then
                        return
                    end

                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    lsp_status.on_attach(client)
                end,
            })
        end,
    },
}
