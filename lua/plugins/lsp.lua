--
-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
--
-- File: plugins/lsp.lua
-- Description: LSP setup and config
-- Author: Kien Nguyen-Tuan <kiennt2609@gmail.com>
-- Enable some language servers with the additional completion capabilities offered by nvim-cmp

return {
	{
		-- Mason
		"williamboman/mason.nvim",
		cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
		opts = {
			PATH = "prepend",
			ui = {
				icons = {
					package_pending = " ",
					package_installed = "󰄳 ",
					package_uninstalled = " 󰚌"
				},
			},

			max_concurrent_installers = 10
		},
		config = function(_, opts)
			require("mason").setup(opts)
		end
	},
	{
		-- LSP - Quickstart configs for Nvim LSP
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		lazy = true,
		dependencies = {
			-- Mason
			-- Portable package manager for Neovim that runs everywhere Neovim runs.
			-- Easily install and manage LSP servers, DAP servers, linters, and formatters.
			{ "williamboman/mason.nvim" }, { "williamboman/mason-lspconfig.nvim" },

			{
				"hrsh7th/nvim-cmp",
				opts = function(_, opts)
					opts.sources = opts.sources or {}
					table.insert(opts.sources, { name = "crates" })
				end,
				config = function()
					require("cmp").setup({
						sources = {
							{ name = "path" },
							{ name = "buffer" },
							{ name = "nvim_lsp" },
							{ name = "crates" },
						},
					})
				end,
				dependencies = {
					"L3MON4D3/LuaSnip",
					"hrsh7th/cmp-nvim-lsp",
					"hrsh7th/cmp-path",
					"hrsh7th/cmp-buffer",
					"saadparwaiz1/cmp_luasnip",
					{
						'saecki/crates.nvim',
						event = { "BufRead Cargo.toml" },
						config = function()
							require('crates').setup()
						end,
					},
				},
			}
		},
		opts = {
			-- LSP Server Settings
			servers = {
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
			},
			-- you can do any additional lsp server setup here
			-- return true if you don"t want this server to be setup with lspconfig
			setup = {},
		},
		config = function(_, opts)
			local servers = opts.servers
			local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

			capabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			}

			local function setup(server)
				local server_opts = vim.tbl_deep_extend("force", {
					capabilities = vim.deepcopy(capabilities)
				}, servers[server] or {})

				if opts.setup[server] then
					if opts.setup[server](server, server_opts) then
						return
					end
				elseif opts.setup["*"] then
					if opts.setup["*"](server, server_opts) then
						return
					end
				end
				require("lspconfig")[server].setup(server_opts)
			end

			-- temp fix for lspconfig rename
			-- https://github.com/neovim/nvim-lspconfig/pull/2439
			local mappings = require("mason-lspconfig.mappings.server")
			if not mappings.lspconfig_to_package.lua_ls then
				mappings.lspconfig_to_package.lua_ls = "lua-language-server"
				mappings.package_to_lspconfig["lua-language-server"] = "lua_ls"
			end

			local mlsp = require("mason-lspconfig")
			local available = mlsp.get_available_servers()

			local ensure_installed = {} ---@type string[]
			for server, server_opts in pairs(servers) do
				if server_opts then
					server_opts = server_opts == true and {} or server_opts
					-- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
					if server_opts.mason == false or not vim.tbl_contains(available, server) then
						setup(server)
					else
						ensure_installed[#ensure_installed + 1] = server
					end
				end
			end

			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = ensure_installed,
				automatic_installation = true
			})
			require("mason-lspconfig").setup_handlers({ setup })
		end
	},
}
