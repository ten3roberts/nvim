require 'config.keymap'
require 'config.options'
require 'config.palette'.setup();
require 'config.telescope'
require 'config.dev_utils'
require 'config.onlines'
require 'config.aerial'
-- require 'config.fzf'.setup()
require 'config.treesitter'
require 'config.commands'
require 'config.clean_fold'
require 'config.statusline'.setup()
require 'config.lsp'.setup()
require 'config.rust'
require 'config.dbg'
require 'config.pairs'
require 'config.completion'
require 'config.autocommands'
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
})

require'darken'.setup{
  amount = 0.5,
  filetypes = { 'term', 'vaffle', 'qf', 'help', 'aerial' }
}

require'qf'.setup{
  -- Location list configuration
  ['l'] = {
    auto_close = false, -- Automatically close location/quickfix list if empty
    auto_follow = 'prev', -- Follow current entry, possible values: prev,next,nearest
    follow_slow = false, -- Only follow on CursorHold
    auto_open = false, -- Automatically open location list on QuickFixCmdPost
    auto_resize = false, -- Auto resize and shrink location list if less than `max_height`
    max_height = 5, -- Maximum height of location/quickfix list
    min_height = 5, -- Minimum height of location/quickfix list
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
    auto_open = false, -- Automatically open list on QuickFixCmdPost
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
    { 'creator', 'destroyer' },
    { 'on', 'off' },
    { 'yes', 'no' },
    { 'manual', 'auto' },
    { 'always', 'never' },
    { 'public', 'private' },
  },
  variants = true,
}

require'nvim-web-devicons'.setup {
  -- your personnal icons can go here (to override)
  -- DevIcon will be appended to `name`
  override = {
    cs = {
      icon = "",
      color = "#a70495",
      name = "Cs"
    }
  };
  -- globally enable default icons (default to false)
  -- will get overriden by `get_icons` option
  default = true;
}

require 'config.palette'.setup()
require'pqf'.setup()

-- Configure project management
require("project_nvim").setup {
  manual_mode = false,
  detection_methods = { "pattern" },
  patterns = { ".git", ".svn", "package.json" },
  silent_chdir = false,
}

-- require'neoscroll'.setup {
--   -- easing_function = "quadratic",
--   use_local_scroll = true,
-- }

-- require'session'.setup { auto_restore = true }
