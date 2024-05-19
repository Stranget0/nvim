local icons = require("config.icons")
return {
	{
		"j-hui/fidget.nvim",
		lazy = false,
		priority = 0,
		opts = {
			-- Options related to LSP progress subsystem
			progress = {
				suppress_on_insert = true, -- Suppress new messages while in insert mode
				ignore_done_already = false, -- Ignore new tasks that are already complete

				display = {
					render_limit = 16,     -- How many LSP messages to show at once
					done_ttl = 1,          -- How long a message should persist after completion
					done_icon = icons.arm_flex, -- Icon shown when all LSP progress tasks are complete
					progress_icon =        -- Icon shown when LSP progress tasks are in progress
					{ pattern = "dots", period = 1 },
				},

			},

			-- Options related to notification subsystem
			notification = {
				redirect = -- Conditionally redirect notifications to another backend
						function(msg, level, opts)
							if opts and opts.on_open then
								vim.notify(msg, level, opts)
							end
						end,


				-- Options related to the notification window and buffer
				window = {
					winblend = 100, -- Background color opacity in the notification window
					border = "none", -- Border around the notification window
				},
			},

			-- Options related to integrating with other plugins
			integration = {
			},
		}
	}
}
