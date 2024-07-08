return { {
  "hedyhli/outline.nvim",
  lazy = true,
  cmd = { "Outline", "OutlineOpen" },
  config = function()
    local outline = require("outline").setup()
    require("config.keymaps").code_outline(outline)
  end
} }
