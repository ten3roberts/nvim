require 'config.plugins'
require 'config.keymap'
require 'config.devicons'
require 'config.mini'
require 'config.options'
require 'config.palette'.setup();
require 'config.dev_utils'
require 'config.commands'
require 'config.clean_fold'
require 'config.statusline'.setup()
require 'config.autocommands'

require 'darken'.setup {
  amount = 0.7,
  filetypes = { 'term', 'vaffle', 'qf', 'help', 'aerial', 'dap-repl' }
}

require 'qf'.setup {
  -- Location list configuration
  ['l'] = {
    auto_close    = false, -- Automatically close location/quickfix list if empty
    auto_follow   = "prev", -- Follow current entry, possible values: prev,next,nearest
    follow_slow   = true, -- Only follow on CursorHold
    auto_open     = true, -- Automatically open location list on QuickFixCmdPost
    auto_resize   = false, -- Auto resize and shrink location list if less than `max_height`
    max_height    = 5, -- Maximum height of location/quickfix list
    min_height    = 2, -- Minimum height of location/quickfix list
    wide          = false,
    unfocus_close = false,
    focus_open    = false,
  },
  -- Quickfix list configuration
  ['c'] = {
    auto_close    = true, -- Automatically close location/quickfix list if empty
    auto_follow   = "prev", -- Follow current entry, possible values: prev,next,nearest
    follow_slow   = true, -- Only follow on CursorHold
    auto_open     = true, -- Automatically open list on QuickFixCmdPost
    auto_resize   = true, -- Auto resize and shrink location list if less than `max_height`
    max_height    = 10, -- Maximum height of location/quickfix list
    min_height    = 5, -- Minumum height of location/quickfix list
    wide          = true,
    unfocus_close = false,
    focus_open    = false,
  },
}

require 'toggle'.setup {
  sets = {
    { 'true', 'false' },
    { 'creator', 'destroyer' },
    { 'on', 'off' },
    { 'yes', 'no' },
    { 'manual', 'auto' },
    { 'always', 'never' },
    { 'public', 'private' },
  },
  variants = true,
}


require "window-picker".setup {
  keys = "airesntmg"
}


require "recipe".setup {
  custom_recipes = {
    rust = {
      upgrade = "cargo upgrade --workspace",
    },
    global = {
      open = "xdg-open %:h",
      open_f = "xdg-open <cfile>"
    }
  }
}
