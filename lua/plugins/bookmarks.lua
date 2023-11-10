return {
  "ten3roberts/bookmarks.nvim",
  enabled = true,
  event = "VeryLazy",
  config = function()
    require("bookmarks").setup {
      scoped = true,
      keywords = {
        ["@t"] = "󰀚", -- mark annotation startswith @t ,signs this icon as `Todo`
        ["@f"] = "󰖷", -- mark annotation startswith @f ,signs this icon as `Fix`
        ["@n"] = "󰏫", -- mark annotation startswith @n ,signs this icon as `Note`
      },
      signs = {
        add = { text = "󰃃" },
        ann = { text = "󰃀" },
      },
      sign_priority = 10,
      on_attach = function(bufnr)
        local bm = require "bookmarks"
        local map = vim.keymap.set
        map("n", "mm", bm.bookmark_toggle) -- add or remove bookmark at current line
        map("n", "mi", bm.bookmark_ann) -- add or edit mark annotation at current line
        map("n", "mc", bm.bookmark_clean) -- clean all marks in local buffer
        map("n", "mn", bm.bookmark_next) -- jump to next mark in local buffer
        map("n", "mp", bm.bookmark_prev) -- jump to previous mark in local buffer
        map("n", "mq", bm.bookmark_list) -- show marked file list in quickfix window
        map("n", "<leader>m", function()
          require("telescope").extensions.bookmarks.list {}
        end)
        map("n", "mm", function()
          require("telescope").extensions.bookmarks.list {}
        end)
      end,
    }
    require("telescope").load_extension "bookmarks"
  end,
}
