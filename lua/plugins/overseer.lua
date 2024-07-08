return {
  {
    'stevearc/overseer.nvim',
    config = function(opts)
      require('overseer').setup(opts)
      require("config.keymaps").overseer()
    end
  }
}
