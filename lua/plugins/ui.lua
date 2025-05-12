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
            vim.api.nvim_create_autocmd("BufReadPost", {
                command = [[if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif]],
            })

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
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release -DCMAKE_POLICY_VERSION_MINIMUM=3.5 && cmake --build build --config Release",
            },
        },
        -- use <M-d> to remove selected buffers
        opts = function()
            return {
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_cursor({}),
                    },
                },
                defaults = {
                    preview = {
                        treesitter = {
                            disable = { "tex" },
                        },
                    },
                },
            }
        end,
        config = function(_, opts)
            -- https://github.com/nvim-telescope/telescope.nvim#themes
            -- https://github.com/nvim-telescope/telescope.nvim#layout-display
            -- https://github.com/nvim-telescope/telescope.nvim#pickers
            require("telescope").setup(opts)
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
                "c",
                "cmake",
                "cpp",
                "css",
                "dockerfile",
                "haskell",
                "html",
                "javascript",
                "json",
                "lua",
                "make",
                "query",
                "rust",
                "toml",
                "vim",
                "vimdoc",
                "yaml",
            },
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
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
    {
        "akinsho/bufferline.nvim",
        event = "VeryLazy",
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
                    function()
                        -- invoke `progress` here.
                        return require("lsp-progress").progress()
                    end,
                },
            },
        },
    },
    {
        "linrongbin16/lsp-progress.nvim",
        opts = function()
            -- listen lsp-progress event and refresh lualine
            vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
            vim.api.nvim_create_autocmd("User", {
                group = "lualine_augroup",
                pattern = "LspProgressStatusUpdated",
                callback = require("lualine").refresh,
            })
        end,
    },
}
