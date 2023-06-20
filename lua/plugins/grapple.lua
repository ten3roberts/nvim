return {
  "cbochs/grapple.nvim",
  enabled = false,
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local grapple = require "grapple"
    require("config.treebind").register({
      a = { grapple.tag },
      h = { grapple.popup_tags },
      q = {
        function()
          grapple.select { key = 1 }
        end,
      },
      w = {
        function()
          grapple.select { key = 2 }
        end,
      },
      f = {
        function()
          grapple.select { key = 3 }
        end,
      },
      p = {
        function()
          grapple.select { key = 4 }
        end,
      },
    }, { prefix = "<leader>h" })
  end,
}
