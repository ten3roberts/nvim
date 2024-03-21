return {
  "stevearc/aerial.nvim",
  keys = {
    { "<leader>po", "<cmd>AerialNavOpen<CR>" },
    { "<leader>pp", "<cmd>AerialOpen<CR>" },
  },
  event = "BufWinEnter",
  config = function()
    local aerial = require "aerial"
    aerial.setup {
      backends = { "treesitter", "lsp", "markdown" },
      -- on_attach = function(bufnr)
      -- vim.keymap.set("n", "[[", "<cmd>AerialPrev<CR>", { buffer = bufnr })
      -- vim.keymap.set("n", "]]", "<cmd>AerialNext<CR>", { buffer = bufnr })
      -- end,
      layout = {

        -- The maximum width of the aerial window
        max_width = { 30, 0.2 },
        placement = "edge",
        default_direction = "left",
      },
      nav = {
        border = "single",
        min_height = { 16, 0.3 },
        max_height = 0.9,
        max_width = 0.5,
        min_width = { 0.2, 20 },
        win_opts = {
          cursorline = true,
          winblend = 10,
        },
        -- Jump to symbol in source window when the cursor moves
        autojump = false,
        -- Show a preview of the code in the right column, when there are no child symbols
        preview = true,
        -- Keymaps in the nav window
        keymaps = {
          ["<CR>"] = "actions.jump",
          ["<2-LeftMouse>"] = "actions.jump",
          ["<C-v>"] = "actions.jump_vsplit",
          ["<C-s>"] = "actions.jump_split",
          ["h"] = "actions.left",
          ["l"] = "actions.right",
          ["q"] = "actions.close",
        },
      },
      attach_mode = "global",

      -- default_bindings = true,

      -- Use symbol tree for folding. Set to true or false to enable/disable
      -- 'auto' will manage folds if your previous foldmethod was 'manual'
      -- manage_folds = false,

      -- Automatically open aerial when entering supported buffers.
      -- This can be a function (see :help aerial-open-automatic)
      open_automatic = function(_)
        return (not vim.o.diff) and vim.api.nvim_win_get_width(0) > 120
      end,

      -- close_automatic_events = { "unsupported" },

      -- Run this command after jumping to a symbol (false will disable)
      post_jump_cmd = "normal! zz",
    }
  end,
}
