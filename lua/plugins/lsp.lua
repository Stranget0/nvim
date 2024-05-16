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
			local keymaps = require('config.keymaps')

			lsp_zero.on_attach(function(client, bufnr)
				-- lsp_zero.default_keymaps({ buffer = bufnr })
				keymaps.lsp(bufnr)
			end)

			require('mason').setup({})
			local ensure_installed = {}
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
					{ name = 'nvim_lsp' },
					{ name = "path" },
				},
				mapping = cmp.mapping.preset.insert(keymaps.cmp(cmp, cmp_action)),
				snippet = {
					expand = function(args)
						require('luasnip').lsp_expand(args.body)
					end,
				},
			})


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
	{ 'kevinhwang91/nvim-ufo',            dependencies = 'kevinhwang91/promise-async' },
	{
		'mrcjkb/rustaceanvim',
		version = '^4', -- Recommended
		lazy = false, -- This plugin is already lazy
	}
}
