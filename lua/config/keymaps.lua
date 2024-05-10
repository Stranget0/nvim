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


local wk = require("which-key")

-- vim.keymap.set("n", "<leader>q", ":qa!<CR>", {})
-- -- Fast saving with <leader> and s
-- vim.keymap.set("n", "<leader>s", ":w<CR>", {})
-- -- Move around splits
-- vim.keymap.set("n", "<leader>wh", "<C-w>h", {})
-- vim.keymap.set("n", "<leader>wj", "<C-w>j", {})
-- vim.keymap.set("n", "<leader>wk", "<C-w>k", {})
-- vim.keymap.set("n", "<leader>wl", "<C-w>l", {})

-- -- Reload configuration without restart nvim
wk.register("<leader>r", "<cmd>so %<CR>", {})

-- -- Telescope
wk.register({
	["<leader>f"] = { name = "+file" },
	["<leader>ff"] = { "<cmd>Telescope find_files<cr>", "Find File" },
	["<leader>fr"] = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
	["<leader>fn"] = { "<cmd>enew<cr>", "New File" },
})

-- -- NvimTree
wk.register({
	["<leader>n"] = { "<cmd>NvimTreeToggle<CR>", "open/close" },
	["<leader>nr"] = { "<cmd>NvimTreeRefresh<CR>", "refresh" },
	["<leader>nf"] = { "<cmd>NvimTreeFindFile<CR>", "search file" }
})

-- -- Terminal
wk.register({
	["<leader>tt"] = { "<cmd>NeotermToggle<CR>", "toggle terminal" },
	["<leader>tx"] = { "<cmd>NeotermExit<CR>", "close terminal" },
})
