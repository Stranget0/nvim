return {
	{
		'echasnovski/mini.nvim',
		version = false,

		config = function()
			-- #region editing
			local keymaps = require("config.keymaps")
			require("mini.comment").setup({
				ignore_blank_line = true,
				mappings = keymaps.comment()
			})

			require('mini.surround').setup({
				mappings = keymaps.surround(),
				n_lines = 50,
				respect_selection_type = true,
				-- silent = true,
			})

			local mini_operators = keymaps.mini_operators()
			require('mini.operators').setup({
				-- 1 + 1 -> 2
				evaluate = {
					prefix = mini_operators.evaluate,
				},

				-- Exchange text regions
				exchange = {
					prefix = mini_operators.exchange,
				},

				-- Multiply (duplicate) text
				multiply = {
					prefix = mini_operators.multiply,
				},

				-- Replace text with register
				replace = {
					prefix = mini_operators.replace,
				},

				-- Sort text
				sort = {
					prefix = mini_operators.sort,
				}
			})


			require('mini.ai').setup({
				n_lines = 100,
				mappings = keymaps.mini_textobjects_ai()

				-- Whether to disable showing non-error feedback
				-- silent = false,
			})
			-- #endregion

			-- #region starter
			local starter = require('mini.starter')

			starter.setup({
				header = require("utils.starter_components").headers.neovim(),
				items = {
					starter.sections.recent_files(1),
					starter.sections.sessions(5, true),
				},
				footer = '',
				content_hooks = {
					starter.gen_hook.adding_bullet(),
					starter.gen_hook.indexing('all'),
					-- starter.gen_hook.padding(5, 2),
					starter.gen_hook.aligning('center', 'center'),
				},
				evaluate_single = true,
			})

			-- #endregion

			-- #region sessions
			require("mini.sessions").setup(
				{
					-- autoread = true,

					-- Directory where global sessions are stored (use `''` to disable)
					directory = "nvim_sessions",

					-- Whether to print session path after action
					verbose = { read = false, write = true, delete = true },
				})
			-- #endregion
		end
	}
}
