-- NOTE: Smooth scrolling with Cinnamon
return { {
  "declancm/cinnamon.nvim",
  event = "User FilePost",
  opts = {
    -- KEYMAPS:
    default_keymaps = true,  -- Create default keymaps.
    extra_keymaps = true,    -- Create extra keymaps.
    extended_keymaps = true, -- Create extended keymaps.
    scroll_limit = -1,
  },
} }
