local keymaps = require("config.keymaps")

return {
    {
        'echasnovski/mini.comment',
        version = '*',
        config = function()
            require('mini.comment').setup({
                mappings = keymaps.comment()
            })
        end

    }
}
