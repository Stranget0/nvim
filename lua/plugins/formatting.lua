local keys = require("config.keyboard").keys
local slow_format_filetypes = { "rust", "json" }

local isFileIgnored = function(bufnr)
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    return bufname:match("/node_modules/") or bufname:match("/target/") or bufname:match("/.git/") or
        bufname:match("/.cargo/")
end

local isSlowFileType = function(bufnr)
    return vim.tbl_contains(slow_format_filetypes, vim.bo[bufnr].filetype)
end

local isFormatOnSaveDisabled = function(bufnr)
    return vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat
end


return {
    {
        'stevearc/conform.nvim',
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        keys = {
            {
                keys.buffers.format,
                function()
                    require("conform").format({ async = true, lsp_fallback = true })
                end,
                mode = "",
                desc = "Format buffer",
            }
        },

        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "isort", "black" },
                javascript = { "prettierd", "prettier" },
                typescript = { "prettierd", "prettier" },
                javascriptreact = { "prettierd", "prettier" },
                typescriptreact = { "prettierd", "prettier" },
                rust = { "rustfmt" },
                toml = { "taplo" },
                json = { "yq" },
                sh = { "shfmt" },
            },
            formatters = {
                shfmt = {
                    prepend_args = { "-i", "2" },
                },
            },
            format_on_save = function(bufnr)
                if isFileIgnored(bufnr) or isSlowFileType(bufnr) or isFormatOnSaveDisabled(bufnr) then
                    return
                end
                return { timeout_ms = 500, lsp_format = "fallback" }
            end,

            format_after_save = function(bufnr)
                if isFileIgnored(bufnr) or isFormatOnSaveDisabled(bufnr) or not isSlowFileType(bufnr) then
                    return
                end
                return { lsp_fallback = true }
            end,
        },
    }
}
