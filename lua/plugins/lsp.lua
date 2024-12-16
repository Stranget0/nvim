local icons = require("config.icons")
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
        keys = require("config.keymaps").static.taplo,
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
            local keymaps = require('config.keymaps')

            lsp.set_sign_icons({
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
            })

            lsp.on_attach(function(client, bufnr)
                keymaps.lsp(bufnr)
            end)

            vim.g.rustaceanvim = {
                server = {
                    capabilities = lsp.get_capabilities()
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
                mapping = cmp.mapping.preset.insert(keymaps.cmp(cmp, cmp_action)),
                preselect = cmp.PreselectMode.Item,
                performance = {
                    debounce = 100,
                    throttle = 200,
                    fetching_timeout = 1000,
                    confirm_resolve_timeout = 1000,
                    async_budget = 1000,
                    max_view_entries = 100,

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

            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end
    },

    {
        'mrcjkb/rustaceanvim',
        version = '^5', -- Recommended
        lazy = false, -- This plugin is already lazy
    },
    {
        'saecki/crates.nvim',
        event = { "BufRead Cargo.toml" },
        tag = "stable",
        config = function()
            require('crates').setup()
        end,
    },
    { 'neovim/nvim-lspconfig' },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/nvim-cmp' },
    { 'L3MON4D3/LuaSnip' },
    'windwp/nvim-autopairs',
}
