return {
  enabled = false,
  "numToStr/Comment.nvim",
  config = function()
    require("Comment").setup { ignore = "^$" }
  end,
}
