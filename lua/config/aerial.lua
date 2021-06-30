vim.g.aerial = {
  -- Enum: persist, close, auto
  --   persist - aerial window will stay open until closed
  --   close   - aerial window will close when original file is no longer visible
  --   auto    - aerial window will stay open as long as there is a visible
  --             buffer to attach to
  close_behavior = 'global',

  -- Set to false to remove the default keybindings for the aerial buffer
  default_bindings = true,

  -- Enum: prefer_right, prefer_left, right, left
  -- Determines the default direction to open the aerial window. The 'prefer'
  -- options will open the window in the other direction *if* there is a
  -- different buffer in the way of the preferred direction
  default_direction = 'prefer_left',

  -- Place at the far edge
  placement_editor_edge = true,

  -- Fetch document symbols when LSP diagnostics change.
  -- If you set this to false, you will need to manually fetch symbols
  diagnostics_trigger_update = true,

  -- Enum: split_width, full_width, last, none
  -- Determines line highlighting mode when multiple buffers are visible
  highlight_mode = 'split_width',

  -- When jumping to a symbol, highlight the line for this many ms
  -- Set to 0 or false to disable
  highlight_on_jump = 300,

  -- Fold code when folding the tree. Only works when manage_folds is enabled
  link_tree_to_folds = true,

  -- Fold the tree when folding code. Only works when manage_folds is enabled
  link_folds_to_tree = false,

  -- Use symbol tree for folding. Set to true or false to enable/disable
  -- 'auto' will manage folds if your previous foldmethod was 'manual'
  manage_folds = 'auto',

  -- The maximum width of the aerial window
  max_width = 20,

  -- The minimum width of the aerial window.
  -- To disable dynamic resizing, set this to be equal to max_width
  min_width = 15,

  -- Set default symbol icons to use Nerd Font icons (see https://www.nerdfonts.com/)
  nerd_font = 'auto',

  -- Whether to open aerial automatically when entering a buffer.
  -- Can also be specified per-filetype as a map (see below)
  open_automatic = true,

  -- If open_automatic is true, only open aerial if the source buffer is at
  -- least this long
  open_automatic_min_lines = 0,

  -- If open_automatic is true, only open aerial if there are at least this many symbols
  open_automatic_min_symbols = 3,

  -- Run this command after jumping to a symbol (false will disable)
  post_jump_cmd = 'normal! zz',

  -- Set to false to not update the symbols when there are LSP errors
  update_when_errors = true,

  -- A list of all symbols to display. Set to false to display all symbols.
  filter_kind = {
    "Class",
    "Constructor",
    "Enum",
    "Function",
    "Interface",
    "Method",
    "Struct",
  },

  -- You can also override the default icons.
  icons = {
    Function = ' λ';
  },
}
