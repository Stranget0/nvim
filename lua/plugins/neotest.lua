local functions = require "utils.functions"
---@diagnostic disable: missing-fields
return {
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            'mrcjkb/rustaceanvim',
            'nvim-neotest/neotest-jest',
            'mfussenegger/nvim-dap',
        },
        config = function()
            require("neotest").setup({
                watch = { enabled = false },
                default_strategy = "dap",
                diagnostic = {
                    enabled = true,
                    severity = vim.diagnostic.severity.WARN
                },
                summary = {
                    enabled = true,
                    animated = true,
                    expand_errors = true,
                    follow = true,
                    count = false,
                    mappings = require("config.keyboard").keys.testing_summary
                },

                adapters = {
                    require('rustaceanvim.neotest')
                },
                require('neotest-jest')({
                    jestCommand = "npm test --",
                    jestConfigFile = function(file)
                        local root = functions.guessMonorepoRoot(file)
                        local path = root .. "/jest.config.js"

                        if vim.uv.fs_stat(path) then
                            vim.notify("found jest config at " .. path, vim.log.levels.INFO)
                        else
                            vim.notify("no jest config found", vim.log.levels.ERROR)
                        end

                        return path
                    end,
                    env = { CI = true },
                    cwd = function(file)
                        return functions.guessMonorepoRoot(file)
                    end
                }),
                jest_test_discovery = true,
                discovery = {
                    enabled = false,
                    concurrent = 8
                },
                log_level = vim.log.levels.INFO,

                consumers = {
                    overseer = function() return require("neotest.consumers.overseer") end,
                },
                overseer = {
                    enabled = true,
                    -- When this is true (the default), it will replace all neotest.run.* commands
                    force_default = false
                }
            })
        end,
    } }
