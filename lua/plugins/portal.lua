local M = {
  enabled = true,
  lazy = false,
  "cbochs/portal.nvim",
  dependencies = {
    -- "cbochs/grapple.nvim", -- Optional: provides the "grapple" query item
    "ThePrimeagen/harpoon",
  },
  keys = {
    {
      "<leader>i",
      "<cmd>Portal jumplist forward<cr>",
    },
    {

      "<leader>o",
      "<cmd>Portal jumplist backward<cr>",
    },
  },
}

function M.config()
  print "Setting up portal"

  vim.keymap.set("n", "<leader>H", function()
    require("portal").tunnel {
      require("portal.builtin").grapple.query { direction = "forward" },
      require("portal.builtin").jumplist.query { direction = "backward" },
    }
  end)

  require("portal").setup {
    portal = {
      -- title = {
      --   --- When a portal is empty, render an default portal title
      --   render_empty = true,

      --   --- The raw window options used for the portal title window
      --   options = {
      --     relative = "cursor",
      --     width = 80,
      --     height = 1,
      --     col = 2,
      --     style = "minimal",
      --     focusable = false,
      --     border = "single",
      --     noautocmd = true,
      --     zindex = 98,
      --   },
      -- },

      -- body = {
      --   -- When a portal is empty, render an empty buffer body
      --   render_empty = true,

      --   --- The raw window options used for the portal body window
      --   options = {
      --     relative = "cursor",
      --     width = 80,
      --     height = 6,
      --     col = 2,
      --     focusable = false,
      --     border = "single",
      --     noautocmd = true,
      --     zindex = 99,
      --   },
      -- },
    },
    -- query = { "harpoon", "modified", "different", "valid" },
  }
end

return M
