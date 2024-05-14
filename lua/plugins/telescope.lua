--
-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
--
-- File: plugins/telescope.lua
-- Description: nvim-telescope config
-- Author: Kien Nguyen-Tuan <kiennt2609@gmail.com>
return { {
	-- Telescope
	-- Find, Filter, Preview, Pick. All lua, all the time.
	"nvim-telescope/telescope.nvim",
	config = function(_)
		require("telescope").setup({
			pickers = {
				colorscheme = {
					enable_preview = true
				}
			}
		})
		-- To get fzf loaded and working with telescope, you need to call
		-- load_extension, somewhere after setup function:
		require("telescope").load_extension("fzf")
		require("telescope").load_extension('zoxide')
	end,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-lua/popup.nvim",
		"jvgrootveld/telescope-zoxide",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make"
		},
	},

} }
