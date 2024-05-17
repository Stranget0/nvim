local slow_format_filetypes = {}

return {
	{
		'stevearc/conform.nvim',
		-- #region lazy loading
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = require("config.keymaps").static.format,
		-- #endregion

		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "isort", "black" },
				javascript = { { "prettierd", "prettier" } },
				typescript = { { "prettierd", "prettier" } },
				javascriptreact = { { "prettierd", "prettier" } },
				typescriptreact = { { "prettierd", "prettier" } },
				rust = { "rustfmt" },
				toml = { "taplo" },
				json = { "yq" }
			},
			formatters = {
				shfmt = {
					prepend_args = { "-i", "2" },
				},
			},
			-- #endregion

			-- init = function()
			-- If you want the formatexpr, here is the place to set it
			-- vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
			-- end,

			-- #region async format on save
			format_on_save = function(bufnr)
				if slow_format_filetypes[vim.bo[bufnr].filetype] then
					return
				end
				local function on_format(err)
					if err and err:match("timeout$") then
						slow_format_filetypes[vim.bo[bufnr].filetype] = true
					end
				end

				return { timeout_ms = 200, lsp_fallback = true }, on_format
			end,

			format_after_save = function(bufnr)
				if not slow_format_filetypes[vim.bo[bufnr].filetype] then
					return
				end
				return { lsp_fallback = true }
			end,
			-- #endregion
		},
	}
}
