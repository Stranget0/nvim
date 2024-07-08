return { {
  "hedyhli/outline.nvim",
  lazy = true,
  cmd = { "Outline", "OutlineOpen" },
  keys = require("config.keymaps").code_outline(),
  opts = {
    auto_close = true,
  }
} }
