return {
	{
		'echasnovski/mini.nvim',
		version = false,

		config = function()
			require("mini.comment").setup({
				ignore_blank_line = true,
				mappings = require("keymaps").comment()
			})
		end
	}
}
