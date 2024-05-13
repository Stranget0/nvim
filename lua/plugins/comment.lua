--
-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
--
-- File: plugins/comment.lua
-- Description: nvim comment config
-- Author: Kien Nguyen-Tuan <kiennt2609@gmail.com>
return { {
	"numToStr/Comment.nvim",
	config = function()
		require("Comment").setup {
			-- ignores empty lines
			ignore = "^$",
			pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
		}
	end,
	dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring', }
} }
