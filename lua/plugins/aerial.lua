return {

  "stevearc/aerial.nvim",
  keys = {
    { "<leader>po", "<cmd>AerialNavOpen<CR>" },
    { "<leader>pp", "<cmd>AerialToggle!<CR>" },
  },
  event = "BufWinEnter",
  config = function()
    local aerial = require "aerial"
    aerial.setup {
      -- backends = { "treesitter", "lsp", "markdown" },
      on_attach = function(bufnr)
        vim.keymap.set("n", "[[", "<cmd>AerialPrev<CR>", { buffer = bufnr })
        vim.keymap.set("n", "]]", "<cmd>AerialNext<CR>", { buffer = bufnr })
      end,
      layout = {

        -- The maximum width of the aerial window
        max_width = { 30, 0.2 },
        -- placement = "edge",
        default_direction = "prefer_left",
      },

      attach_mode = "global",

      -- default_bindings = true,

      -- Use symbol tree for folding. Set to true or false to enable/disable
      -- 'auto' will manage folds if your previous foldmethod was 'manual'
      -- manage_folds = false,

      -- Automatically open aerial when entering supported buffers.
      -- This can be a function (see :help aerial-open-automatic)
      open_automatic = function(_)
        return not vim.o.diff
      end,

      -- close_automatic_events = { "unsupported" },

      -- Run this command after jumping to a symbol (false will disable)
      post_jump_cmd = "normal! zz",
    }
  end,
}
