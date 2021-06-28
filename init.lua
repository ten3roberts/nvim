require 'config.keymap'
require 'config.options'
require 'config.dev_utils'
require 'config.onlines'
require 'config.autocommands'
require 'config.aerial'
require 'config.completion'
require 'config.telescope'
require 'config.treesitter'
require 'config.commands'
require 'config.clean_fold'
require 'config.fzf'
require 'config.lsp'.setup()

require 'config.statusline'.setup()

require'colorizer'.setup(
  { '*' },
  {
    RGB      = true,         -- #RGB hex codes
    RRGGBB   = true,         -- #RRGGBB hex codes
    names    = true,         -- "Name" codes like Blue
    RRGGBBAA = true,        -- #RRGGBBAA hex codes
    rgb_fn   = false,        -- CSS rgb() and rgba() functions
    hsl_fn   = false,        -- CSS hsl() and hsla() functions
    css      = false,        -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
    css_fn   = false,        -- Enable all CSS *functions*: rgb_fn, hsl_fn
    -- Available mod,s: foreground, background
    mode     = 'foreground', -- Set the display mode.
  }
)

require'gitsigns'.setup({
  current_line_blame = false,
  current_line_blame_delay = 1000,
})

require'darken'.setup{
  amount = 0.7,
  filetypes = { 'NvimTree', 'qf', 'help', 'aerial' }
}

require'qf'.setup{
  -- Location list configuration
  ['l'] = {
    auto_close = false, -- Automatically close location/quickfix list if empty
    auto_follow = 'prev', -- Follow current entry, possible values: prev,next,nearest
    follow_slow = false, -- Only follow on CursorHold
    auto_open = true, -- Automatically open location list on QuickFixCmdPost
    auto_resize = true, -- Auto resize and shrink location list if less than `max_height`
    max_height = 5, -- Maximum height of location/quickfix list
    min_height = 5, -- Minumum height of location/quickfix list
    wide = false,
    unfocus_close = false,
    focus_open = false,
    close_other = true,
  },
  -- Quickfix list configuration
  ['c'] = {
    auto_close = true, -- Automatically close location/quickfix list if empty
    auto_follow = 'prev', -- Follow current entry, possible values: prev,next,nearest
    follow_slow = true, -- Only follow on CursorHold
    auto_open = true, -- Automatically open list on QuickFixCmdPost
    auto_resize = true, -- Auto resize and shrink location list if less than `max_height`
    max_height = 10, -- Maximum height of location/quickfix list
    min_height = 5, -- Minumum height of location/quickfix list
    wide = true,
    unfocus_close = false,
    focus_open = false,
    close_other = true,
  },
}

require'toggle'.setup{
  sets = {
    { 'true', 'false' },
    { 'on', 'off' },
    { 'yes', 'no' },
    { 'manual', 'auto' },
    { 'always', 'never' },
  },
  variants = true,
}
