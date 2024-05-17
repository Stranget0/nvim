return { {
	"hedyhli/outline.nvim",
	lazy = true,
	cmd = { "Outline", "OutlineOpen" },
	keys = require("config.keymaps").code_outline(),
	opts = {
		-- Your setup opts here
	},
	config = function()
		require("outline").setup({})
	end
} }
