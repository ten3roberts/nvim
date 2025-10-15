return {
  "ten3roberts/window-picker.nvim",
  keys = {
    {
      "<leader>w",
      function()
        require("window-picker").pick()
      end,
    },
    {
      "<leader><A-w>",
      function()
        require("window-picker").zap()
      end,
    },
    {
      "<leader>W",
      function()
        require("window-picker").swap(false)
      end,
    },
  },
  config = function()
    require("window-picker").setup {
      keys = "aorisetngm",
    }
  end,
}