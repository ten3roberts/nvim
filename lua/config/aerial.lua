-- Call the setup function to change the default behavior
require("aerial").setup {
  -- backends = { "treesitter", "lsp", "markdown" },
  layout = {

    -- The maximum width of the aerial window
    max_width = { 30, 0.2 },
    placement = "edge",
    default_direction = "left",
  },

  attach_mode = "global",
  close_automatic_events = { "unsupported" },

  default_bindings = true,

  -- Use symbol tree for folding. Set to true or false to enable/disable
  -- 'auto' will manage folds if your previous foldmethod was 'manual'
  manage_folds = false,

  -- Automatically open aerial when entering supported buffers.
  -- This can be a function (see :help aerial-open-automatic)
  open_automatic = true,

  -- Run this command after jumping to a symbol (false will disable)
  post_jump_cmd = "normal! zz",

  -- -- Show box drawing characters for the tree hierarchy
  -- show_guides = false,
}
