return {
  "ten3roberts/graphene.nvim",
  config = function()
    local graphene = require "graphene"
    graphene.setup {
      show_hidden = true,
    }
  end,
}