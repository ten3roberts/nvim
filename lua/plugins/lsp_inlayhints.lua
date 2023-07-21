return {
  "lvimuser/lsp-inlayhints.nvim",
  enabled = true,
  lazy = false,
  config = function()
    require("lsp-inlayhints").setup {
      inlay_hints = {
        only_current_line = false,
      },
      -- highlight = "Comment",
      -- prefix = " » ",
      -- aligned = false,
      -- enabled = { "ChainingHint", "TypeHint", "ParameterHint" },
    }
  end,
}
