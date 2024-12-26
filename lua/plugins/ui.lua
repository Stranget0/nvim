local f = require("utils.functions")
local icons = require("config.icons")
local colors = require("oldworld.palette")
local keys = require("config.keyboard").keys

return {
    { "echasnovski/mini.icons", opts = {} },
    {
        -- decorations
        'stevearc/dressing.nvim',
        opts = {
            border = "shadow",
        },
    },
    {
        'rcarriga/nvim-notify',
        config = function()
            require('notify').setup()
            vim.notify = require("notify")
            vim.keymap.set('n', keys.notifications.history, "<cmd>Telescope notify<cr>",
                { desc = "show history", noremap = true })
            vim.keymap.set('n', keys.notifications.clear, function()
                require("notify").dismiss({ pending = false, silent = false })
            end, { desc = "clear notifications", noremap = true })
        end
    },
    {
        -- sticky code context
        "nvim-treesitter/nvim-treesitter-context",
        config = function()
            require("treesitter-context").setup({
                max_lines = 5,
                mode = "topline",
            })
        end
    },
    {
        -- task runner
        'stevearc/overseer.nvim',
        config = function(opts)
            require('overseer').setup(opts)
            vim.keymap.set("n", keys.overseer.open_list, "<cmd>OverseerRun<cr>", { desc = "Overseer run" })
            vim.keymap.set("n", keys.overseer.run_build, "<cmd>OverseerBuild<cr>", { desc = "Overseer build" })
        end
    },
    {
        -- code outline
        "hedyhli/outline.nvim",
        lazy = true,
        cmd = { "Outline", "OutlineOpen" },
        keys = {
            {
                keys.code_outline.open,
                function()
                    local outline = require("outline")
                    if outline.is_open() then
                        vim.cmd("OutlineFocus")
                    else
                        vim.cmd("Outline")
                    end
                end,
                desc = "Code outline"
            },
            {
                keys.code_outline.close,
                function()
                    vim.cmd("OutlineClose")
                end,
                desc = "Close outline"
            }
        },
        opts = {
            auto_close = true,
        }
    },
    {
        -- bottom bar
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            local theme = {
                normal = {
                    a = { fg = colors.black, bg = colors.blue },
                    b = { fg = colors.white, bg = colors.black },
                    c = { fg = colors.blue },
                },

                insert = { a = { fg = colors.black, bg = colors.blue } },
                visual = { a = { fg = colors.black, bg = colors.cyan } },
                replace = { a = { fg = colors.black, bg = colors.red } },

                inactive = {
                    a = { fg = colors.white, bg = colors.black },
                    b = { fg = colors.white, bg = colors.black },
                    c = { fg = colors.white },
                },
            }

            local modecolor = {
                n = colors.red,
                i = colors.cyan,
                v = colors.purple,
                [""] = colors.purple,
                V = colors.red,
                c = colors.yellow,
                no = colors.red,
                s = colors.yellow,
                S = colors.yellow,
                [""] = colors.yellow,
                ic = colors.yellow,
                R = colors.green,
                Rv = colors.purple,
                cv = colors.red,
                ce = colors.red,
                r = colors.cyan,
                rm = colors.cyan,
                ["r?"] = colors.cyan,
                ["!"] = colors.red,
                t = colors.bright_red,
            }

            local separators = {
                left = { left = '' },
                right = { right = '' },
                both_inv = { left = '', right = '' },
                both = { right = '', left = '' }
            }
            local padding = 0
            local with_left = function(element)
                return vim.tbl_extend("keep", element, { separator = separators.left, right_padding = padding })
            end

            local with_right = function(element)
                return vim.tbl_extend("keep", element, { separator = separators.right, left_padding = padding })
            end

            local with_both = function(element)
                return vim.tbl_extend("keep", element, { separator = separators.both })
            end

            local with_none = function(element)
                return element
            end

            local space_element = function()
                return " "
            end
            local space = {
                space_element,
                color = { bg = colors.bg, fg = colors.blue },
            }

            local buffers = {
                'buffers',
                show_filename_only = true,       -- Shows shortened relative path when set to false.
                hide_filename_extension = false, -- Hide filename extension when set to true.
                show_modified_status = true,     -- Shows indicator when the buffer is modified.

                mode = 2,
                -- 0: Shows buffer name
                -- 1: Shows buffer index
                -- 2: Shows buffer name + buffer index
                -- 3: Shows buffer number
                -- 4: Shows buffer name + buffer number

                max_length = vim.o.columns * 2 / 3,
                -- Maximum width of buffers component,
                -- it can also be a function that returns
                -- the value of `max_length` dynamically.

                filetype_names = {
                    TelescopePrompt = 'Telescope',
                    dashboard = 'Dashboard',
                    packer = 'Packer',
                    fzf = 'FZF',
                    alpha = 'Alpha',
                    help = 'Help',
                    man = 'Man',
                    lspinfo = 'LSP',
                    qf = 'Quickfix',
                    startuptime = 'StartupTime',
                    startify = 'Startify',
                    oil = 'Oil',
                    fugitive = 'Fugitive',
                    lazy = 'Lazy',
                },
                -- Shows specific buffer name for that filetype ( { `filetype` = `buffer_name`, ... } )


                buffers_color = {
                    -- Same values as the general color option can be used here.
                    active = 'luline_{section}_normal',      -- Color for active buffer.
                    inactive = 'lualine_{section}_inactive', -- Color for inactive buffer.
                },
                symbols = {
                    modified = icons.modified,   -- Text to show when the buffer is modified
                    alternate_file = icons.hash, -- Text to show to identify the alternate file
                    directory = icons.hash,      -- Text to show when the buffer is a directory
                },
            }

            local filename = {
                "filename",
                color = { bg = colors.black, fg = colors.white },
                path = 1,
                newfile_status = true,
            }

            local filetype = {
                "filetype",
                icons_enabled = false,
                color = { bg = colors.gray2, fg = colors.blue, gui = "italic" },
                symbols = {
                    modified = icons.modified, -- Text to show when the file is modified.
                    readonly = '[-]',          -- Text to show when the file is non-modifiable or readonly.
                    unnamed = '[No Name]',     -- Text to show for unnamed buffers.
                    newfile = '[New]',         -- Text to show for newly created file before first write
                }
            }

            local branch = {
                "FugitiveHead",
                icon = "",
                color = { bg = colors.blue, fg = colors.bg, gui = "bold" },
            }

            local location = {
                "location",
                color = function()
                    return { bg = modecolor[vim.fn.mode()], fg = colors.bg, gui = "bold" }
                end
            }

            local function git_signs_source()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                    return {
                        added = gitsigns.added,
                        modified = gitsigns.changed,
                        removed = gitsigns.removed
                    }
                end
            end

            local diff = {
                "diff",
                color = { bg = colors.gray1, fg = colors.bg, gui = "bold" },
                symbols = { added = icons.git.Add, modified = icons.git.Change, removed = icons.git.Delete },
                source = git_signs_source,

                diff_color = {
                    added = { fg = colors.green },
                    modified = { fg = colors.yellow },
                    removed = { fg = colors.red },
                },
            }

            local modes = {
                "mode",
                color = function()
                    return { bg = modecolor[vim.fn.mode()], fg = colors.bg, gui = "bold" }
                end,
            }

            local diagnostics = {
                "diagnostics",
                bg = { "nvim_diagnostic" },
                symbols = {
                    error = icons.statusline.Error .. " ",
                    warn = icons.statusline.Warn .. " ",
                    info = icons.statusline.Info .. " ",
                    hint = icons.statusline.Hint .. " "
                },
                diagnostics_color = {
                    error = { fg = colors.red },
                    warn = { fg = colors.yellow },
                    info = { fg = colors.purple },
                    hint = { fg = colors.cyan },
                },
                color = { bg = colors.gray1, fg = colors.blue, gui = "bold" },
            }

            local searchcount = {
                "searchcount",
                color = { bg = colors.gray0, fg = colors.gray3, gui = "italic" },
            }


            vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
            vim.api.nvim_create_autocmd("User", {
                group = "lualine_augroup",
                pattern = "LspProgressStatusUpdated",
                callback = require("lualine").refresh,
            })

            require('lualine').setup({
                options = {
                    theme = theme,
                    component_separators = { left = '', right = '' },
                    section_separators = separators.both_inv,
                    always_divide_middle = true,
                    globalstatus = true,
                },
                sections = {
                    lualine_a = { with_left(modes) },
                    lualine_b = { with_right(filename), space, with_both(diagnostics), space, with_both(searchcount) },
                    lualine_c = {
                        '%=',
                    },
                    lualine_x = {},
                    lualine_y = { with_both(branch), with_both(diff), space },
                    lualine_z = {
                        with_both(location),
                    },
                },
                inactive_sections = {
                    lualine_a = { filename },
                    lualine_b = {},
                    lualine_c = {},
                    lualine_x = {},
                    lualine_y = {},
                    lualine_z = { location },
                },
                tabline = {
                },
                extensions = { "oil", "fzf", "fugitive", "symbols-outline", "lazy" },
            })
        end
    },
    {
        -- top bar
        "willothy/nvim-cokeline",
        dependencies = {
            "nvim-lua/plenary.nvim",       -- Required for v0.4.0+
            "nvim-tree/nvim-web-devicons", -- If you want devicons
            -- "stevearc/resession.nvim"      -- Optional, for persistent history
        },
        config = function()
            local get_hl = require('cokeline.hlgroups').get_hl_attr
            local is_picking_focus = require('cokeline.mappings').is_picking_focus
            local is_picking_close = require('cokeline.mappings').is_picking_close

            local is_modified = {
                text = function(buffer)
                    if buffer.is_modified then
                        return icons.modified
                    end
                    return ''
                end
            }

            local buffer_index = {
                text = function(buffer)
                    return buffer.index
                end
            }

            local diagnostic_icon = {
                text = function(buffer)
                    local is_error = buffer.diagnostics.errors > 0
                    local is_warning = buffer.diagnostics.warnings > 0
                    local is_hint = buffer.diagnostics.hints > 0
                    local is_info = buffer.diagnostics.infos > 0

                    if is_error then
                        return " " .. icons.diagnostics.Error
                    elseif
                        is_warning then
                        return " " .. icons.diagnostics.Warn
                    elseif
                        is_info then
                        return " " .. icons.diagnostics.Info
                    elseif
                        is_hint then
                        return " " .. icons.diagnostics.Hint
                    else
                        return ''
                    end
                end,

                fg = function(buffer)
                    local is_error = buffer.diagnostics.errors > 0
                    local is_warning = buffer.diagnostics.warnings > 0
                    local is_hint = buffer.diagnostics.hints > 0
                    local is_info = buffer.diagnostics.infos > 0

                    if is_error then
                        return get_hl("DiagnosticError", "fg")
                    elseif
                        is_warning then
                        return get_hl("DiagnosticWarn", "fg")
                    elseif
                        is_hint then
                        return get_hl("DiagnosticHint", "fg")
                    elseif
                        is_info then
                        return get_hl("DiagnosticInfo", "fg")
                    else
                        return get_hl("Normal", "fg")
                    end
                end,

            }


            local file_icon = {
                text = function(buffer)
                    if (is_picking_focus() or is_picking_close())
                    then
                        return buffer.pick_letter
                    else
                        return buffer.devicon.icon
                    end
                end,
                fg = function(buffer)
                    if is_picking_close() then
                        return get_hl("DiagnosticError", "fg")
                    elseif
                        is_picking_focus() then
                        get_hl("DiagnosticOk", "fg")
                    else
                        return buffer.devicon.color
                    end
                end,
            }

            local file_name = {
                text = function(buffer) return buffer.filename end,
                bold = function(buffer) return buffer.is_focused end
            }

            local unique_prefix = {
                text = function(buffer)
                    return buffer.unique_prefix
                end,
                style = 'italic',
                truncation = {
                    priority = 3,
                    direction = 'left',
                },
            }

            local padding_l = {
                text = '  ',
            }
            local padding_s = {
                text = " "
            }


            require('cokeline').setup({
                show_if_buffers_are_at_least = 1,
                fill_hl = "StatusLine",

                default_hl = {
                    fg = function(buffer)
                        return buffer.devicon.color or get_hl("Normal", "fg")
                    end,
                    bg = function(buffer)
                        return not buffer.is_focused and
                            get_hl("StatusLine", "bg")
                            or
                            get_hl("Normal", "bg")
                    end,
                },
                components = {
                    padding_l,
                    buffer_index,
                    padding_s,
                    file_icon,
                    unique_prefix,
                    file_name,
                    is_modified,
                    diagnostic_icon,
                    padding_l,
                },

                tabs = {
                    placement = "right",
                    components = {}
                },
                buffers = {
                    filter_valid = function(buffer)
                        return buffer.index <= 4 -- Show only the first 4 buffers
                    end,
                }
            })


            local mappings = require("cokeline.mappings")
            local buffer_api = require("cokeline.buffers")

            vim.keymap.set("n", keys.buffers.pick_focus, function() mappings.pick("focus") end,
                { desc = "Pick buffer to focus" })
            vim.keymap.set("n", keys.buffers.pick_close, function() mappings.pick("close") end,
                { desc = "Pick buffer to close" })
            vim.keymap.set("n", keys.prev, "<Plug>(cokeline-focus-prev)", { silent = true, desc = "Focus next buffer" })
            vim.keymap.set("n", keys.next, "<Plug>(cokeline-focus-next)", { silent = true, desc = "Focus prev buffer" })
            vim.keymap.set("n", keys.buffers.close_other, function()
                local buffers = buffer_api.get_visible()
                local current = buffer_api.get_current()
                for i = 1, #buffers do
                    local buffer = buffers[#buffers - i + 1]
                    if not current and buffer or (current and buffer and buffer.index ~= current.index) then
                        mappings.by_index("close", buffer.index)
                    end
                end
            end, { desc = "Close other buffers" })

            vim.keymap.set("n", keys.buffers.close, function()
                local current = buffer_api.get_current()
                if current then
                    mappings.by_index("close", current.index)
                end
            end, { desc = "Close active buffer" })

            for i = 1, 9 do
                vim.keymap.set(
                    "n",
                    (keys.buffers.focus):format(i),
                    ("<Plug>(cokeline-focus-%s)"):format(i),
                    { silent = true, desc = ("focus buffer %s"):format(i) }
                )
                vim.keymap.set(
                    "n",
                    (keys.buffers.switch):format(i),
                    ("<Plug>(cokeline-switch-%s)"):format(i),
                    { silent = true, desc = ("switch to buffer %s"):format(i) }
                )
            end

            vim.api.nvim_create_autocmd("BufEnter", {
                callback = function()
                    local buffers = buffer_api.get_visible()
                    if #buffers > 4 then
                        mappings.by_index("close", 4)
                    end
                end,
            })
        end
    }
}
