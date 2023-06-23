return {
  "tomasky/bookmarks.nvim",
  event = "VeryLazy",
  config = function()
    require("bookmarks").setup {
      keywords = {
        type = "table",
        default = { ["@t"] = "󰳤", ["@w"] = "󰈅", ["@f"] = "󰢷", ["@n"] = "󰓹" },
      },
      on_attach = function(bufnr)
        local bm = require "bookmarks"
        local map = vim.keymap.set
        map("n", "mm", bm.bookmark_toggle) -- add or remove bookmark at current line
        map("n", "mi", bm.bookmark_ann) -- add or edit mark annotation at current line
        map("n", "mc", bm.bookmark_clean) -- clean all marks in local buffer
        map("n", "mn", bm.bookmark_next) -- jump to next mark in local buffer
        map("n", "mp", bm.bookmark_prev) -- jump to previous mark in local buffer
        map("n", "mq", bm.bookmark_list) -- show marked file list in quickfix window
        map("n", "ml", function()require("telescope").extensions.bookmarks.list {} end) -- show marked file list in quickfix window
      end,
    }
    require("telescope").load_extension "bookmarks"
  end,
}
