local M = {}

M.keys = {
    unused = "<leader><leader>",
    next = '<tab>',
    prev = '<S-tab>',
    up = "<tab>",
    down = "<S-tab>",
    confirm = '<Enter>',
    super_confirm = '<S-Enter>',
    mark = '<Space>',
    super_mark = '<S-Space>',
    cd = "<leader>cd",
    cd_alt = "<leader>cD",
    close = "q",
    close_alt = "<esc>",
    focus_left = "<C-h>",
    focus_right = "<C-l>",
    focus_up = "<C-k>",
    focus_down = "<C-j>",

    project_list = "<leader>pl",
    project_add = "<leader>pa",
    find_file = "<leader>ff",
    old_files = "<leader>fr",

    next_diagnostic = "[d",
    prev_diagnostic = "]d",
    diagnostic_list = "<leader>d",
    go_definition = "gd",
    go_type = "gt",
    go_references = "gr",
    rename = "<leader>cr",
    code_action = "<leader>ca",
    hover_info = "K",

    runnables = "<leader>rr",
    last_runnable = "<leader>rR",

    code_move_up = "<A-j>",
    code_move_down = "<A-K>",

    folds_open_all = 'zR',
    folds_close_all = 'zM',
}

M.keys.comment = {
    comment = 'gc',
    comment_line = 'gcc',
    comment_visual = 'gc',
    textobject = 'gc',
}

M.keys.operators = {
    evaluate = "<leader>c=",
    exchange = "<leader>cx",
    multiply = "<leader>cm",
    replace = "<leader>cR",
    sort = "<leader>cs",
}

M.keys.surround = {
    insert = "<C-g>s",
    insert_line = "<C-g>S",
    normal = "ys",
    normal_cur = "yss",
    normal_line = "yS",
    normal_cur_line = "ySS",
    visual = "S",
    visual_line = "gS",
    delete = "ds",
    change = "cs",
    change_line = "cS",
}

M.keys.buffers = {
    close = "<leader>x",
    close_other = "<leader><S-x>",
    new = "<leader>bn",
    format = "<leader>bf",
    pick_focus = "<leader>bp",
    pick_close = "<leader>bq",
    focus = "<Leader>%s",
    switch = "<F%s>",
}

local test_debug = "<leader>td"
M.keys.testing_summary = {
    run          = M.keys.confirm,         -- run test
    stop         = M.keys.confirm,         -- stop test
    mark         = M.keys.mark,            -- mark test
    watch        = "<leader>tw",           -- toggle watch
    debug        = test_debug,             -- debug selected test
    attach       = "<leader>ta",           -- attach to selected test
    output       = "<leader>tO",           -- output long
    short        = "<leader>to",           -- output short
    jumpto       = "<leader>tg",           -- jump to selected test
    run_marked   = M.keys.super_confirm,   -- run all marked tests
    expand       = M.keys.mark,            -- expand tests
    expand_all   = M.keys.folds_open_all,  -- expand all surrounding tests
    target       = M.keys.super_mark,      -- show only this test in file
    prev_failed  = M.keys.prev_diagnostic, -- jump to previous failed test
    next_failed  = M.keys.next_diagnostic, -- jump to next failed test
    clear_marked = M.keys.mark,            -- clear all marked tests
    clear_target = M.keys.super_mark,      -- show all tests
    debug_marked = test_debug,             -- debug all marked tests
}

M.keys.notifications = {
    history = "<leader>nh",
    clear = "<leader>nd",
}

M.keys.code_outline = {
    open = "<leader>oo",
    close = "<leader>oc",
}

M.keys.overseer = {
    open_list = "<leader>rr",
    run_build = "<leader>rb",
}

M.keys.cmp =
{
    confirm = M.keys.confirm,
    open_completion_menu = '<C-Space>',
    next_completion = M.keys.next,
    prev_completion = M.keys.prev,
    jump_forward = '<C-f>',
    jump_backward = '<C-b>',
}


M.keys.oil = {
    show_help = "g?",
    open_selected = M.keys.confirm,
    select_and = M.keys.super_confirm,
    toggle_preview = M.keys.hover_info,
    close = M.keys.close,
    go_to_parent = "-",
    go_to_working_directory = "_",
    change_sort = "gs",
    open_external = "gx",
    toggle_hidden = "g.",
    toggle_trash = "g\\"


}

M.keys.github = {
    git_prev_hunk = "[g",
    git_next_hunk = "]g",
    git_diffthis = '<leader>hd',
    git_diffthis_tilde = '<leader>hD',
    git_blame_line = '<leader>hb',
    git_blame_line_toggle = '<leader>hB',
    git_select_hunk = '<leader>hh',
    git_stage_hunk = '<leader>hh',
    git_reset_hunk = '<leader>hr',
    git_stage_buffer = '<leader>hA',
    git_undo_stage_hunk = '<leader>hu',
    git_reset_buffer_hunks = '<leader>hR',
    git_preview_hunk = '<leader>hp',
    git_toggle_deleted_hunk = '<leader>ht',
}

M.keys.terminal = {
    toggle = '<C-\\>',
    select_list = '<leader>st',
    close = M.keys.close_alt,
    focus_left = M.keys.focus_left,
    focus_right = M.keys.focus_right,
    focus_up = M.keys.focus_up,
    focus_down = M.keys.focus_down,
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
    { mode = "n", keys = "L" },

}

M.clues = {
    { mode = "n", keys = "<leader>c", desc = "+code" },
    { mode = "n", keys = "<leader>o", desc = "+outline" },
    { mode = "n", keys = "<leader>b", desc = "+buffer" },
    { mode = "n", keys = "<leader>r", desc = "+runnables" },
    { mode = "n", keys = "<leader>t", desc = "+tests" },
    { mode = "n", keys = "<leader>p", desc = "+projects" },
    { mode = "n", keys = "<leader>n", desc = "+notifications" },
    { mode = "n", keys = "<leader>h", desc = "+git hunk" },
    { mode = "n", keys = "<leader>s", desc = "+select" },
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

function check(keyOrObject)
    if type(keyOrObject) == "table" then
        for _, value in pairs(keyOrObject) do
            check(value)
        end
    else
        local bindDetails = vim.fn.execute("verbose map " .. keyOrObject)
        if not bindDetails then
            vim.notify("Unused key: " .. keyOrObject .. " " .. bindDetails, vim.log.levels.WARN)
        end
    end
end

M.log_unused_keys = function()
    for key, value in pairs(M.keys) do
        check(value)
    end
end

M.log_unused_keys()

return M
