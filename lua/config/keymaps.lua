-- --
-- -- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
-- -- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
-- -- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
-- -- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- -- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- -- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
-- --
-- -- File: config/keymaps.lua
-- -- Description: Key mapping configs
-- -- Author: Kien Nguyen-Tuan <kiennt2609@gmail.com>
-- -- Close all windows and exit from Neovim with <leader> and q

local keys = require("config.keyboard").keys
local functions = require("utils.functions")

local keymaps = {
    common = function()
        vim.keymap.set("n", keys.project_list, "<cmd>Telescope zoxide list<cr>", { desc = "open project list" })
        vim.keymap.set("n", keys.project_add,
            function()
                vim.ui.input({
                    prompt = "Add project to track:",
                    default = vim.fn.expand("%:p:h"),
                    completion = "dir",


                }, function(input)
                    if not input or input == "" then
                        vim.notify("No input received", vim.log.levels.WARN)
                        return
                    end

                    vim.uv.fs_stat(input, function(err, stat)
                        if stat and stat.type == "file" then
                            input = vim.fn.fnamemodify(input, ":h") -- Get parent directory
                        end

                        if err or not stat or not (stat.type == "file" or stat.type == "directory") then
                            vim.notify("Invalid path: " .. input, vim.log.levels.ERROR)
                            return
                        end
                        local path = vim.fn.fnameescape(input)
                        vim.cmd("zoxide add " .. path)
                        vim.notify("Added as project: " .. path, vim.log.levels.INFO)
                    end)
                end)
            end,
            { desc = "add as project" })

        vim.keymap.set("n", keys.find_file, "<cmd>Telescope fd<cr>", { desc = "Find File" })
        vim.keymap.set("n", keys.old_files, "<cmd>Telescope oldfiles<cr>", { desc = "Open Recent" })
        vim.keymap.set("n", keys.buffer_new, ":enew<CR>", { desc = "New Buffer" })

        vim.keymap.set("n", keys.buffer_cd, function()
            local path = functions.guessProjectRoot(vim.fn.expand("%:p"))
            vim.cmd("cd " .. path)
            vim.notify("set working directory to " .. vim.fn.getcwd())
        end, { desc = "cd to buffer" })
    end,

    lsp = function(bufnr)
        vim.keymap.set("n", keys.next_diagnostic, vim.diagnostic.goto_prev,
            { desc = "go prev diagnostic", buffer = bufnr })
        vim.keymap.set("n", keys.prev_diagnostic, vim.diagnostic.goto_next,
            { desc = "go next diagnostic", buffer = bufnr })
        vim.keymap.set("n", keys.diagnostic_list, "<cmd>Telescope diagnostics<cr>",
            { desc = "diagnostics", buffer = bufnr })
        vim.keymap.set("n", keys.go_definition, "<cmd>Telescope lsp_definitions<cr>",
            { desc = "go definition", buffer = bufnr })
        vim.keymap.set("n", keys.go_type, "<cmd>Telescope lsp_type_definitions<cr>", { desc = "go type", buffer = bufnr })
        vim.keymap.set("n", keys.go_references, "<cmd>Telescope lsp_references<cr>",
            { desc = "go references", buffer = bufnr })
        vim.keymap.set("n", keys.rename, vim.lsp.buf.rename, { desc = "rename", buffer = bufnr })
        vim.keymap.set("n", keys.hover_info, vim.lsp.buf.hover, { desc = "hover info", buffer = bufnr })
        vim.keymap.set({ "n", "v" }, keys.code_action, vim.lsp.buf.code_action, { desc = "code action", buffer = bufnr })
    end,

    rust_lsp = function(bufnr)
        vim.keymap.set("n", keys.code_action,
            function()
                vim.cmd.RustLsp("codeAction")
            end,
            { desc = "code action", buffer = bufnr, silent = true }
        )

        vim.keymap.set("n", keys.hover_info,
            function()
                vim.cmd.RustLsp({ 'hover', 'actions' })
            end,
            { desc = "hover actions", buffer = bufnr, silent = true }
        )

        vim.keymap.set(
            { "n", "v" },
            keys.code_move_up,
            function()
                vim.cmd.RustLsp { 'moveItem', 'up' }
            end,
            { desc = "move item up", buffer = bufnr, silent = true }
        )
        vim.keymap.set(
            { "n", "v" },
            keys.code_move_down,
            function()
                vim.cmd.RustLsp { 'moveItem', 'down' }
            end,
            { desc = "move item down", buffer = bufnr, silent = true }
        )

        vim.keymap.set(
            "n",
            keys.runnables,
            function()
                vim.cmd.RustLsp('runnables')
            end,
            { desc = "runnables", buffer = bufnr, silent = true }
        )

        vim.keymap.set(
            "n",
            keys.last_runnable,
            function()
                vim.cmd.RustLsp { 'runnables', bang = true }
            end,
            { desc = "run last runnable", buffer = bufnr, silent = true })
    end,

    github = function(bufnr)
        local gitsigns = require('gitsigns')

        local function map(mode, l, r, desc, _opts)
            local opts = _opts or {}
            opts.buffer = bufnr
            opts.desc = desc
            vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', keys.git_next_hunk, function()
            if vim.wo.diff then
                vim.cmd.normal({ ']c', bang = true })
            else
                gitsigns.nav_hunk('next')
            end
        end, "next hunk")

        map('n', keys.git_prev_hunk, function()
            if vim.wo.diff then
                vim.cmd.normal({ '[c', bang = true })
            else
                gitsigns.nav_hunk('prev')
            end
        end, "prev hunk")


        -- Actions
        map('n', keys.git_stage_hunk, gitsigns.stage_hunk, "stage hunk")
        map('n', keys.git_reset_hunk, gitsigns.reset_hunk, "reset hunk")
        map('v', keys.git_stage_hunk, function() gitsigns.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
            "stage hunk")
        map('v', keys.git_reset_hunk, function() gitsigns.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
            "reset hunk")
        map('n', keys.git_stage_buffer, gitsigns.stage_buffer, "stage buffer")
        map('n', keys.git_undo_stage_hunk, gitsigns.undo_stage_hunk, "undo stage hunk")
        map('n', keys.git_reset_buffer_hunks, gitsigns.reset_buffer, "reset buffer")
        map('n', keys.git_preview_hunk, gitsigns.preview_hunk, "preview hunk")
        map('n', keys.git_blame_line, function() gitsigns.blame_line { full = true } end, "blame line")
        map('n', keys.git_blame_line_toggle, gitsigns.toggle_current_line_blame, "toggle current line blame")
        map('n', keys.git_diffthis, gitsigns.diffthis, "diffthis")
        map('n', keys.git_diffthis_tilde, function() gitsigns.diffthis('~') end, "diffthis")
        map('n', keys.git_toggle_deleted_hunk, gitsigns.toggle_deleted, "toggle deleted")

        -- Text object
        map({ 'o', 'x' }, keys.git_select_hunk, ':<C-U>Gitsigns select_hunk<CR>', "select hunk")
    end,


    testing = function()
        return {
            confirm = keys.confirm,
            super_confirm = keys.super_confirm,
            mark = keys.mark,
            super_mark = keys.super_mark,
            toggle_watch = keys.test_watch,
            debug = keys.test_debug,
            attach = keys.test_attach,
            show_output = keys.test_show_output,
            show_output_short = keys.test_show_output_short,
            jump_to_test = keys.test_jump,
            expand_all = keys.folds_open_all,
            next_failed = keys.next_diagnostic,
            prev_failed = keys.prev_diagnostic,
        }
        -- local test = require("neotest").run
        --
        -- vim.keymap.set("n", keys.test_nearest, test.run, { desc = "run nearest test" })
        --
        -- vim.keymap.set("n", keys.test_file,
        --   function()
        --     test.run(vim.fn.expand("%"))
        --   end,
        --   { desc = "run tests in file" })

        -- vim.keymap.set(keys.stop_nearest_test,
        -- 	test.stop,
        -- 	{ desc = "stop nearest test" })
        -- Run the nearest test
        -- require("neotest").run.run()

        -- Run the current file
        -- require("neotest").run.run(vim.fn.expand("%"))

        -- Debug the nearest test (requires nvim-dap and adapter support)
        -- require("neotest").run.run({strategy = "dap"})
        -- See :h neotest.run.run() for parameters.


        -- Stop the nearest test, see :h neotest.run.stop()
        -- require("neotest").run.stop()

        -- Attach to the nearest test, see :h neotest.run.attach()
        -- require("neotest").run.attach()
    end,

    comment = function()
        return {
            -- Toggle comment (like `gcip` - comment inner paragraph) for both
            -- Normal and Visual modes
            comment = keys.comment,

            -- Toggle comment on current line
            comment_line = keys.comment_line,

            -- Toggle comment on visual selection
            comment_visual = keys.comment_visual,

            -- Define 'comment' textobject (like `dgc` - delete whole comment block)
            -- Works also in Visual mode if mapping differs from `comment_visual`
            textobject = keys.comment_textobject,
        }
    end,

    surround = function()
        return {
            add = keys.surrounding_add,                       -- Add surrounding in Normal and Visual modes
            delete = keys.surrounding_delete,                 -- Delete surrounding
            find = keys.surrounding_find,                     -- Find surrounding (to the right)
            find_left = keys.surrounding_find_left,           -- Find surrounding (to the left)
            highlight = keys.surrounding_highlight,           -- Highlight surrounding
            replace = keys.surrounding_replace,               -- Replace surrounding
            update_n_lines = keys.surrounding_update_n_lines, -- Update `n_lines`

            suffix_last = keys.surrounding_suffix_last,       -- Suffix to search with "prev" method
            suffix_next = keys.surrounding_suffix_next,       -- Suffix to search with "next" method
        }
    end,

    mini_operators = function()
        return {
            evaluate = keys.operators_evaluate,
            exchange = keys.operators_exchange,
            multiply = keys.operators_multiply,
            replace = keys.operators_replace, --with register
            sort = keys.operators_sort,
        }
    end,

    mini_textobjects_ai = function()
        return {
            -- Main textobject prefixes
            around = keys.ai_around,
            inside = keys.ai_inside,

            -- Next/last variants
            around_next = keys.ai_around_next,
            inside_next = keys.ai_inside_next,
            around_last = keys.ai_around_last,
            inside_last = keys.ai_inside_last,

            -- Move cursor to corresponding edge of `a` textobject
            goto_left = keys.ai_goto_left,
            goto_right = keys.ai_goto_right,
        }
    end,

    notifications = function()
        vim.keymap.set('n', keys.notifications_history, MiniNotify.show_history, { desc = "show history" })
        vim.keymap.set('n', keys.notifications_clear, MiniNotify.clear, { desc = "clear notifications" })
    end,

    cmp = function(cmp, cmp_action)
        return {
            [keys.confirm] = cmp.mapping.confirm({ select = true }),

            -- trigger completion menu
            [keys.cmp_trigger] = cmp.mapping.complete(),

            -- scroll up and down the documentation window
            [keys.next] = cmp.mapping.scroll_docs(-4),
            [keys.prev] = cmp.mapping.scroll_docs(4),

            -- navigate between snippet placeholders
            [keys.cmp_jump_forward] = cmp_action.luasnip_jump_forward(),
            [keys.cmp_jump_backward] = cmp_action.luasnip_jump_backward(),
        }
    end,

    cmp_ufo = function()
        vim.keymap.set('n', keys.folds_open_all, require('ufo').openAllFolds)
        vim.keymap.set('n', keys.folds_close_all, require('ufo').closeAllFolds)
    end,

    oil = function()
        -- use defaults
    end,
    code_outline = function()
        return {
            {
                keys.code_outline,
                function()
                    local outline = require("outline")
                    if outline.is_open() then
                        vim.cmd("OutlineFocus")
                    else
                        vim.cmd("Outline")
                    end
                end,
                desc = "Code outline"
            },
            {
                keys.code_outline_close,
                function()
                    vim.cmd("OutlineClose")
                end,
                desc = "Close outline"
            }
        }
    end,

    overseer = function()
        vim.keymap.set("n", keys.overseer_list, "<cmd>OverseerRun<cr>", { desc = "Overseer run" })
        vim.keymap.set("n", keys.overseer_build, "<cmd>OverseerBuild<cr>", { desc = "Overseer build" })
    end,

    buffer = function()
        local mappings = require("cokeline.mappings")
        local buffer_api = require("cokeline.buffers")



        local map = vim.keymap.set

        map("n", keys.buffer_pick_focus, function() mappings.pick("focus") end, { desc = "Pick buffer to focus" })
        map("n", keys.buffer_pick_close, function() mappings.pick("close") end, { desc = "Pick buffer to close" })
        map("n", "<S-Tab>", "<Plug>(cokeline-focus-prev)", { silent = true, desc = "Focus next buffer" })
        map("n", "<Tab>", "<Plug>(cokeline-focus-next)", { silent = true, desc = "Focus prev buffer" })
        map("n", keys.buffer_close_other, function()
            local buffers = buffer_api.get_visible()
            local current = buffer_api.get_current()
            for i = 1, #buffers do
                local buffer = buffers[#buffers - i + 1]
                if not current and buffer or (current and buffer and buffer.index ~= current.index) then
                    mappings.by_index("close", buffer.index)
                end
            end
        end, { desc = "Close other buffers" })

        map("n", keys.buffer_close, function()
            local current = buffer_api.get_current()
            if current then
                mappings.by_index("close", current.index)
            end
        end, { desc = "Close active buffer" })

        for i = 1, 9 do
            map(
                "n",
                (keys.buffer_focus):format(i),
                ("<Plug>(cokeline-focus-%s)"):format(i),
                { silent = true, desc = ("focus buffer %s"):format(i) }
            )
            map(
                "n",
                (keys.buffer_switch):format(i),
                ("<Plug>(cokeline-switch-%s)"):format(i),
                { silent = true, desc = ("switch to buffer %s"):format(i) }
            )
        end
    end,

    static = {
        taplo = {
            {
                keys.hover_info,
                function()
                    if vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
                        require("crates").show_popup()
                    else
                        vim.lsp.buf.hover()
                    end
                end,
                desc = "Show Crate Documentation",
            },
        },
        format = {
            {
                keys.buffer_format,
                function()
                    require("conform").format({ async = true, lsp_fallback = true })
                end,
                mode = "",
                desc = "Format buffer",
            }
        },

    },
}

return keymaps
