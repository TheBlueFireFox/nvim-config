return {
    {
        "goolord/alpha-nvim",
        lazy = false,
        dependencies = {
            { "nvim-tree/nvim-web-devicons" },
        },
        config = function()
            local conf = require("alpha.themes.dashboard")
            local buttons = {
                type = "group",
                val = {
                    conf.button("e", "  New file", "<cmd>ene <CR>"),
                    conf.button(vim.g.mapleader .. "ff", "󰍉  Find file"),
                    conf.button(vim.g.mapleader .. "fh", "󰈢  Recently opened files"),
                    conf.button(vim.g.mapleader .. "fg", "󰈬  Live Grep"),
                    conf.button(vim.g.mapleader .. "sl", "󰁯  Open last session"),
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

            require("alpha").setup(conf.config)
        end,
    },
    {
        "Shatur/neovim-session-manager",
        lazy = false,
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
        },
    },
}
