return {
	{ "nvim-neotest/neotest-plenary", "nvim-neotest/nvim-nio" },
	{
		"nvim-neotest/neotest",
		opts = function(_, opts)
			opts.adapters = opts.adapters or {}
			vim.list_extend(opts.adapters, {
				require("rustaceanvim.neotest"),
				"neotest-plenary"
			})
		end,
	},
}
