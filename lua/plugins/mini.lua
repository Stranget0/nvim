return {
	{
		'echasnovski/mini.nvim',
		version = false,
		priority = 1000,

		config = function()
			local keymaps = require("config.keymaps")
			-- #region editing
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
				items = {},
				footer = '',
				content_hooks = {
					starter.gen_hook.indexing('all'),
					starter.gen_hook.padding(5, 2),
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

			-- #region key clues
			local miniclue = require('mini.clue')
			local keyboard = require("config.keyboard")
			miniclue.setup({
				triggers = keyboard.triggers,

				clues = vim.list_extend(
					keyboard.clues,
					{
						miniclue.gen_clues.builtin_completion(),
						miniclue.gen_clues.g(),
						miniclue.gen_clues.marks(),
						miniclue.gen_clues.registers(),
						miniclue.gen_clues.windows(),
						miniclue.gen_clues.z(),
					}),
				window = { delay = 100, config = {} }
			})
			miniclue.ensure_buf_triggers()
			-- #endregion

			-- #region notify
			local notify = require('mini.notify')
			notify.setup({
				content = {
					-- Use notification message as is
					format = function(notif) return notif.msg end,

					-- Show more recent notifications first
					sort = function(notif_arr)
						table.sort(
							notif_arr,
							function(a, b) return a.ts_update > b.ts_update end
						)
						return notif_arr
					end,
				},
				lsp_progress = {
					enable = false,
				},
				window = {
					-- Floating window config
					config = {},

					-- Maximum window width as share (between 0 and 1) of available columns
					max_width_share = 0.382,

					-- Value of 'winblend' option
					winblend = 25,
				},
			})
			vim.notify = notify.make_notify()
			keymaps.notifications()
			-- #endregion
		end
	}
}
