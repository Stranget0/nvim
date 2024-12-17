return {
    {
        "norcalli/nvim-colorizer.lua",
        config = function(_)
            require("colorizer").setup({
                ["*"] = {

                    RGB      = true,         -- #RGB hex codes
                    RRGGBB   = true,         -- #RRGGBB hex codes
                    names    = true,         -- "Name" codes like Blue
                    RRGGBBAA = true,         -- #RRGGBBAA hex codes
                    rgb_fn   = true,         -- CSS rgb() and rgba() functions
                    hsl_fn   = true,         -- CSS hsl() and hsla() functions
                    css      = true,         -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
                    css_fn   = true,         -- Enable all CSS *functions*: rgb_fn, hsl_fn
                    -- Available modes: foreground, background
                    mode     = 'background', -- Set the display mode.
                }
            })

            -- execute colorizer as soon as possible
            vim.defer_fn(function()
                require("colorizer").attach_to_buffer(0)
            end, 0)
        end
    },
    {
        "folke/twilight.nvim",
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {},
        config = function()
            local highlight = {
                "CursorColumn",
                "Whitespace",
            }

            require("ibl").setup(
                {
                    indent = { highlight = highlight, char = "" },
                    whitespace = {
                        highlight = highlight,
                        remove_blankline_trail = false,
                    },
                    scope = { enabled = false },
                }
            )
        end
    },
    {
        'kosayoda/nvim-lightbulb',
        config = function()
            require("nvim-lightbulb").setup()
        end
    },
    {
        "roobert/action-hints.nvim",
        config = function()
            require("action-hints").setup({
                template = {
                    definition = { text = " ⊛", color = "#add8e6" },
                    references = { text = " ↱%s", color = "#ff6666" },
                },
                use_virtual_text = true,
            })
        end,
    },
    {
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        config = function()
            require("lsp_lines").setup()
        end,
    },
}
