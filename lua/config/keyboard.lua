local M = {}

M.keys = {
	project_list = "<leader>pl",
	project_add = "<leader>pa",
	find_file = "<leader>ff",
	old_files = "<leader>fr",
	new_file = "<leader>fn",

	next_diagnostic = "g[",
	prev_diagnostic = "g]",
	diagnostic_list = "<leader>cd",
	go_definition = "gd",
	go_type = "gt",
	go_references = "gr",
	rename = "<leader>cr",
	code_action = "<leader>ca",
	hover_info = "K",
	open_docs = "<leader>td",

	git_prev_hunk = "h[",
	git_next_hunk = "h]",
	git_stage_hunk = '<leader>gs',
	git_reset_hunk = '<leader>gr',
	git_stage_buffer = '<leader>gS',
	git_undo_stage_hunk = '<leader>gu',
	git_reset_buffer_hunks = '<leader>gR',
	git_preview_hunk = '<leader>gp',
	git_blame_line = '<leader>gb',
	git_blame_line_toggle = '<leader>gtb',
	git_diffthis = '<leader>gd',
	git_diffthis_tilde = '<leader>gD',
	git_toggle_deleted_hunk = '<leader>gtd',
	git_select_hunk = 'gih',

	cmp_confirm = '<Enter>',
	cmp_trigger = '<C-Space>',
	cmp_scroll_up = '<C-u>',
	cmp_scroll_down = '<C-d>',
	cmp_jump_forward = '<C-f>',
	cmp_jump_backward = '<C-b>',

	run_nearest_test = "<leader>rt",
	run_tests_in_file = "<leader>rT",

	runnables = "<leader>rr",
	last_runnable = "<leader>rR",

	comment = '<C-m>',
	comment_line = '<C-m>',
	comment_visual = '<C-m>',
	comment_textobject = '<C-m>',


	surrounding_add = 'sa',
	surrounding_delete = 'sd',
	surrounding_find = 'sf',
	surrounding_find_left = 'sF',
	surrounding_highlight = 'sh',
	surrounding_replace = 'sr',
	surrounding_update_n_lines = 'sn',
	surrounding_suffix_last = 'l',
	surrounding_suffix_next = 'n',

	code_move_up = "J",
	code_move_down = "K",

	operators_evaluate = "g=",
	operators_exchange = "gx",
	operators_multiply = "gm",
	operators_replace = "gr",
	operators_sort = "gs",

	ai_around = 'a',
	ai_inside = 'i',
	ai_around_next = 'an',
	ai_inside_next = 'in',
	ai_around_last = 'al',
	ai_inside_last = 'il',
	ai_goto_left = 'g[',
	ai_goto_right = 'g]',

	notifications_history = "<leader>nh",
	notifications_clear = "<leader>nd",

	folds_open_all = 'zR',
	folds_close_all = 'zM',

	docs_split_remain_focused = "<leader>hs",
	docs_vsplit_remain_focused = "<leader>hv",
	docs_split = "<leader>hS",
	docs_vsplit = "<leader>hV",

	format_buffer = "<leader>f",

	code_outline = "<leader>co",
}

M.triggers = {
	-- Leader triggers
	{ mode = 'n', keys = '<Leader>' },
	{ mode = 'x', keys = '<Leader>' },

	-- Built-in completion
	{ mode = 'i', keys = '<C-x>' },

	-- `g` key
	{ mode = 'n', keys = 'g' },
	{ mode = 'x', keys = 'g' },

	-- `f` key
	{ mode = 'n', keys = 'f' },

	-- mini comment / surround
	{ mode = 'n', keys = 's' },
	{ mode = 'n', keys = 'l' },
	{ mode = 'n', keys = 'n' },

	-- Marks
	{ mode = 'n', keys = "'" },
	{ mode = 'n', keys = '`' },
	{ mode = 'x', keys = "'" },
	{ mode = 'x', keys = '`' },

	-- Registers
	{ mode = 'n', keys = '"' },
	{ mode = 'x', keys = '"' },
	{ mode = 'i', keys = '<C-r>' },
	{ mode = 'c', keys = '<C-r>' },

	-- Window commands
	{ mode = 'n', keys = '<C-w>' },

	-- `z` key
	{ mode = 'n', keys = 'z' },
	{ mode = 'x', keys = 'z' },

	-- LSP
	{ mode = "n", keys = "[" },
	{ mode = "n", keys = "]" },
	{ mode = "n", keys = "g" },
	{ mode = "n", keys = "g" },
	{ mode = "n", keys = "g" },
	{ mode = "n", keys = "g" },
	{ mode = "n", keys = "L" },
}

M.clues = {
	{ mode = "n", keys = "<leader>c", desc = "+code" },
	{ mode = "n", keys = "<leader>r", desc = "+runnables" },
	{ mode = "n", keys = "<leader>h", desc = "+hover docs" },
	{ mode = "n", keys = "<leader>p", desc = "+projects" },
	{ mode = "n", keys = "<leader>n", desc = "+notifications" },
}

return M
