return { {
    'echasnovski/mini.clue',
    version = '*',
    config = function()
        local miniclue = require('mini.clue')
        local keyboard = require("config.keyboard")

        miniclue.setup({
            triggers = keyboard.triggers,

            clues = vim.list_extend(
                keyboard.clues,
                {
                    miniclue.gen_clues.builtin_completion(),
                    miniclue.gen_clues.g(),
                    miniclue.gen_clues.marks(),
                    miniclue.gen_clues.registers(),
                    miniclue.gen_clues.windows(),
                    miniclue.gen_clues.z(),
                }),
            window = { delay = 100, config = {} }
        })
        miniclue.ensure_buf_triggers()
    end
} }
