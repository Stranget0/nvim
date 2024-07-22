return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "rouge8/neotest-rust"
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-rust"),
        },
        log_level = vim.log.levels.INFO,

        consumers = {
          overseer = function() return require("neotest.consumers.overseer") end,
        },
      })
    end,
  } }
