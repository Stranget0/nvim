local keys = require("config.keyboard").keys.github

return {
    {
        "tpope/vim-fugitive"
    },
    {
        -- Git integration for buffers
        "lewis6991/gitsigns.nvim",
        opts = {
            signs = {
                add = {
                    hl = "GitSignsAdd",
                    text = "│",
                    numhl = "GitSignsAddNr",
                    linehl = "GitSignsAddLn"
                },
                change = {
                    hl = "GitSignsChange",
                    text = "│",
                    numhl = "GitSignsChangeNr",
                    linehl = "GitSignsChangeLn"
                },
                delete = {
                    hl = "GitSignsDelete",
                    text = "_",
                    numhl = "GitSignsDeleteNr",
                    linehl = "GitSignsDeleteLn"
                },
                topdelete = {
                    hl = "GitSignsDelete",
                    text = "‾",
                    numhl = "GitSignsDeleteNr",
                    linehl = "GitSignsDeleteLn"
                },
                changedelete = {
                    hl = "GitSignsChange",
                    text = "~",
                    numhl = "GitSignsChangeNr",
                    linehl = "GitSignsChangeLn"
                },
                untracked = {
                    hl = "GitSignsAdd",
                    text = "┆",
                    numhl = "GitSignsAddNr",
                    linehl = "GitSignsAddLn"
                }
            },
            signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
            numhl = false,     -- Toggle with `:Gitsigns toggle_numhl`
            linehl = false,    -- Toggle with `:Gitsigns toggle_linehl`
            word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
            watch_gitdir = {
                interval = 1000,
                follow_files = true
            },
            attach_to_untracked = true,
            current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
            sign_priority = 6,
            update_debounce = 100,
            status_formatter = nil, -- Use default
            max_file_length = 40000,
            preview_config = {
                -- Options passed to nvim_open_win
                border = "shadow",
                style = "minimal",
                relative = "cursor",
                row = 0,
                col = 1
            },
            yadm = {
                enable = false
            }
        },
        ---@param opts TSConfig
        config = function(_, opts)
            require("gitsigns").setup(
                {
                    signs                        = {
                        add          = { text = '░' },
                        change       = { text = '░' },
                        delete       = { text = '_' },
                        topdelete    = { text = '‾' },
                        changedelete = { text = '~' },
                        untracked    = { text = '┆' },
                    },
                    signcolumn                   = true,  -- Toggle with `:Gitsigns toggle_signs`
                    numhl                        = false, -- Toggle with `:Gitsigns toggle_numhl`
                    linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
                    word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
                    watch_gitdir                 = {
                        follow_files = true
                    },
                    auto_attach                  = true,
                    attach_to_untracked          = false,
                    current_line_blame           = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
                    current_line_blame_opts      = {
                        virt_text = true,
                        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
                        delay = 1000,
                        ignore_whitespace = false,
                        virt_text_priority = 100,
                    },
                    current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
                    sign_priority                = 6,
                    update_debounce              = 100,
                    status_formatter             = nil,   -- Use default
                    max_file_length              = 40000, -- Disable if file is longer than this (in lines)
                    preview_config               = {
                        -- Options passed to nvim_open_win
                        border = 'shadow',
                        style = 'minimal',
                        relative = 'cursor',
                        row = 0,
                        col = 1
                    },
                    on_attach                    = function(bufnr)
                        local gitsigns = require('gitsigns')

                        local function map(mode, l, r, desc, _opts)
                            local opts = _opts or {}
                            opts.buffer = bufnr
                            opts.desc = desc
                            vim.keymap.set(mode, l, r, opts)
                        end

                        -- Navigation
                        map('n', keys.git_next_hunk, function()
                            if vim.wo.diff then
                                vim.cmd.normal({ ']c', bang = true })
                            else
                                gitsigns.nav_hunk('next')
                            end
                        end, "next hunk")

                        map('n', keys.git_prev_hunk, function()
                            if vim.wo.diff then
                                vim.cmd.normal({ '[c', bang = true })
                            else
                                gitsigns.nav_hunk('prev')
                            end
                        end, "prev hunk")


                        -- Actions
                        map('n', keys.git_stage_hunk, gitsigns.stage_hunk, "stage hunk")
                        map('n', keys.git_reset_hunk, gitsigns.reset_hunk, "reset hunk")
                        map('v', keys.git_stage_hunk,
                            function() gitsigns.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
                            "stage hunk")
                        map('v', keys.git_reset_hunk,
                            function() gitsigns.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
                            "reset hunk")
                        map('n', keys.git_stage_buffer, gitsigns.stage_buffer, "stage buffer")
                        map('n', keys.git_undo_stage_hunk, gitsigns.undo_stage_hunk, "undo stage hunk")
                        map('n', keys.git_reset_buffer_hunks, gitsigns.reset_buffer, "reset buffer")
                        map('n', keys.git_preview_hunk, gitsigns.preview_hunk, "preview hunk")
                        map('n', keys.git_blame_line, function() gitsigns.blame_line { full = true } end, "blame line")
                        map('n', keys.git_blame_line_toggle, gitsigns.toggle_current_line_blame,
                            "toggle current line blame")
                        map('n', keys.git_diffthis, gitsigns.diffthis, "diffthis")
                        map('n', keys.git_diffthis_tilde, function() gitsigns.diffthis('~') end, "diffthis")
                        map('n', keys.git_toggle_deleted_hunk, gitsigns.toggle_deleted, "toggle deleted")

                        -- Text object
                        map({ 'o', 'x' }, keys.git_select_hunk, ':<C-U>Gitsigns select_hunk<CR>', "select hunk")
                    end
                }
            )
        end
    }
}
