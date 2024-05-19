local f = require("utils.functions")
local icons = require("config.icons")

local colors = require("oldworld.palette")

local theme = {
	normal = {
		a = { fg = colors.black, bg = colors.blue },
		b = { fg = colors.white, bg = colors.black },
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

local modecolor = {
	n = colors.red,
	i = colors.cyan,
	v = colors.purple,
	[""] = colors.purple,
	V = colors.red,
	c = colors.yellow,
	no = colors.red,
	s = colors.yellow,
	S = colors.yellow,
	[""] = colors.yellow,
	ic = colors.yellow,
	R = colors.green,
	Rv = colors.purple,
	cv = colors.red,
	ce = colors.red,
	r = colors.cyan,
	rm = colors.cyan,
	["r?"] = colors.cyan,
	["!"] = colors.red,
	t = colors.bright_red,
}

local separators = {
	left = { left = '' },
	right = { right = '' },
	both_inv = { left = '', right = '' },
	both = { right = '', left = '' }
}
local padding = 0
local with_left = function(element)
	return vim.tbl_extend("keep", element, { separator = separators.left, right_padding = padding })
end

local with_right = function(element)
	return vim.tbl_extend("keep", element, { separator = separators.right, left_padding = padding })
end

local with_both = function(element)
	return vim.tbl_extend("keep", element, { separator = separators.both })
end

local with_none = function(element)
	return element
end

local space_element = function()
	return " "
end
local space = {
	space_element,
	color = { bg = colors.bg, fg = colors.blue },
}

local filename = {
	"filename",
	color = { bg = colors.black, fg = colors.white },
}

local filetype = {
	"filetype",
	icons_enabled = false,
	color = { bg = colors.gray2, fg = colors.blue, gui = "italic" },
}

local branch = {
	"FugitiveHead",
	icon = "",
	color = { bg = colors.blue, fg = colors.bg, gui = "bold" },
}

local location = {
	"location",
	color = function()
		return { bg = modecolor[vim.fn.mode()], fg = colors.bg, gui = "bold" }
	end
}

local function git_signs_source()
	local gitsigns = vim.b.gitsigns_status_dict
	if gitsigns then
		return {
			added = gitsigns.added,
			modified = gitsigns.changed,
			removed = gitsigns.removed
		}
	end
end

local diff = {
	"diff",
	color = { bg = colors.gray1, fg = colors.bg, gui = "bold" },
	symbols = { added = icons.git.Add, modified = icons.git.Change, removed = icons.git.Delete },
	source = git_signs_source,

	diff_color = {
		added = { fg = colors.green },
		modified = { fg = colors.yellow },
		removed = { fg = colors.red },
	},
}

local modes = {
	"mode",
	color = function()
		return { bg = modecolor[vim.fn.mode()], fg = colors.bg, gui = "bold" }
	end,
}

local diagnostics = {
	"diagnostics",
	bg = { "nvim_diagnostic" },
	symbols = {
		error = icons.statusline.Error .. " ",
		warn = icons.statusline.Warn .. " ",
		info = icons.statusline.Info .. " ",
		hint = icons.statusline.Hint .. " "
	},
	diagnostics_color = {
		error = { fg = colors.red },
		warn = { fg = colors.yellow },
		info = { fg = colors.purple },
		hint = { fg = colors.cyan },
	},
	color = { bg = colors.gray1, fg = colors.blue, gui = "bold" },
}

local searchcount = {
	"searchcount",
	color = { bg = colors.gray0, fg = colors.gray3, gui = "italic" },
}



return { {
	'nvim-lualine/lualine.nvim',
	dependencies = { 'nvim-tree/nvim-web-devicons' },
	config = function()
		vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
		vim.api.nvim_create_autocmd("User", {
			group = "lualine_augroup",
			pattern = "LspProgressStatusUpdated",
			callback = require("lualine").refresh,
		})

		require('lualine').setup({
			options = {
				theme = theme,
				component_separators = { left = '', right = '' },
				section_separators = separators.both_inv,
				always_divide_middle = true,
				globalstatus = true,
			},
			sections = {
				lualine_a = { with_left(modes) },
				lualine_b = { with_right(filename), space, with_both(diagnostics), space, with_both(searchcount) },
				lualine_c = {
					'%=',
				},
				lualine_x = {},
				lualine_y = { with_both(branch), with_both(diff), space },
				lualine_z = {
					with_both(location),
				},
			},
			inactive_sections = {
				lualine_a = { filename },
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = { location },
			},
			tabline = {},
			extensions = { "oil", "fzf", "fugitive", "symbols-outline", "lazy" },
		})
	end
} }
