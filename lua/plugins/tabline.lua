local icons = require("config.icons")
local keymaps = require("config.keymaps")

return {
  {
    "willothy/nvim-cokeline",
    dependencies = {
      "nvim-lua/plenary.nvim",       -- Required for v0.4.0+
      "nvim-tree/nvim-web-devicons", -- If you want devicons
      -- "stevearc/resession.nvim"      -- Optional, for persistent history
    },
    config = function()
      local get_hl = require('cokeline.hlgroups').get_hl_attr
      local is_picking_focus = require('cokeline.mappings').is_picking_focus
      local is_picking_close = require('cokeline.mappings').is_picking_close

      local is_modified = {
        text = function(buffer)
          if buffer.is_modified then
            return icons.modified
          end
          return ''
        end
      }

      local buffer_index = {
        text = function(buffer)
          return buffer.index
        end
      }

      local diagnostic_icon = {
        text = function(buffer)
          local is_error = buffer.diagnostics.errors > 0
          local is_warning = buffer.diagnostics.warnings > 0
          local is_hint = buffer.diagnostics.hints > 0
          local is_info = buffer.diagnostics.infos > 0

          if is_error then
            return " " .. icons.diagnostics.Error
          elseif
              is_warning then
            return " " .. icons.diagnostics.Warn
          elseif
              is_info then
            return " " .. icons.diagnostics.Info
          elseif
              is_hint then
            return " " .. icons.diagnostics.Hint
          else
            return ''
          end
        end,

        fg = function(buffer)
          local is_error = buffer.diagnostics.errors > 0
          local is_warning = buffer.diagnostics.warnings > 0
          local is_hint = buffer.diagnostics.hints > 0
          local is_info = buffer.diagnostics.infos > 0

          if is_error then
            return get_hl("DiagnosticError", "fg")
          elseif
              is_warning then
            return get_hl("DiagnosticWarn", "fg")
          elseif
              is_hint then
            return get_hl("DiagnosticHint", "fg")
          elseif
              is_info then
            return get_hl("DiagnosticInfo", "fg")
          else
            return get_hl("Normal", "fg")
          end
        end,

      }


      local file_icon = {
        text = function(buffer)
          if (is_picking_focus() or is_picking_close())
          then
            return buffer.pick_letter
          else
            return buffer.devicon.icon
          end
        end,
        fg = function(buffer)
          if is_picking_close() then
            return get_hl("DiagnosticError", "fg")
          elseif
              is_picking_focus() then
            get_hl("DiagnosticOk", "fg")
          else
            return buffer.devicon.color
          end
        end,
      }

      local file_name = {
        text = function(buffer) return buffer.filename end,
        bold = function(buffer) return buffer.is_focused end
      }

      local unique_prefix = {
        text = function(buffer)
          return buffer.unique_prefix
        end,
        style = 'italic',
        truncation = {
          priority = 3,
          direction = 'left',
        },
      }

      local padding_l = {
        text = '  ',
      }
      local padding_s = {
        text = " "
      }

      keymaps.buffer()

      require('cokeline').setup({
        show_if_buffers_are_at_least = 1,
        fill_hl = "StatusLine",

        default_hl = {
          fg = function(buffer)
            return buffer.devicon.color or get_hl("Normal", "fg")
          end,
          bg = function(buffer)
            return not buffer.is_focused and
                get_hl("StatusLine", "bg")
                or
                get_hl("Normal", "bg")
          end,
        },
        components = {
          padding_l,
          buffer_index,
          padding_s,
          file_icon,
          unique_prefix,
          file_name,
          is_modified,
          diagnostic_icon,
          padding_l,
        },

        tabs = {
          placement = "right",
          components = {}
        }

      })
    end
  }
}
