local keys = require('config.keyboard').keys.oil

return { {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
        delete_to_trash = true,
        watch_for_changes = true,
        float = { border = "shadow" },
        keymaps_help = { border = "shadow" },
        progress = { border = "shadow" },
        ssh = { border = "shadow" },
        lsp_file_methods = { autosave_changes = true },
        view_options = { show_hidden = true },
        keymaps = {
            [keys.show_help]               = { "actions.show_help", mode = "n" },
            [keys.open_selected]           = { "actions.select", mode = "n" },
            [keys.toggle_preview]          = "actions.preview",
            [keys.close]                   = { "actions.close", mode = "n" },
            [keys.go_to_parent]            = { "actions.parent", mode = "n" },
            [keys.go_to_working_directory] = { "actions.open_cwd", mode = "n" },
            [keys.change_sort]             = { "actions.change_sort", mode = "n" },
            [keys.open_external]           = "actions.open_external",
            [keys.toggle_hidden]           = { "actions.toggle_hidden", mode = "n" },
            [keys.toggle_trash]            = { "actions.toggle_trash", mode = "n" }
        }
    },
    -- Optional dependencies
    dependencies = { "echasnovski/mini.icons" },

} }
