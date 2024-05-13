return {
	{
		"folke/twilight.nvim",
		opts = {
			dimming = {
				alpha = 0.66
			},
			config = function()
				vim.cmd("!TwilightEnable")
			end
		}
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {},
		config = function()
			require("ibl").setup()
		end
	}
}
