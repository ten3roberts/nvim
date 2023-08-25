local function qf(cmd, a, b, c, d)
  return function()
    print("qf." .. cmd)
    require("qf")[cmd](a, b, c, d)
  end
end

return {
  "ten3roberts/qf.nvim",
  keys = {
    {
      "<leader>E",
      qf("filter", "visible", function(v)
        return v.type == "E"
      end, true),
    },
    { "<leader>cc", qf("toggle", "c") },
    { "<leader>co", qf("open", "c") },
    -- { "<leader>cc", qf("close", "c") },

    { "<leader>ll", qf("toggle", "l") },
    { "<leader>lo", qf("open", "l") },
    { "<leader>lc", qf("close", "l") },

    { "[l", qf("prev", "l") },
    { "]l", qf("next", "l") },

    { "[L", qf("prev_group", "l") },
    { "]L", qf("next_group", "l") },

    { "[q", qf("prev", "c") },
    { "]q", qf("next", "c") },

    { "[Q", qf("prev_group", "c") },
    { "]Q", qf("next_group", "c") },
    { "]Q", qf("next_group", "c") },

    {
      "<leader>lf",
      function()
        require("telescope").extensions.qf.list {
          list = "l",
        }
      end,
      { desc = "Location list" },
    },
    {
      "<leader>cf",
      function()
        require("telescope").extensions.qf.list {
          list = "c",
        }
      end,
      { desc = "Location list" },
    },
  },
  opts = {
    -- Location list configuration
    ["l"] = {
      auto_follow = "prev",
    },
    -- Quickfix list configuration
    ["c"] = {
      auto_follow = "prev",
      auto_resize = false,
      wide = true,
    },
    close_other = true,
    -- signs = signs,
  },
}
