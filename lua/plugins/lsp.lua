local icons = require("config.icons")
local keys = require("config.keyboard").keys

local servers = {
    jsonls = {},
    dockerls = {},
    bashls = {},
    gopls = {},
    ruff_lsp = {},
    vimls = {},
    yamlls = {},
    eslint = {},
    lua_ls = {
        settings = {
            Lua = {
                completion = {
                    callSnippet = "Replace"
                }
            }
        }
    },
    taplo = {
        keys = {
            {
                keys.hover_info,
                function()
                    if vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
                        require("crates").show_popup()
                    else
                        vim.lsp.buf.hover()
                    end
                end,
                desc = "Show Crate Documentation",
            },
        },
    },
}



local sort_by_kind = function(entry1, entry2)
    local types = require("cmp.types")
    local kind1 = entry1:get_kind() --- @type lsp.CompletionItemKind | number
    local kind2 = entry2:get_kind() --- @type lsp.CompletionItemKind | number

    local kind = types.lsp.CompletionItemKind
    local priority_overrides = {
        [kind.Constant] = -10,
        [kind.Property] = -9,
        [kind.Field] = -8,
        [kind.Method] = -7,
        [kind.EnumMember] = -6,
        [kind.Snippet] = -5,
    }

    kind1 = priority_overrides[kind1] or kind1
    kind2 = priority_overrides[kind2] or kind2

    if kind1 ~= kind2 then
        local diff = kind1 - kind2
        if diff < 0 then
            return true
        elseif diff > 0 then
            return false
        end
    end
    return nil
end


return {
    {
        'VonHeikemen/lsp-zero.nvim',
        priority = 1,
        branch = 'v3.x',
        config = function()
            local lsp = require('lsp-zero')
            lsp.extend_lspconfig()

            lsp.set_sign_icons({
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
            })

            local on_attach = function(client, bufnr)
                vim.keymap.set("n", keys.next_diagnostic, vim.diagnostic.goto_prev,
                    { desc = "go prev diagnostic", buffer = bufnr })
                vim.keymap.set("n", keys.prev_diagnostic, vim.diagnostic.goto_next,
                    { desc = "go next diagnostic", buffer = bufnr })
                vim.keymap.set("n", keys.diagnostic_list, "<cmd>Telescope diagnostics<cr>",
                    { desc = "diagnostics", buffer = bufnr })
                vim.keymap.set("n", keys.go_definition, "<cmd>Telescope lsp_definitions<cr>",
                    { desc = "go definition", buffer = bufnr })
                vim.keymap.set("n", keys.go_type, "<cmd>Telescope lsp_type_definitions<cr>",
                    { desc = "go type", buffer = bufnr })
                vim.keymap.set("n", keys.go_references, "<cmd>Telescope lsp_references<cr>",
                    { desc = "go references", buffer = bufnr })
                vim.keymap.set("n", keys.rename, vim.lsp.buf.rename, { desc = "rename", buffer = bufnr })
                vim.keymap.set("n", keys.hover_info, vim.lsp.buf.hover, { desc = "hover info", buffer = bufnr })
                vim.keymap.set({ "n", "v" }, keys.code_action, vim.lsp.buf.code_action,
                    { desc = "code action", buffer = bufnr })
            end

            lsp.on_attach(on_attach)

            vim.g.rustaceanvim = {
                server = {
                    capabilities = lsp.get_capabilities(),
                    on_attach = function(client, bufnr)
                        on_attach(client, bufnr)

                        vim.keymap.set("n", keys.code_action,
                            function()
                                vim.cmd.RustLsp("codeAction")
                            end,
                            { desc = "code action", buffer = bufnr, silent = true }
                        )

                        vim.keymap.set("n", keys.hover_info,
                            function()
                                vim.cmd.RustLsp({ 'hover', 'actions' })
                            end,
                            { desc = "hover actions", buffer = bufnr, silent = true }
                        )

                        vim.keymap.set(
                            { "n", "v" },
                            keys.code_move_up,
                            function()
                                vim.cmd.RustLsp { 'moveItem', 'up' }
                            end,
                            { desc = "move item up", buffer = bufnr, silent = true }
                        )
                        vim.keymap.set(
                            { "n", "v" },
                            keys.code_move_down,
                            function()
                                vim.cmd.RustLsp { 'moveItem', 'down' }
                            end,
                            { desc = "move item down", buffer = bufnr, silent = true }
                        )

                        vim.keymap.set(
                            "n",
                            keys.runnables,
                            function()
                                vim.cmd.RustLsp('runnables')
                            end,
                            { desc = "runnables", buffer = bufnr, silent = true }
                        )

                        vim.keymap.set(
                            "n",
                            keys.last_runnable,
                            function()
                                vim.cmd.RustLsp { 'runnables', bang = true }
                            end,
                            { desc = "run last runnable", buffer = bufnr, silent = true })
                    end,
                },
            }
            require('mason').setup({})
            local ensure_installed = { "codellb" }
            for server, config in pairs(servers) do
                table.insert(ensure_installed, server)
            end
            require('mason-lspconfig').setup({
                ensure_installed,
                handlers = {
                    function(server_name)
                        require('lspconfig')[server_name].setup(servers[server_name] or {})
                    end,
                    rust_analyzer = lsp.noop,

                },
            })

            local cmp = require('cmp')
            local cmp_action = lsp.cmp_action()

            cmp.setup({
                sources = {
                    {
                        name = "lazydev",
                        group_index = 0, -- set group index to 0 to skip loading LuaLS completions
                    },
                    {
                        name = "nvim_lsp",
                        entry_filter = function(entry, ctx)
                            return require('cmp.types').lsp.CompletionItemKind[entry:get_kind()] ~= 'Text'
                        end,
                        keyword_length = 0,
                        group_index = 1
                    },
                    { name = "luasnip", group_index = 2 },
                    { name = "buffer",  max_item_count = 15, group_index = 3 },
                    { name = "crates",  max_item_count = 15 },
                    { name = "path",    max_item_count = 15 },
                },
                mapping = cmp.mapping.preset.insert({

                    [keys.cmp.confirm] = cmp.mapping.confirm({ select = true }),
                    [keys.cmp.open_completion_menu] = cmp.mapping.complete(),
                    -- scroll up and down the documentation window
                    [keys.cmp.next_completion] = cmp.mapping.scroll_docs(-4),
                    [keys.cmp.prev_completion] = cmp.mapping.scroll_docs(4),
                    -- navigate between snippet placeholders
                    [keys.cmp.jump_forward] = cmp_action.luasnip_jump_forward(),
                    [keys.cmp.jump_backward] = cmp_action.luasnip_jump_backward(),

                }),
                preselect = cmp.PreselectMode.Item,
                performance = {
                    debounce = 100,
                    throttle = 200,
                    fetching_timeout = 1000,
                    confirm_resolve_timeout = 1000,
                    async_budget = 1000,
                    max_view_entries = 1000,
                },
                sorting = {
                    priority_weight = 2,
                    comparators = {
                        cmp.config.compare.exact,
                        sort_by_kind,
                        cmp.config.compare.recently_used,
                        cmp.config.compare.length,
                        cmp.config.compare.offset,
                    },
                },
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
            })

            -- local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            -- cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end
    },

    {
        'mrcjkb/rustaceanvim',
        version = '^5', -- Recommended
        lazy = false,   -- This plugin is already lazy
    },
    {
        'saecki/crates.nvim',
        event = { "BufRead Cargo.toml" },
        tag = "stable",
        config = function()
            ---@diagnostic disable-next-line: missing-parameter
            require('crates').setup()
        end,
    },
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "luvit-meta/library", words = { "vim%.uv" } },
            },
        },
        dependencies = {
            "hrsh7th/nvim-cmp",
        }
    },
    { "Bilal2453/luvit-meta",             lazy = true }, -- optional `vim.uv` typings
    { 'neovim/nvim-lspconfig' },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/nvim-cmp' },
    { 'L3MON4D3/LuaSnip' },
    'windwp/nvim-autopairs',
    {
        "j-hui/fidget.nvim",
        lazy = false,
        priority = 0,
        opts = {
            -- Options related to LSP progress subsystem
            progress = {
                suppress_on_insert = true,   -- Suppress new messages while in insert mode
                ignore_done_already = false, -- Ignore new tasks that are already complete

                display = {
                    render_limit = 16,          -- How many LSP messages to show at once
                    done_ttl = 1,               -- How long a message should persist after completion
                    done_icon = icons.arm_flex, -- Icon shown when all LSP progress tasks are complete
                    progress_icon =             -- Icon shown when LSP progress tasks are in progress
                    { pattern = "dots", period = 1 },
                },

            },

            -- Options related to notification subsystem
            notification = {
                redirect = -- Conditionally redirect notifications to another backend
                    function(msg, level, opts)
                        if opts and opts.on_open then
                            vim.notify(msg, level, opts)
                        end
                    end,


                -- Options related to the notification window and buffer
                window = {
                    winblend = 100,    -- Background color opacity in the notification window
                    border = "shadow", -- Border around the notification window
                },
            },

            -- Options related to integrating with other plugins
            integration = {
            },
        }
    }
}
