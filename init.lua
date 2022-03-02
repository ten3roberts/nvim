require 'config.keymap'
require 'config.devicons'
require 'config.options'
require 'config.palette'.setup();
require 'config.telescope'
require 'config.dev_utils'
require 'config.onlines'
require 'config.aerial'
-- require 'config.sidebar'
-- require 'config.fzf'.setup()
require 'config.treesitter'
require 'config.lir'
require 'config.commands'
require 'config.clean_fold'
require 'config.statusline'.setup()
require 'config.lsp'
-- require 'config.rust'
require 'config.dbg'
require 'config.pairs'
require 'config.completion'
require 'config.autocommands'
require 'config.neogit'
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

  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", {expr=true})
    map('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", {expr=true})

    -- Actions
    map({'n', 'v'}, '<leader>hs', gs.stage_hunk)
    map({'n', 'v'}, '<leader>hr', gs.reset_hunk)
    map('n', '<leader>hS', gs.stage_buffer)
    map('n', '<leader>hu', gs.undo_stage_hunk)
    map('n', '<leader>hR', gs.reset_buffer)
    map('n', '<leader>hp', gs.preview_hunk)
    map('n', '<leader>hb', function() gs.blame_line{full=true} end)
    map('n', '<leader>tb', gs.toggle_current_line_blame)
    map('n', '<leader>hd', gs.diffthis)
    map('n', '<leader>hD', function() gs.diffthis('~') end)
    map('n', '<leader>td', gs.toggle_deleted)

    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
})

require'darken'.setup{
  amount = 0.7,
  filetypes = { 'term', 'vaffle', 'qf', 'help', 'aerial' }
}

require'qf'.setup{
  -- Location list configuration
  ['l'] = {
    auto_close    = false, -- Automatically close location/quickfix list if empty
    auto_follow   = "prev", -- Follow current entry, possible values: prev,next,nearest
    follow_slow   = false, -- Only follow on CursorHold
    auto_open     = true, -- Automatically open location list on QuickFixCmdPost
    auto_resize   = false, -- Auto resize and shrink location list if less than `max_height`
    max_height    = 5, -- Maximum height of location/quickfix list
    min_height    = 2, -- Minimum height of location/quickfix list
    wide          = false,
    unfocus_close = false,
    focus_open    = false,
    close_other   = true,
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
    close_other   = true,
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

require 'config.palette'.setup()
require'pqf'.setup()
require('auto-session').setup {
  log_level = 'info',
  auto_session_suppress_dirs = {'~/'}
}

require 'zen-mode'.setup()

require "window-picker".setup {
  keys = "airesntmg"
}

local make_recipe = require("recipe.lib").make_recipe
require "recipe".setup {
  custom_recipes = {
    rust = {
      upgrade = make_recipe("cargo upgrade --workspace"),
    },
    global = {
      open = make_recipe("xdg-open %:h"),
      open_f = make_recipe("xdg-open <cfile>")
    }
  }
}

require "neoscroll".setup {}

vim.notify = require("notify")

vim.cmd "packadd termdebug"
