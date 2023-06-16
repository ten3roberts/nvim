return {
  "rcarriga/nvim-notify",
  lazy = false,

  priority = 100,
  keys = { { "<leader>pn", "<cmd>Telescope notify notify<CR>" } },
  config = function()
    require("notify").setup {
      timeout = 1000,
      render = "minimal",
      stages = "slide",
      level = "debug",
      top_down = true,
      -- max_width = 120,

      -- on_open = function(win)
      --   if vim.api.nvim_win_is_valid(win) then
      --     vim.api.nvim_win_set_config(win, { border = "single" })
      --   end
      -- end,
    }

    vim.notify = require "notify"
  end,
}
