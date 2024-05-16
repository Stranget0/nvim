local f = require("utils.functions")

local colors = {
	blue   = '#80a0ff',
	cyan   = '#79dac8',
	black  = '#080808',
	white  = '#c6c6c6',
	red    = '#ff5189',
	violet = '#d183e8',
	grey   = '#303030',
}

local bubbles_theme = {
	normal = {
		a = { fg = colors.black, bg = colors.violet },
		b = { fg = colors.white, bg = colors.grey },
		c = { fg = colors.blue },
	},

	insert = { a = { fg = colors.black, bg = colors.blue } },
	visual = { a = { fg = colors.black, bg = colors.cyan } },
	replace = { a = { fg = colors.black, bg = colors.red } },

	inactive = {
		a = { fg = colors.white, bg = colors.black },
		b = { fg = colors.white, bg = colors.black },
		c = { fg = colors.white },
	},
}


local separators = {
	left = { left = '' },
	right = { right = '' },
	both_inv = { left = '', right = '' },
	both = { right = '', left = '' }
}

local with_left = function(element)
	return { element, separator = separators.left, right_padding = 2 }
end

local with_right = function(element)
	return { element, separator = separators.right, left_padding = 2 }
end

local with_both = function(element)
	return { element, separator = separators.both }
end

return { {
	'nvim-lualine/lualine.nvim',
	dependencies = { 'nvim-tree/nvim-web-devicons', {
		'linrongbin16/lsp-progress.nvim',
		config = function()
			require('lsp-progress').setup()
		end
	} },
	config = function()
		vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
		vim.api.nvim_create_autocmd("User", {
			group = "lualine_augroup",
			pattern = "LspProgressStatusUpdated",
			callback = require("lualine").refresh,
		})

		require('lualine').setup({
			options = {
				theme = bubbles_theme,
				component_separators = '',
				section_separators = separators.both_inv,
			},
			sections = {
				lualine_a = { with_left("mode") },
				lualine_b = { 'filename', "diagnostics", "searchcount" },
				lualine_c = {
					'%=', function()
					return require('lsp-progress').progress({
						format = function(client_messages)
							-- icon: nf-fa-gear \uf013
							if #client_messages > 0 then
								local message = "󰦖 " .. table.concat(client_messages, " ")
								return f.truncateString(message, 64)
							end
							if #vim.lsp.get_active_clients() > 0 then
								return ""
							end
							return ""
						end,
					})
				end,
				},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {
					with_both("location"),
				},
			},
			inactive_sections = {
				lualine_a = { 'filename' },
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = { 'location' },
			},
			tabline = {},
			extensions = {},
		})
	end
} }
