local M = {}

-- #region utils
M.animated_component = function(component)
	local timer = vim.loop.new_timer()
	local n_seconds = 0

	timer:start(0, 1000, vim.schedule_wrap(function()
		if vim.bo.filetype ~= 'starter' then
			timer:stop()
			return
		end
		n_seconds = n_seconds + 1
		MiniStarter.refresh()
	end))

	return component(n_seconds)
end
-- #endregion

-- #region items
-- EXAMPLES
-- local my_items = {
-- 	{ name = 'Echo random number',            action = 'lua print(math.random())',      section = 'Section 1' },

-- 	function()
-- 		return {
-- 			{ name = 'Item #1 from function',              action = [[echo 'Item #1']], section = 'From function' },
-- 			{ name = 'Placeholder (always inactive) item', action = '',                 section = 'From function' },
-- 			function()
-- 				return {
-- 					name = 'Item #1 from double function',
-- 					action = [[echo 'Double function']],
-- 					section = 'From double function',
-- 				}
-- 			end,
-- 		}
-- 	end,

-- 	{ name = [[Another item in 'Section 1']], action = 'lua print(math.random() + 10)', section = 'Section 1' },
-- }
-- #endregion


M.headers = {
	wanderer_tales = function()
		return "                         ___\n		|  | _  _  _| _  _ _  _   |  _ | _  _\n		|/\\|(_|| )(_|(-`| (-`|    | (_||(-`_)"
	end,
	neovim =
			function()
				local neovims = require("ascii.neovim")

				local to_pick = {
					neovims.default2,
					neovims.ogre,
					neovims.delta_corps_priest1,
					neovims.colossal,
					neovims.def_leppard,
					neovims.sharp
				}


				return table.concat(to_pick[4], "\n")
			end
}

return M
