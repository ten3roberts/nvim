return {
  "TimUntersberger/neogit",
  dev = true,
  dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
  keys = {
    {
      "<leader>gg",
      function()
        require("neogit").open()
      end,
    },
  },
  config = function()
    local neogit = require "neogit"
    neogit.setup {
      integrations = {
        diffview = true,
      },
      disable_builtin_notifications = true,
      auto_show_console = false,
      disable_commit_confirmation = false,
      sections = {
        -- untracked = {
        --   folded = true,
        -- },
        -- unstaged = {
        --   folded = false,
        -- },
        -- staged = {
        --   folded = false,
        -- },
        -- stashes = {
        --   folded = true,
        -- },
        -- unpulled = {
        --   folded = false,
        -- },
        -- unmerged = {
        --   folded = false,
        -- },
        recent = {
          folded = false,
        },
      },
    }
  end,
}
