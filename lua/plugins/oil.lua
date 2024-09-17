return {
  {
    'stevearc/oil.nvim',
    opts = {
      keymaps = require("config.keymaps").oil(),
      -- use_default_keymaps = false,
      view_options = {
        show_hidden = false,
      }
    },
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
  }
}
