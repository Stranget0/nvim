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


local keymaps = {
	common = function()
		local wk = require("which-key")

		wk.register({
			-- Telescope
			["<leader>p"] = { name = "+projects" },
			["<leader>pl"] = { "<cmd>Telescope zoxide list<cr>", "open project list" },
			["<leader>pa"] = { "<cmd>zoxide add<cr>", "add as project" },
			["<leader>f"] = { name = "+file" },
			["<leader>ff"] = { "<cmd>Telescope fd<cr>", "Find File" },
			["<leader>fr"] = { "<cmd>Telescope oldfiles<cr>", "Open Recent" },
			["<leader>fn"] = { "<cmd>enew<cr>", "New" },

			-- reload
			["<leader>cr"] = { "<cmd>so %<CR>", "reload nvim config" }
		})
	end,

	lsp = function(bufnr)
		local wk = require("which-key")

		vim.keymap.set("n", "<leader>cR", function()
			vim.cmd.RustLsp("codeAction")
		end, { desc = "Code Action", buffer = bufnr })
		vim.keymap.set("n", "<leader>dr", function()
			vim.cmd.RustLsp("debuggables")
		end, { desc = "Rust Debuggables", buffer = bufnr })


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
	end,

	rust_lsp = function(bufnr)
		local wk = require("which_key")

		wk.register({
			["<leader>cR"] = { function()
				vim.cmd.RustLsp("codeAction")
			end, "code action" },
			["<leader>dr"] = { function()
				vim.cmd.RustLsp("debuggables")
			end, "rust debuggables" }
		}, { buffer = bufnr })
	end,

	github = function(bufnr)
		local gitsigns = require('gitsigns')
		local wk = require("which-key")

		local function map(mode, l, r, desc, _opts)
			local opts = _opts or {}
			opts.buffer = bufnr
			opts.mode = mode
			wk.register({ [l] = { r, desc } }, opts)
		end

		-- Navigation
		map('n', ']c', function()
			if vim.wo.diff then
				vim.cmd.normal({ ']c', bang = true })
			else
				gitsigns.nav_hunk('next')
			end
		end, "next hunk")

		map('n', '[c', function()
			if vim.wo.diff then
				vim.cmd.normal({ '[c', bang = true })
			else
				gitsigns.nav_hunk('prev')
			end
		end, "prev hunk")


		-- Actions
		wk.register({ ["<leader>g"] = { name = "+git" } })

		map('n', '<leader>gs', gitsigns.stage_hunk, "stage hunk")
		map('n', '<leader>gr', gitsigns.reset_hunk, "reset hunk")
		map('v', '<leader>gs', function() gitsigns.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end, "stage hunk")
		map('v', '<leader>gr', function() gitsigns.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end, "reset hunk")
		map('n', '<leader>gS', gitsigns.stage_buffer, "stage buffer")
		map('n', '<leader>gu', gitsigns.undo_stage_hunk, "undo stage hunk")
		map('n', '<leader>gR', gitsigns.reset_buffer, "reset buffer")
		map('n', '<leader>gp', gitsigns.preview_hunk, "preview hunk")
		map('n', '<leader>gb', function() gitsigns.blame_line { full = true } end, "blame line")
		map('n', '<leader>gtb', gitsigns.toggle_current_line_blame, "toggle current line blame")
		map('n', '<leader>gd', gitsigns.diffthis, "diffthis")
		map('n', '<leader>gD', function() gitsigns.diffthis('~') end, "diffthis")
		map('n', '<leader>gtd', gitsigns.toggle_deleted, "toggle deleted")

		-- Text object
		map({ 'o', 'x' }, 'gih', ':<C-U>Gitsigns select_hunk<CR>', "select hunk")
	end,

	file_tree = function(bufnr)
		local wk = require("wk")
		local api = require('nvim-tree.api')

		local function opts(desc)
			return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
		end

		vim.keymap.set('n', '<C-]>', api.tree.change_root_to_node, opts('CD'))
		vim.keymap.set('n', '<C-e>', api.node.open.replace_tree_buffer, opts('Open: In Place'))
		vim.keymap.set('n', '<C-k>', api.node.show_info_popup, opts('Info'))
		vim.keymap.set('n', '<C-r>', api.fs.rename_sub, opts('Rename: Omit Filename'))
		vim.keymap.set('n', '<C-t>', api.node.open.tab, opts('Open: New Tab'))
		vim.keymap.set('n', '<C-v>', api.node.open.vertical, opts('Open: Vertical Split'))
		vim.keymap.set('n', '<C-x>', api.node.open.horizontal, opts('Open: Horizontal Split'))
		vim.keymap.set('n', '<BS>', api.node.navigate.parent_close, opts('Close Directory'))
		vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
		vim.keymap.set('n', '<Tab>', api.node.open.preview, opts('Open Preview'))
		vim.keymap.set('n', '>', api.node.navigate.sibling.next, opts('Next Sibling'))
		vim.keymap.set('n', '<', api.node.navigate.sibling.prev, opts('Previous Sibling'))
		vim.keymap.set('n', '.', api.node.run.cmd, opts('Run Command'))
		vim.keymap.set('n', '-', api.tree.change_root_to_parent, opts('Up'))
		vim.keymap.set('n', 'a', api.fs.create, opts('Create File Or Directory'))
		vim.keymap.set('n', 'bd', api.marks.bulk.delete, opts('Delete Bookmarked'))
		vim.keymap.set('n', 'bt', api.marks.bulk.trash, opts('Trash Bookmarked'))
		vim.keymap.set('n', 'bmv', api.marks.bulk.move, opts('Move Bookmarked'))
		vim.keymap.set('n', 'B', api.tree.toggle_no_buffer_filter, opts('Toggle Filter: No Buffer'))
		vim.keymap.set('n', 'c', api.fs.copy.node, opts('Copy'))
		vim.keymap.set('n', 'C', api.tree.toggle_git_clean_filter, opts('Toggle Filter: Git Clean'))
		vim.keymap.set('n', '[c', api.node.navigate.git.prev, opts('Prev Git'))
		vim.keymap.set('n', ']c', api.node.navigate.git.next, opts('Next Git'))
		vim.keymap.set('n', 'd', api.fs.remove, opts('Delete'))
		vim.keymap.set('n', 'D', api.fs.trash, opts('Trash'))
		vim.keymap.set('n', 'E', api.tree.expand_all, opts('Expand All'))
		vim.keymap.set('n', 'e', api.fs.rename_basename, opts('Rename: Basename'))
		vim.keymap.set('n', ']e', api.node.navigate.diagnostics.next, opts('Next Diagnostic'))
		vim.keymap.set('n', '[e', api.node.navigate.diagnostics.prev, opts('Prev Diagnostic'))
		vim.keymap.set('n', 'F', api.live_filter.clear, opts('Live Filter: Clear'))
		vim.keymap.set('n', 'f', api.live_filter.start, opts('Live Filter: Start'))
		vim.keymap.set('n', 'g?', api.tree.toggle_help, opts('Help'))
		vim.keymap.set('n', 'gy', api.fs.copy.absolute_path, opts('Copy Absolute Path'))
		vim.keymap.set('n', 'ge', api.fs.copy.basename, opts('Copy Basename'))
		vim.keymap.set('n', 'H', api.tree.toggle_hidden_filter, opts('Toggle Filter: Dotfiles'))
		vim.keymap.set('n', 'I', api.tree.toggle_gitignore_filter, opts('Toggle Filter: Git Ignore'))
		vim.keymap.set('n', 'J', api.node.navigate.sibling.last, opts('Last Sibling'))
		vim.keymap.set('n', 'K', api.node.navigate.sibling.first, opts('First Sibling'))
		vim.keymap.set('n', 'L', api.node.open.toggle_group_empty, opts('Toggle Group Empty'))
		vim.keymap.set('n', 'M', api.tree.toggle_no_bookmark_filter, opts('Toggle Filter: No Bookmark'))
		vim.keymap.set('n', 'm', api.marks.toggle, opts('Toggle Bookmark'))
		vim.keymap.set('n', 'o', api.node.open.edit, opts('Open'))
		vim.keymap.set('n', 'O', api.node.open.no_window_picker, opts('Open: No Window Picker'))
		vim.keymap.set('n', 'p', api.fs.paste, opts('Paste'))
		vim.keymap.set('n', 'P', api.node.navigate.parent, opts('Parent Directory'))
		vim.keymap.set('n', 'q', api.tree.close, opts('Close'))
		vim.keymap.set('n', 'r', api.fs.rename, opts('Rename'))
		vim.keymap.set('n', 'R', api.tree.reload, opts('Refresh'))
		vim.keymap.set('n', 's', api.node.run.system, opts('Run System'))
		vim.keymap.set('n', 'S', api.tree.search_node, opts('Search'))
		vim.keymap.set('n', 'u', api.fs.rename_full, opts('Rename: Full Path'))
		vim.keymap.set('n', 'U', api.tree.toggle_custom_filter, opts('Toggle Filter: Hidden'))
		vim.keymap.set('n', 'W', api.tree.collapse_all, opts('Collapse'))
		vim.keymap.set('n', 'x', api.fs.cut, opts('Cut'))
		vim.keymap.set('n', 'y', api.fs.copy.filename, opts('Copy Name'))
		vim.keymap.set('n', 'Y', api.fs.copy.relative_path, opts('Copy Relative Path'))
		vim.keymap.set('n', '<2-LeftMouse>', api.node.open.edit, opts('Open'))
		vim.keymap.set('n', '<2-RightMouse>', api.tree.change_root_to_node, opts('CD'))
	end,

	testing = function()
		local wk = require("which_key")
		local test = require("neotest").run

		wk.register({
			["<leader>t"] = { name = "+test" },
			["<leader>tt"] = { test.run, "run nearest" },
			["<leader>tf"] = {
				function()
					test.run(vim.fn.expand("%"))
				end,
				"run in file"
			},
			["<leader>ts"] = {
				test.stop,
				"stop nearest test"
			},
		})
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
		-- require("which_key").register({ ["g"] = { name = "+comment" } })

		return {
			-- Toggle comment (like `gcip` - comment inner paragraph) for both
			-- Normal and Visual modes
			comment = '<C-.>',

			-- Toggle comment on current line
			comment_line = '<C-/>',

			-- Toggle comment on visual selection
			comment_visual = '<C-/>',

			-- Define 'comment' textobject (like `dgc` - delete whole comment block)
			-- Works also in Visual mode if mapping differs from `comment_visual`
			textobject = '<C-/>',
		}
	end,

	static = {
		taplo = {
			{
				"K",
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
		hoversplit = {
			split_remain_focused = "<leader>hs",
			vsplit_remain_focused = "<leader>hv",
			split = "<leader>hS",
			vsplit = "<leader>hV",
		},
		format = {
			{
				"<leader>f",
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
