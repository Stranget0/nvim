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

return {
	{
		'VonHeikemen/lsp-zero.nvim',
		priority = 1,
		branch = 'v3.x',
		config = function()
			require("neodev").setup()
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
					{ name = "luasnip", max_item_count = 15, group_index = 2 },
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
					max_view_entries = 20,

				},
				sorting = {
					priority_weight = 2,
					comparators = {
						cmp.config.compare.kind,
						cmp.config.compare.length,
						cmp.config.compare.offset,
						cmp.config.compare.recently_used,
						cmp.config.compare.exact,
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

	{ 'neovim/nvim-lspconfig' },
	{ "williamboman/mason.nvim" },
	{ "williamboman/mason-lspconfig.nvim" },
	{ 'hrsh7th/cmp-nvim-lsp' },
	{ 'hrsh7th/nvim-cmp' },
	{ 'L3MON4D3/LuaSnip' },
	'windwp/nvim-autopairs',
	"folke/neodev.nvim"
}
