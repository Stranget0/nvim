local icons = require("config.icons")
local servers = {
  jsonls = {},
  dockerls = {},
  bashls = {},
  gopls = {},
  ruff_lsp = {},
  vimls = {},
  yamlls = {},
  eslint = {},
  lua_ls = {
    settings = {
      Lua = {
        completion = {
          callSnippet = "Replace"
        }
      }
    }
  },
  taplo = {
    keys = require("config.keymaps").static.taplo,
  },
}

return {
  {
    'VonHeikemen/lsp-zero.nvim',
    priority = 1,
    branch = 'v3.x',
    config = function()
      require("neodev").setup()
      local lsp = require('lsp-zero')
      lsp.extend_lspconfig()
      local keymaps = require('config.keymaps')

      lsp.set_sign_icons({
        error = icons.diagnostics.Error,
        warn = icons.diagnostics.Warn,
        info = icons.diagnostics.Info,
        hint = icons.diagnostics.Hint,
      })

      lsp.on_attach(function(client, bufnr)
        keymaps.lsp(bufnr)
      end)

      require('mason').setup({})
      local ensure_installed = { "codellb" }
      for server, config in pairs(servers) do
        table.insert(ensure_installed, server)
      end
      require('mason-lspconfig').setup({
        ensure_installed,
        handlers = {
          function(server_name)
            require('lspconfig')[server_name].setup(servers[server_name] or {})
          end,
          rust_analyzer = lsp.noop,
        },
      })

      local cmp = require('cmp')
      local cmp_action = lsp.cmp_action()

      cmp.setup({
        sources = {
          { name = "crates", },
          { name = "nvim_lsp", group_index = 1, },
          { name = "luasnip",  group_index = 2, },
          {
            name = "buffer",
            keyword_length = 2,
            group_index = 3,
          },
          { name = "path" },
        },
        mapping = cmp.mapping.preset.insert(keymaps.cmp(cmp, cmp_action)),
        preselect = cmp.PreselectMode.Item,
        performance = {
          debounce = 0,
          throttle = 0,
          fetching_timeout = 200,
          confirm_resolve_timeout = 100,
          async_budget = 100,
          max_view_entries = 40,

        },
        sorting = {
          priority_weight = 2,
          comparators = {
            cmp.config.compare.kind,
            cmp.config.compare.length,
            cmp.config.compare.offset,
            cmp.config.compare.recently_used,
            cmp.config.compare.exact,
            -- cmp.config.compare.scopes,
            -- cmp.config.compare.score,
            -- cmp.config.compare.locality,
            -- cmp.config.compare.sort_text,
            -- cmp.config.compare.order,
          },
        },
        -- matching = {
        -- 	disallow_fuzzy_matching = true,
        -- 	disallow_fullfuzzy_matching = true,
        -- 	disallow_partial_fuzzy_matching = true,
        -- 	disallow_partial_matching = false,
        -- 	disallow_prefix_unmatching = true,
        -- },
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
      })

      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())


      lsp.set_server_config({
        capabilities = {
          textDocument = {
            foldingRange = {
              dynamicRegistration = false,
              lineFoldingOnly = true
            }
          }
        }
      })

      vim.g.rustaceanvim.server.capabilities = lsp.get_capabilities()

      vim.o.foldcolumn = '1'
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      keymaps.cmp_ufo()
    end
  },

  { 'neovim/nvim-lspconfig' },
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/nvim-cmp' },
  { 'L3MON4D3/LuaSnip' },
  { 'kevinhwang91/nvim-ufo',            dependencies = 'kevinhwang91/promise-async' },
  'windwp/nvim-autopairs',
  'mrcjkb/rustaceanvim',
  "folke/neodev.nvim"
}
