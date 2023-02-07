return {
  "ten3roberts/qf.nvim",
  keys = {
    {

      "<leader>E",
      function()
        require("qf").filter("visible", function(v)
          return v.type == "E"
        end)
      end,
    },
  },
  config = function()
    require("qf").setup {
      -- Location list configuration
      ["l"] = {
        auto_follow = "prev", -- Follow current entry, possible values: prev,next,nearest
      },
      -- Quickfix list configuration
      ["c"] = {
        auto_follow = "prev", -- Follow current entry, possible values: prev,next,nearest
        auto_resize = false,
        wide = true,
      },
      -- signs = signs,
    }
  end,
}
