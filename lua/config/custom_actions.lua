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

local actions = {
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
        vim.keymap.set("n", keys.buffers.new, ":enew<CR>", { desc = "New Buffer" })

        vim.keymap.set("n", keys.cd, function()
            local path = functions.guessProjectRoot(vim.fn.expand("%:p"))
            vim.cmd("cd " .. path)
            vim.notify("set working directory to " .. vim.fn.getcwd())
        end, { desc = "cd to buffer" })
    end,


}

return actions
