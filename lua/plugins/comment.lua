return {
    {
        'echasnovski/mini.comment',
        version = '*',
        config = function()
            require('mini.comment').setup({
                mappings = require("config.keyboard").keys.comment
            })
        end

    }
}
