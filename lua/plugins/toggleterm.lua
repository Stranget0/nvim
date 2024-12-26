local keys = require("config.keyboard").keys.terminal

return {
    "akinsho/toggleterm.nvim",
    config = function()
        require("toggleterm").setup({
            open_mapping = keys.toggle,
            direction = "float",
            insert_mappings = true,
        })

        function _G.set_terminal_keymaps()
            local opts = { buffer = 0 }
            vim.keymap.set('t', keys.close, [[<C-\><C-n>]], opts)
            vim.keymap.set('t', keys.focus_left, [[<Cmd>wincmd h<CR>]], opts)
            vim.keymap.set('t', keys.focus_down, [[<Cmd>wincmd j<CR>]], opts)
            vim.keymap.set('t', keys.focus_up, [[<Cmd>wincmd k<CR>]], opts)
            vim.keymap.set('t', keys.focus_right, [[<Cmd>wincmd l<CR>]], opts)
        end

        vim.keymap.set("n", keys.select_list, [[<Cmd>TermSelect<CR>]])

        -- if you only want these mappings for toggle term use term://*toggleterm#* instead
        vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
    end
}
