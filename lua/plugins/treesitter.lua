--
-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
--
-- File: plugins/treesitter.lua
-- Description: nvim-treesitter configuration
-- Author: Kien Nguyen-Tuan <kiennt2609@gmail.com>
return {
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
    },
    {
        -- Treesitter interface
        "nvim-treesitter/nvim-treesitter",
        version = false, -- last release is way too old and doesn"t work on Windows
        build = ":TSUpdate",
        config = function(_, opts)
            require("nvim-treesitter.configs").setup({
                -- A list of parser names, or "all"
                ensure_installed = { "go", "python", "dockerfile", "json", "yaml", "markdown", "html", "scss", "css", "vim", "wgsl_bevy", "rust", "ron", "toml", "javascript", "typescript" },
                sync_install = false,
                auto_install = true,

                modules = {
                    ---@diagnostic disable-next-line: missing-fields
                    highlight = {
                        enable = true,
                        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                        -- Using this option may slow down your editor, and you may see some duplicate highlights.
                        -- Instead of true it can also be a list of languages
                        additional_vim_regex_highlighting = false,
                    },

                    ---@diagnostic disable-next-line: missing-fields
                    incremental_selection = {
                        enable = true,
                        keymaps = {
                            init_selection = "gnn", -- set to `false` to disable one of the mappings
                            node_incremental = "grn",
                            scope_incremental = "grc",
                            node_decremental = "grm",
                        },
                    },
                    ---@diagnostic disable-next-line: missing-fields
                    indent = {
                        enable = true
                    }
                },
                ignore_install = {},

            })

            -- require("nvim-treesitter.install").prefer_git = false
            -- require("nvim-treesitter.install").compilers = { "zig", "clang", "gcc" }
        end
    } }
