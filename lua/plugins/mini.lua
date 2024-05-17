return {
	{
		'echasnovski/mini.nvim',
		version = false,

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
			miniclue.setup({
				triggers = {
					-- Control
					{ mode = 'n', keys = '<C>' },
					-- Leader triggers
					{ mode = 'n', keys = '<Leader>' },
					{ mode = 'x', keys = '<Leader>' },

					-- Built-in completion
					{ mode = 'i', keys = '<C-x>' },

					-- `g` key
					{ mode = 'n', keys = 'g' },
					{ mode = 'x', keys = 'g' },

					-- `f` key
					{ mode = 'n', keys = 'f' },

					-- mini comment / surround
					{ mode = 'n', keys = 's' },
					{ mode = 'n', keys = 'l' },
					{ mode = 'n', keys = 'n' },

					-- Marks
					{ mode = 'n', keys = "'" },
					{ mode = 'n', keys = '`' },
					{ mode = 'x', keys = "'" },
					{ mode = 'x', keys = '`' },

					-- Registers
					{ mode = 'n', keys = '"' },
					{ mode = 'x', keys = '"' },
					{ mode = 'i', keys = '<C-r>' },
					{ mode = 'c', keys = '<C-r>' },

					-- Window commands
					{ mode = 'n', keys = '<C-w>' },

					-- `z` key
					{ mode = 'n', keys = 'z' },
					{ mode = 'x', keys = 'z' },

					-- LSP
					{ mode = "n", keys = "[" },
					{ mode = "n", keys = "]" },
					{ mode = "n", keys = "g" },
					{ mode = "n", keys = "g" },
					{ mode = "n", keys = "g" },
					{ mode = "n", keys = "g" },
					{ mode = "n", keys = "L" },
				},

				clues = {
					{ mode = "n", keys = "<leader>c",  desc = "+code" },
					{ mode = "n", keys = "<leader>ct", desc = "+tests" },
					{ mode = "n", keys = "<leader>h",  desc = "+hover docs" },
					{ mode = "n", keys = "<leader>p",  desc = "+projects" },
					{ mode = "n", keys = "<leader>n",  desc = "+notifications" },
					-- Enhance this by adding descriptions for <Leader> mapping groups
					miniclue.gen_clues.builtin_completion(),
					miniclue.gen_clues.g(),
					miniclue.gen_clues.marks(),
					miniclue.gen_clues.registers(),
					miniclue.gen_clues.windows(),
					miniclue.gen_clues.z(),
				},
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
			require("config.keymaps").notifications()
			-- #endregion
		end
	}
}
