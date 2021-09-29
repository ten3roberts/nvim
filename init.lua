require 'config.keymap'
require 'config.options'
require 'config.telescope'
require 'config.dev_utils'
require 'config.onlines'
require 'config.autocommands'
require 'config.aerial'
require 'config.completion'
require 'config.treesitter'
require 'config.commands'
require 'config.clean_fold'
require 'config.statusline'.setup()
require 'config.pairs'
require 'config.lsp'.setup()
require 'config.dbg'
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

require('auto-session').setup{
  auto_session_suppress_dirs = {vim.env.HOME},
}

require'gitsigns'.setup({
  current_line_blame = false,
})

require'darken'.setup{
  amount = 0.7,
  filetypes = { 'term', 'vaffle', 'qf', 'help', 'aerial' }
}

require'qf'.setup{
  -- Location list configuration
  ['l'] = {
    auto_close = false, -- Automatically close location/quickfix list if empty
    auto_follow = 'nearest', -- Follow current entry, possible values: prev,next,nearest
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
    auto_open = true, -- Automatically open list on QuickFixCmdPost
    auto_resize = false, -- Auto resize and shrink location list if less than `max_height`
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
    { 'public', 'private' },
  },
  variants = true,
}

require'zen-mode'.setup {
  window = {
    backdrop = 0.5, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
    -- height and width can be:
    -- * an absolute number of cells when > 1
    -- * a percentage of the width / height of the editor when <= 1
    width = 80, -- width of the Zen window
    height = 1, -- height of the Zen window
    -- by default, no options are changed for the Zen window
    -- uncomment any of the options below, or add other vim.wo options you want to apply
    options = {
      signcolumn = "no", -- disable signcolumn
      number = false, -- disable number column
      relativenumber = false, -- disable relative numbers
      -- cursorline = false, -- disable cursorline
      -- cursorcolumn = false, -- disable cursor column
      -- foldcolumn = "0", -- disable fold column
      -- list = false, -- disable whitespace characters
    },
  },
  plugins = {
    -- disable some global vim options (vim.o...)
    -- comment the lines to not apply the options
    options = {
      enabled = true,
      ruler = false, -- disables the ruler text in the cmd line area
      showcmd = false, -- disables the command in the last line of the screen
    },
    gitsigns = { enabled = true }, -- disables git signs
    -- this will change the font size on kitty when in zen mode
    -- to make this work, you need to set the following kitty options:
    -- - allow_remote_control socket-only
    -- - listen_on unix:/tmp/kitty
    kitty = {
      enabled = true,
      font = "+4", -- font size increment
    },
  },
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

-- vim.cmd 'packadd termdebug'

-- local R = require "pears.rule"

-- require "pears".setup(function(conf)
--   conf.pair("{", "}")
--   conf.pair("\"", {
--     close = "\"",
--     should_expand = R.not_(R.start_of_context "\\"),
--   })
--   conf.pair("<", {
--     close = ">",
--     should_expand = R.all_of(
--       -- Don't expand a quote if it comes after an alpha character
--       R.not_(R.start_of_context "[a-zA-Z]"),
--       -- Only expand when in a treesitter "string" node
--       R.child_of_node "type_parameters"
--     )
--   })
--   conf.preset("tag_matching")
--   conf.expand_on_enter(true)
-- end)
