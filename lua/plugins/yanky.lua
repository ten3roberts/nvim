return {
  "gbprod/yanky.nvim",
  lazy = true,
  keys = {
    { "y", "<Plug>(YankyYank)", mode = { "n", "x" } },
    { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" } },
    { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" } },
    { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" } },
    { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" } },
    { "<A-n>", "<Plug>(YankyCycleForward)" },
    { "<A-p>", "<Plug>(YankyCycleBackward)" },
    {
      "<C-p>",
      function()
        require("telescope").extensions.yank_history.yank_history {}
      end,
    },
  },
  config = function()
    require("yanky").setup {
      ring = {},
      system_clipboard = {
        sync_with_ring = false,
      },
      highlight = {
        on_put = true,
        on_yank = true,
        timer = 200,
      },
      preserve_cursor_position = {
        enabled = true,
      },
    }
  end,
}