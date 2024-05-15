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

					-- tree
					{ mode = "n", keys = '<C-]>' },
					{ mode = "n", keys = '<C-e>' },
					{ mode = "n", keys = '<C-k>' },
					{ mode = "n", keys = '<C-r>' },
					{ mode = "n", keys = '<C-t>' },
					{ mode = "n", keys = '<C-v>' },
					{ mode = "n", keys = '<C-x>' },
					{ mode = "n", keys = '<BS>' },
					{ mode = "n", keys = '<CR>' },
					{ mode = "n", keys = '<Tab>' },
					{ mode = "n", keys = '>' },
					{ mode = "n", keys = '<' },
					{ mode = "n", keys = '.' },
					{ mode = "n", keys = '-' },
					{ mode = "n", keys = 'a' },
					{ mode = "n", keys = 'bd' },
					{ mode = "n", keys = 'bt' },
					{ mode = "n", keys = 'bmv' },
					{ mode = "n", keys = 'B' },
					{ mode = "n", keys = 'c' },
					{ mode = "n", keys = 'C' },
					{ mode = "n", keys = '[c' },
					{ mode = "n", keys = ']c' },
					{ mode = "n", keys = 'd' },
					{ mode = "n", keys = 'D' },
					{ mode = "n", keys = 'E' },
					{ mode = "n", keys = 'e' },
					{ mode = "n", keys = ']e' },
					{ mode = "n", keys = '[e' },
					{ mode = "n", keys = 'F' },
					{ mode = "n", keys = 'f' },
					{ mode = "n", keys = 'g?' },
					{ mode = "n", keys = 'gy' },
					{ mode = "n", keys = 'ge' },
					{ mode = "n", keys = 'H' },
					{ mode = "n", keys = 'I' },
					{ mode = "n", keys = 'J' },
					{ mode = "n", keys = 'K' },
					{ mode = "n", keys = 'L' },
					{ mode = "n", keys = 'M' },
					{ mode = "n", keys = 'm' },
					{ mode = "n", keys = 'o' },
					{ mode = "n", keys = 'O' },
					{ mode = "n", keys = 'p' },
					{ mode = "n", keys = 'P' },
					{ mode = "n", keys = 'q' },
					{ mode = "n", keys = 'r' },
					{ mode = "n", keys = 'R' },
					{ mode = "n", keys = 's' },
					{ mode = "n", keys = 'S' },
					{ mode = "n", keys = 'u' },
					{ mode = "n", keys = 'U' },
					{ mode = "n", keys = 'W' },
					{ mode = "n", keys = 'x' },
					{ mode = "n", keys = 'y' },
					{ mode = "n", keys = 'Y' },
					{ mode = "n", keys = '<2-LeftMouse>' },
					{ mode = "n", keys = '<2-RightMouse>' },
				},

				clues = {
					{ mode = "n", keys = "<leader>c", desc = "+code" },
					{ mode = "n", keys = "<leader>t", desc = "+tests" },
					{ mode = "n", keys = "<leader>h", desc = "+hover docs" },
					{ mode = "n", keys = "<leader>p", desc = "+projects" },
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
		end
	}
}
