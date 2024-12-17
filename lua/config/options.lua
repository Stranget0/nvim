--
-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
--
-- File: config/options.lua
-- Description: General Neovim settings and configuration
-- Author: Kien Nguyen-Tuan <kiennt2609@gmail.com>
local icons = require("config.icons")
local cmd = vim.cmd
-- Set options (global/buffer/windows-scoped)
local opt = vim.opt
-- Global variables
local g = vim.g
local s = vim.s
local indent = 4

cmd([[
	filetype plugin indent on
]])

opt.backspace = { "eol", "start", "indent" } -- allow backspacing over everything in insert mode
opt.clipboard = "unnamed,unnamedplus"
vim.opt.fileencoding = "utf-8"               -- the encoding written to a file
opt.encoding = "utf-8"                       -- the encoding
opt.matchpairs = { "(:)", "{:}", "[:]", "<:>" }

-- indention
opt.autoindent = true    -- auto indentation
opt.expandtab = true     -- convert tabs to spaces
opt.shiftwidth = indent  -- the number of spaces inserted for each indentation
opt.smartindent = true   -- make indenting smarter
opt.softtabstop = indent -- when hitting <BS>, pretend like a tab is removed, even if spaces
opt.tabstop = indent     -- insert 2 spaces for a tab
opt.shiftround = true    -- use multiple of shiftwidth when indenting with "<" and ">"

-- search
opt.hlsearch = true   -- highlight all matches on previous search pattern
opt.ignorecase = true -- ignore case in search patterns
opt.smartcase = true  -- smart case
opt.wildignore = opt.wildignore + { "*/node_modules/*", "*/.git/*", "*/vendor/*" }
opt.wildmenu = true   -- make tab completion for files/buffers act like bash

-- ui
opt.cursorline = true -- highlight the current line
vim.opt.cursorlineopt = "both"

opt.laststatus = 2    -- only the last window will always have a status line
opt.lazyredraw = true -- don"t update the display while executing macros
opt.list = true

-- You can also add "space" or "eol", but I feel it"s quite annoying
opt.listchars = {
    tab = "┊ ",
    trail = "·",
    extends = "»",
    precedes = "«",
    nbsp = "×"
}

-- Hide cmd line
opt.cmdheight = 0      -- more space in the neovim command line for displaying messages

opt.mouse = "a"        -- allow the mouse to be used in neovim
opt.number = true      -- set numbered lines
vim.wo.relativenumber = true
opt.scrolloff = 1000   -- minimal number of screen lines to keep above and below the cursor
opt.incsearch = true
opt.sidescrolloff = 3  -- minimal number of screen columns to keep to the left and right (horizontal) of the cursor if wrap is `false`
opt.signcolumn = "yes" -- always show the sign column, otherwise it would shift the text each time
opt.splitbelow = true  -- open new split below
opt.splitright = true  -- open new split to the right
opt.wrap = false       -- display a long line

-- backups
opt.backup = false      -- create a backup file
opt.swapfile = false    -- creates a swapfile
opt.writebackup = false -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited

-- autocomplete
-- opt.completeopt = { "menu", "menuone", "noselect" } -- mostly just for cmp
opt.shortmess = opt.shortmess + {
    c = true
} -- hide all the completion messages, e.g. "-- XXX completion (YYY)", "match 1 of 2", "The only match", "Pattern not found"

-- By the way, -- INSERT -- is unnecessary anymore because the mode information is displayed in the statusline.
opt.showmode = false

-- perfomance
-- remember N lines in history
opt.history = 255    -- keep 255 lines of history
opt.redrawtime = 1500
opt.timeoutlen = 250 -- time to wait for a mapped sequence to complete (in milliseconds)
opt.ttimeoutlen = 10
opt.updatetime = 100 -- signify default updatetime 4000ms is not good for async update

-- theme
opt.termguicolors = true -- enable 24-bit RGB colors

-- persistent undo
-- Don"t forget to create folder $HOME/.local/share/nvim/undo
local undodir = vim.fn.stdpath("data") .. "/undo"
opt.undofile = true -- enable persistent undo
opt.undodir = undodir
opt.undolevels = 1000
opt.undoreload = 10000

-- fold
opt.foldmethod = "marker"
opt.foldlevel = 99

vim.diagnostic.config({
    virtual_text = false,
    virtual_lines = {
        only_current_line = true,
        highlight_whole_line = false,
    },
    severity_sort = true,
    float = {
        source = true,
        border = "shadow",
    },
    signs = {
        text = { icons.diagnostics.Error, icons.diagnostics.Warn, icons.diagnostics.Info, icons.diagnostics.Hint }
    }
})

-- 'JoosepAlviste/nvim-ts-context-commentstring',
g.skip_ts_context_commentstring_module = true

-- lsp line stop jumping the line if errors or warns
vim.wo.signcolumn = "yes"


-- Disable builtin plugins
local disabled_built_ins = { "2html_plugin", "getscript", "getscriptPlugin", "gzip", "logipat", "netrw", "netrwPlugin",
    "netrwSettings", "netrwFileHandlers", "matchit", "tar", "tarPlugin", "rrhelper",
    "spellfile_plugin", "vimball", "vimballPlugin", "zip", "zipPlugin", "tutor", "rplugin",
    "synmenu", "optwin", "compiler", "bugreport", "ftplugin" }


for _, plugin in pairs(disabled_built_ins) do
    g["loaded_" .. plugin] = 1
end


for name, icon in pairs(icons.diagnostics) do
    local hl = "DiagnosticSign" .. name
    vim.fn.sign_define(hl, { text = icon, numhl = hl, texthl = hl })
end

-- Colorscheme
cmd.colorscheme("oldworld")

-- neovide
if vim.g.neovide then
    vim.o.guifont = "FiraMono Nerd Font Mono:h12" -- text below applies for VimScript
    vim.g.neovide_cursor_animation_length = 0.03
    vim.g.neovide_cursor_smooth_blink = true
    local blink = "blinkwait500-blinkoff300-blinkon1000"
    vim.o.guicursor =
        "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:" ..
        blink .. "-Cursor/lCursor,sm:" .. blink
    vim.g.neovide_position_animation_length = 0.15
    vim.g.neovide_scroll_animation_length = 0.1

    vim.g.neovide_floating_shadow = true
    vim.g.neovide_floating_z_height = 10
    vim.g.neovide_light_angle_degrees = 45
    vim.g.neovide_light_radius = 5

    vim.g.neovide_transparency = 0.99
    vim.g.neovide_fullscreen = false
    vim.keymap.set({ 'n', 'v', 'i', 'c' }, '<F11>',
        function()
            vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
        end
        , { noremap = true, silent = true, desc = "Toggle Fullscreen" })

    vim.api.nvim_set_keymap('n', '<C-v>', '<C-r>+', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('v', '<C-v>', '<C-r>+', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('i', '<C-v>', '<C-r>+', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('c', '<C-v>', '<C-r>+', { noremap = true, silent = true })
end

vim.loader.enable()
vim.lsp.inlay_hint.enable()
vim.opt.foldmethod = "indent"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- Controls syntax highlighting for embedded languages in Vimscript files. (first letter is the language name)
vim.g.vimsyn_embed = "alpPrj"
-- Removes the default ~ characters displayed at the end of a buffer.
vim.opt.fillchars:append(',eob: ')
