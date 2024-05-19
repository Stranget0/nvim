return {
	{
		"folke/neodev.nvim",
		ft = { "lua" },
		opts = {
			library = {
				plugins = {
					"neotest"
				},
				types = true
			},
			override = function(root_dir, library)
				library.enabled = true
				library.plugins = true
			end,
		}
	}
}
