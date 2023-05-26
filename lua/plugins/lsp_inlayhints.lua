return {
  "lvimuser/lsp-inlayhints.nvim",
  lazy = true,
  config = function()
    require("lsp-inlayhints").setup {
      -- highlight = "Comment",
      -- prefix = " » ",
      -- aligned = false,
      -- only_current_line = false,
      -- enabled = { "ChainingHint", "TypeHint", "ParameterHint" },
    }
  end,
}
