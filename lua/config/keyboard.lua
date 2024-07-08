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
  hover_info = "<leader>cK",
  open_docs = "<leader>td",

  git_prev_hunk = "<leader>h[",
  git_next_hunk = "<leader>h]",
  git_stage_hunk = '<leader>hs',
  git_reset_hunk = '<leader>hr',
  git_stage_buffer = '<leader>hS',
  git_undo_stage_hunk = '<leader>hu',
  git_reset_buffer_hunks = '<leader>hR',
  git_preview_hunk = '<leader>hp',
  git_blame_line = '<leader>hb',
  git_blame_line_toggle = '<leader>hB',
  git_diffthis = '<leader>hd',
  git_diffthis_tilde = '<leader>hD',
  git_toggle_deleted_hunk = '<leader>hH',
  git_select_hunk = '<leader>hh',

  cmp_confirm = '<Enter>',
  cmp_trigger = '<C-Space>',
  cmp_scroll_up = '<tab>',
  cmp_scroll_down = '<S-tab>',
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

  operators_evaluate = "<leader>c=",
  operators_exchange = "<leader>cx",
  operators_multiply = "<leader>cm",
  operators_replace = "<leader>cR",
  operators_sort = "<leader>cs",

  ai_around = 'a',
  ai_inside = 'i',
  ai_around_next = 'an',
  ai_inside_next = 'in',
  ai_around_last = 'al',
  ai_inside_last = 'il',
  ai_goto_left = 'gh',
  ai_goto_right = 'gl',

  notifications_history = "<leader>nh",
  notifications_clear = "<leader>nd",

  folds_open_all = 'zR',
  folds_close_all = 'zM',

  format_buffer = "<leader>bf",

  code_outline = "<leader>oo",
  code_outline_close = "<leader>oc",
  overseer_list = "<leader>rr",
  overseer_build = "<leader>rb",

  test_nearest = "<leader>tn",
  test_file = "<leader>tf",
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
  { mode = "n",               keys = "<leader>c", desc = "+code" },
  { mode = "n",               keys = "<leader>o", desc = "+outline" },
  { mode = { "n", "v", "i" }, keys = "<leader>b", desc = "+buffer" },
  { mode = "n",               keys = "<leader>r", desc = "+runnables" },
  { mode = "n",               keys = "<leader>t", desc = "+tests" },
  { mode = "n",               keys = "<leader>p", desc = "+projects" },
  { mode = "n",               keys = "<leader>n", desc = "+notifications" },
  { mode = "n",               keys = "<leader>h", desc = "+git hunk" },
}

M.check_conflicts = function()
  for i, key1 in pairs(M.keys) do
    for j, key2 in pairs(M.keys) do
      if i ~= j and key1 == key2 then
        vim.notify("conflicting keys [" .. i .. '] and [' .. j .. "] - " .. key1)
      end
    end
  end
end

return M
