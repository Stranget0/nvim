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
wk.register({ ["<leader>cr"] = { "<cmd>so %<CR>", "reload nvim config" } })

-- Telescope
wk.register({
	["<leader>p"] = { name = "+projects" },
	["<leader>pl"] = { "<cmd>Telescope zoxide list<cr>", "open project list" },
	["<leader>pa"] = { "<cmd>zoxide add<cr>", "add this dir as project" },
	["<leader>f"] = { name = "+file" },
	["<leader>ff"] = { "<cmd>Telescope fd<cr>", "Find File" },
	["<leader>fr"] = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
	["<leader>fn"] = { "<cmd>enew<cr>", "New File" },
})

-- Terminal
wk.register({
	["<leader>tt"] = { "<cmd>NeotermToggle<CR>", "toggle terminal" },
	["<leader>tx"] = { "<cmd>NeotermExit<CR>", "close terminal" },
})

local wk = require("which-key")

wk.register({
	["[g"] = { vim.diagnostic.goto_prev, "go prev" },
	["]g"] = { vim.diagnostic.goto_next, "go next" },
	["<leader>dd"] = { vim.diagnostic.setqflist, "quick fix list" },
	["gD"] = { vim.lsp.buf.declaration, "go declaration" },
	["gd"] = { vim.lsp.buf.definition, "go definition" },
	["gi"] = { vim.lsp.buf.implementation, "go implementation" },
	["<leader>D"] = { vim.lsp.buf.type_definition, "go type" },
	["gr"] = { vim.lsp.buf.references, "go references" },
	["<leader>rn"] = { vim.lsp.buf.rename, "rename" },
	["L"] = { vim.lsp.buf.hover, "hover info" },
}, { buffer = bufnr })

wk.register({ ["<leader>ca"] = { vim.lsp.buf.code_action, "code action" }, { buffer = bufnr, mode = { "n", "v" } } })
