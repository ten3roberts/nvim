local sidebar = require 'sidebar-nvim'

local opts = {
  open = true,
  initial_width = 30,
  sections = { "symbols", "git", "diagnostics", "todos" },
  todos = {
    initially_closed = false,
  }
}

sidebar.setup(opts)
