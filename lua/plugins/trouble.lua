return {
  "folke/trouble.nvim",
  enabled = false,
  opts = {
    throttle = {
      refresh = 1000, -- fetches new data when needed
      update = 10, -- updates the window
      render = 10, -- renders the window
      follow = 100, -- follows the current item
      preview = { ms = 100, debounce = true }, -- shows the preview for the current item
    },
  }, -- for default options, refer to the configuration section for custom setup.
  cmd = "Trouble",
  keys = {
    {
      "<leader>xx",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Diagnostics (Trouble)",
    },
    {
      "<leader>xX",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "Buffer Diagnostics (Trouble)",
    },
    {
      "<leader>cs",
      "<cmd>Trouble symbols toggle focus=false<cr>",
      desc = "Symbols (Trouble)",
    },
    {
      "<leader>cl",
      "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
      desc = "LSP Definitions / references / ... (Trouble)",
    },
    {
      "<leader>xL",
      "<cmd>Trouble loclist toggle<cr>",
      desc = "Location List (Trouble)",
    },
    {
      "<leader>cc",
      "<cmd>Trouble quickfix toggle<cr>",
      desc = "Quickfix List (Trouble)",
    },
    {
      "<leader>cf",
      "<cmd>Trouble quickfix focus<cr>",
      desc = "Quickfix List (Trouble)",
    },
    { "]q", "<cmd>cnext<cr>" },
    { "[q", "<cmd>cprev<cr>" },
  },
}
