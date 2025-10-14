return {
  "echasnovski/mini.nvim",
  config = function()
    require("mini.operators").setup {
      -- Evaluate math expressions
      evaluate = {
        prefix = "g=",
      },
      -- Exchange text regions
      exchange = {
        prefix = "gx",
      },
      -- Multiply (duplicate) text
      multiply = {
        prefix = "gm",
      },
      -- Replace with register
      replace = {
        prefix = "gr",
      },
      -- Sort text
      sort = {
        prefix = "gs",
      },
    }
  end,
}