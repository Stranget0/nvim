return {
  {
    'stevearc/oil.nvim',
    opts = {
      keymaps = require("config.keymaps").oil(),
      use_default_keymaps = false,
    },
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
  }
}
