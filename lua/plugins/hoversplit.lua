return { {
	"roobert/hoversplit.nvim",
	config = function()
		require("hoversplit").setup({
			key_bindings = require("config.keymaps").static.hoversplit,
		})
	end
} }
