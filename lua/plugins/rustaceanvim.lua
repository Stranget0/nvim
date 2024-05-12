return { {
	'mrcjkb/rustaceanvim',
	version = '^4', -- Recommended
	lazy = false,  -- This plugin is already lazy
	build = ":MasonInstall codelldb",
	config = function(_, _)
		vim.g.rustaceanvim = {
			-- Plugin configuration
			tools = {
			},
			-- LSP configuration
			server = {
				on_attach = function(client, bufnr)
					-- you can also put keymaps in here
					vim.cmd.RustLsp('renderDiagnostic')
					vim.cmd.RustLsp('testables')


					-- Diagnostic
					-- vim.diagnostic.config({
					-- 	virtual_text = true,
					-- 	virtual_lines = {
					-- 		only_current_line = true,
					-- 	},
					-- 	update_in_insert = false,
					-- 	underline = true,
					-- 	severity_sort = true,
					-- 	float = {
					-- 		focusable = true,
					-- 		border = "rounded",
					-- 		header = "",
					-- 		prefix = "",
					-- 	},
					-- })
					local wk = require("which-key")

					local km, l, api = vim.keymap.set, vim.lsp, vim.api

					wk.register({
						["[g"] = { vim.diagnostic.goto_prev, "go prev" },
						["]g"] = { vim.diagnostic.goto_next, "go next" },
						["<leader>dd"] = { vim.diagnostic.setqflist, "quick fix list" },
						["gD"] = { l.buf.declaration, "go declaration" },
						["gd"] = { l.buf.definition, "go definition" },
						["gi"] = { l.buf.implementation, "go implementation" },
						["<leader>D"] = { l.buf.type_definition, "go type" },
						["gr"] = { l.buf.references, "go references" },
						["<leader>rn"] = { vim.lsp.buf.rename, "rename" },
						["L"] = { vim.lsp.buf.hover, "hover info" },
					}, { buffer = bufnr })

					wk.register({ ["<leader>ca"] = { l.buf.code_action, "code action" }, { buffer = bufnr, mode = { "n", "v" } } })
				end,
				default_settings = {
					-- rust-analyzer language server configuration
					['rust-analyzer'] = {
						checkOnSave = { command = "clippy --message-format=json --target-dir=./target-editor/" }
					},
				},
			},
			-- DAP configuration
			dap = {
			},
		}
	end
} }
