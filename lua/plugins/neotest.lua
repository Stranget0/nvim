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
          require('rustaceanvim.neotest')
        },
        require('neotest-jest')({
          jestCommand = "npm test --",
          jestConfigFile = "custom.jest.config.ts",
          env = { CI = true },
          cwd = function(path)
            return vim.fn.getcwd()
          end,
        }),
        log_level = vim.log.levels.INFO,

        consumers = {
          overseer = function() return require("neotest.consumers.overseer") end,
        },
      })
    end,
  } }
