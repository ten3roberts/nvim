return {
  enabled = false,
  "AndrewRadev/sideways.vim",
  keys = {
    { "<c-h>", "<cmd>:SidewaysLeft<CR>" },
    { "<c-l>", "<cmd>:SidewaysRight<CR>" },
    { "aa", "<Plug>SidewaysArgumentTextobjA", mode = { "x", "o" } },
    { "ia", "<Plug>SidewaysArgumentTextobjI", mode = { "x", "o" } },
  },
}
