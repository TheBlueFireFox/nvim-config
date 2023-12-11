return {
    {
        "goolord/alpha-nvim",
        event = "VimEnter",
        dependencies = {
            { "nvim-tree/nvim-web-devicons" },
        },
        opts = function()
            local conf = require("alpha.themes.dashboard")
            local buttons = {
                type = "group",
                val = {
                    conf.button("e", "  New file", "<cmd>ene <CR>"),
                    conf.button(vim.g.mapleader .. "ff", "󰍉  Find file"),
                    conf.button(vim.g.mapleader .. "fh", "󰈢  Recently opened files"),
                    conf.button(vim.g.mapleader .. "fg", "󰈬  Live Grep"),
                    conf.button(vim.g.mapleader .. "sl", "󰁯  Open last session"),
                    conf.button(vim.g.mapleader .. "sf", "󰁯  Open last folder session"),
                },
                opts = {
                    spacing = 1,
                },
            }

            conf.config.layout = {
                { type = "padding", val = 2 },
                conf.section.header,
                { type = "padding", val = 2 },
                buttons,
                conf.section.footer,
            }

            return conf.config
        end,
    },
    {
        "Shatur/neovim-session-manager",
        event = "VeryLazy",
        dependencies = {
            { "nvim-lua/plenary.nvim" },
        },
        opts = function(_, opts)
            opts.autoload_mode = require("session_manager.config").AutoloadMode.Disabled
            return opts
        end,
        keys = {
            {
                "<leader>sl",
                "<cmd>SessionManager load_last_session<CR>",
                desc = "Open last session",
            },
            {
                "<leader>sf",
                "<cmd>SessionManager load_current_dir_session<CR>",
                desc = "Open last folder session",
            },
        },
    },
}
