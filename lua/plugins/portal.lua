local M = {
  "cbochs/portal.nvim",
  dependencies = {
    "cbochs/grapple.nvim", -- Optional: provides the "grapple" query item
  },
  keys = {
    {
      "<leader>i",
      function()
        require("portal").jump_forward()
      end,
    },
    {

      "<leader>o",
      function()
        require("portal").jump_backward()
      end,
    },
  },
}

function M.config()
  print "Setting up portal"
  require("portal").setup {
    portal = {
      title = {
        --- When a portal is empty, render an default portal title
        render_empty = true,

        --- The raw window options used for the portal title window
        options = {
          relative = "cursor",
          width = 80,
          height = 1,
          col = 2,
          style = "minimal",
          focusable = false,
          border = "single",
          noautocmd = true,
          zindex = 98,
        },
      },

      body = {
        -- When a portal is empty, render an empty buffer body
        render_empty = true,

        --- The raw window options used for the portal body window
        options = {
          relative = "cursor",
          width = 80,
          height = 6,
          col = 2,
          focusable = false,
          border = "single",
          noautocmd = true,
          zindex = 99,
        },
      },
    },
    query = { "grapple", "modified", "different", "valid" },
  }
end

return M
