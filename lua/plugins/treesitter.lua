--
-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
--
-- File: plugins/treesitter.lua
-- Description: nvim-treesitter configuration
-- Author: Kien Nguyen-Tuan <kiennt2609@gmail.com>
return { {
  -- Treesitter interface
  "nvim-treesitter/nvim-treesitter",
  version = false, -- last release is way too old and doesn"t work on Windows
  build = ":TSUpdate",
  opts = {
    -- A list of parser names, or "all"
    ensure_installed = { "go", "python", "dockerfile", "json", "yaml", "markdown", "html", "scss", "css", "vim", "wgsl_bevy", "rust", "ron", "toml", "javascript", "typescript" },
    sync_install = false,
    highlight = {
      enable = true,
      use_languagetree = true,
      disable = function(lang, bufnr) -- Disable in large C++ buffers
        return vim.api.nvim_buf_line_count(bufnr) > 10000
      end,

    },
    indent = {
      enable = true
    },
    autotag = {
      enable = true
    },
    refactor = {
      highlight_definitions = {
        enable = true
      },
      highlight_current_scope = {
        enable = true
      }
    },
    incremental_selection = {
      enable = true,
      -- - init_selection: in normal mode, start incremental selection.
      --      Defaults to `gnn`.
      --    - node_incremental: in visual mode, increment to the upper named parent.
      --        Defaults to `grn`.
      --      - scope_incremental: in visual mode, increment to the upper scope
      --        (as defined in `locals.scm`). Defaults to `grc`.
      --  - node_decremental: in visual mode, decrement to the previous named node.
      --        Defaults to `grm`
      keymaps = {
        init_selection = "gnn",
        node_incremental = "grn",
        scope_incremental = "grc",
        node_decremental = "grm",
      },
    },
    textobjects = { enable = true },
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
    -- require("nvim-treesitter.install").prefer_git = false
    -- require("nvim-treesitter.install").compilers = { "zig", "clang", "gcc" }
  end
} }
