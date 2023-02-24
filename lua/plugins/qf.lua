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
        auto_follow = "nearest",
      },
      -- Quickfix list configuration
      ["c"] = {
        auto_follow = "nearest",
        auto_resize = false,
        wide = true,
      },
      -- signs = signs,
    }
  end,
}
