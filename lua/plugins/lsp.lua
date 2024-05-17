local servers = {
	jsonls = {},
	dockerls = {},
	bashls = {},
	gopls = {},
	ruff_lsp = {},
	vimls = {},
	yamlls = {},
	wgsl_analyzer = {},
	taplo = {
		keys = require("config.keymaps").static.taplo,
	},
}

return {
	{
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v3.x',
		config = function()
			local lsp_zero = require('lsp-zero')
			lsp_zero.extend_lspconfig()
			local keymaps = require('config.keymaps')

			lsp_zero.on_attach(function(client, bufnr)
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
						require('lspconfig')[server_name].setup({})
					end,
					rust_analyzer = lsp_zero.noop,
				},
			})

			local cmp = require('cmp')
			local cmp_action = lsp_zero.cmp_action()

			cmp.setup({
				sources = {
					{ name = "nvim_lsp", group_index = 1, },
					{ name = "luasnip",  group_index = 2, },
					{
						name = "buffer",
						keyword_length = 5,
						group_index = 3,
					},
					{ name = "path" },
				},
				mapping = cmp.mapping.preset.insert(keymaps.cmp(cmp, cmp_action)),
				performance = {
					trigger_debounce_time = 500,
					throttle = 550,
					fetching_timeout = 80,
				},
				preselect = cmp.PreselectMode.Item,
				sorting = {
					priority_weight = 2,
					comparators = {
						cmp.config.compare.kind,
						cmp.config.compare.length,
						cmp.config.compare.offset,
						cmp.config.compare.recently_used,
						cmp.config.compare.exact,
						-- cmp.config.compare.scopes,
						-- cmp.config.compare.score,
						-- cmp.config.compare.locality,
						-- cmp.config.compare.sort_text,
						-- cmp.config.compare.order,
					},
				},
				-- matching = {
				-- 	disallow_fuzzy_matching = true,
				-- 	disallow_fullfuzzy_matching = true,
				-- 	disallow_partial_fuzzy_matching = true,
				-- 	disallow_partial_matching = false,
				-- 	disallow_prefix_unmatching = true,
				-- },
				snippet = {
					expand = function(args)
						require('luasnip').lsp_expand(args.body)
					end,
				},
			})

			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())


			lsp_zero.set_server_config({
				capabilities = {
					textDocument = {
						foldingRange = {
							dynamicRegistration = false,
							lineFoldingOnly = true
						}
					}
				}
			})

			vim.g.rustaceanvim = {
				server = {
					capabilities = lsp_zero.get_capabilities()
				},
				on_attach = function(client, bufnr)
					keymaps.rust_lsp(bufnr)
				end,
			}

			vim.o.foldcolumn = '1'
			vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true
			keymaps.cmp_ufo()
		end
	},
	{ 'neovim/nvim-lspconfig' },
	{ "williamboman/mason.nvim" },
	{ "williamboman/mason-lspconfig.nvim" },
	{ 'hrsh7th/cmp-nvim-lsp' },
	{ 'hrsh7th/nvim-cmp' },
	{ 'L3MON4D3/LuaSnip' },
	{ 'windwp/nvim-autopairs' },
	{ 'kevinhwang91/nvim-ufo',            dependencies = 'kevinhwang91/promise-async' },
	{
		'mrcjkb/rustaceanvim',
		version = '^4', -- Recommended
		lazy = false, -- This plugin is already lazy
	}
}
