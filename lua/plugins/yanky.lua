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
  },
  config = function()
    require("yanky").setup {
      ring = {
        history_length = 50,
        storage = "shada",
      },
      system_clipboard = {
        sync_with_ring = false, -- We handle sync manually below
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

    -- Smart sync: only explicit yanks (y) go to system clipboard, not d/c/x
    vim.api.nvim_create_autocmd("TextYankPost", {
      group = vim.api.nvim_create_augroup("YankToClipboard", { clear = true }),
      callback = function()
        if vim.v.event.operator == "y" then
          vim.fn.setreg("+", vim.fn.getreg('"'))
        end
      end,
    })
  end,
}

