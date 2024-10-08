--
-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
--
-- File: plugins/gitsigns.lua
-- Description: Gitsigns configuration
-- Author: Kien Nguyen-Tuan <kiennt2609@gmail.com>
return { {
  -- Git integration for buffers
  "lewis6991/gitsigns.nvim",
  opts = {
    signs = {
      add = {
        hl = "GitSignsAdd",
        text = "│",
        numhl = "GitSignsAddNr",
        linehl = "GitSignsAddLn"
      },
      change = {
        hl = "GitSignsChange",
        text = "│",
        numhl = "GitSignsChangeNr",
        linehl = "GitSignsChangeLn"
      },
      delete = {
        hl = "GitSignsDelete",
        text = "_",
        numhl = "GitSignsDeleteNr",
        linehl = "GitSignsDeleteLn"
      },
      topdelete = {
        hl = "GitSignsDelete",
        text = "‾",
        numhl = "GitSignsDeleteNr",
        linehl = "GitSignsDeleteLn"
      },
      changedelete = {
        hl = "GitSignsChange",
        text = "~",
        numhl = "GitSignsChangeNr",
        linehl = "GitSignsChangeLn"
      },
      untracked = {
        hl = "GitSignsAdd",
        text = "┆",
        numhl = "GitSignsAddNr",
        linehl = "GitSignsAddLn"
      }
    },
    signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
    numhl = false,     -- Toggle with `:Gitsigns toggle_numhl`
    linehl = false,    -- Toggle with `:Gitsigns toggle_linehl`
    word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir = {
      interval = 1000,
      follow_files = true
    },
    attach_to_untracked = true,
    current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil, -- Use default
    max_file_length = 40000,
    preview_config = {
      -- Options passed to nvim_open_win
      border = "shadow",
      style = "minimal",
      relative = "cursor",
      row = 0,
      col = 1
    },
    yadm = {
      enable = false
    }
  },
  ---@param opts TSConfig
  config = function(_, opts)
    require("gitsigns").setup(
      {
        signs                             = {
          add          = { text = '░' },
          change       = { text = '░' },
          delete       = { text = '_' },
          topdelete    = { text = '‾' },
          changedelete = { text = '~' },
          untracked    = { text = '┆' },
        },
        signcolumn                        = true,  -- Toggle with `:Gitsigns toggle_signs`
        numhl                             = false, -- Toggle with `:Gitsigns toggle_numhl`
        linehl                            = false, -- Toggle with `:Gitsigns toggle_linehl`
        word_diff                         = false, -- Toggle with `:Gitsigns toggle_word_diff`
        watch_gitdir                      = {
          follow_files = true
        },
        auto_attach                       = true,
        attach_to_untracked               = false,
        current_line_blame                = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts           = {
          virt_text = true,
          virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
          delay = 1000,
          ignore_whitespace = false,
          virt_text_priority = 100,
        },
        current_line_blame_formatter      = '<author>, <author_time:%Y-%m-%d> - <summary>',
        current_line_blame_formatter_opts = {
          relative_time = false,
        },
        sign_priority                     = 6,
        update_debounce                   = 100,
        status_formatter                  = nil,   -- Use default
        max_file_length                   = 40000, -- Disable if file is longer than this (in lines)
        preview_config                    = {
          -- Options passed to nvim_open_win
          border = 'shadow',
          style = 'minimal',
          relative = 'cursor',
          row = 0,
          col = 1
        },
        on_attach                         = function(bufnr)
          require("config.keymaps").github(bufnr)
        end
      }
    )
  end
} }
