return {
  "lvimuser/lsp-inlayhints.nvim",
  enabled = false,
  lazy = false,
  config = function()
    require("lsp-inlayhints").setup {
      inlay_hints = {
        only_current_line = true,
      },
      -- highlight = "Comment",
      -- prefix = " » ",
      -- aligned = false,
      -- enabled = { "ChainingHint", "TypeHint", "ParameterHint" },
    }
  end,
}
