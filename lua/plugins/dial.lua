return {
  "monaqa/dial.nvim",
  keys = {
    {
      "<C-a>",
      mode = "n",
    },
    {
      "<C-x>",
      mode = "n",
    },
    {
      "g<C-a>",
      mode = "n",
    },
    {
      "g<C-x>",
      mode = "n",
    },
    {
      "<C-a>",
      mode = "v",
    },
    {
      "<C-x>",
      mode = "v",
    },
    {
      "g<C-a>",
      mode = "v",
    },
    {
      "g<C-x>",
      mode = "v",
    },
  },
  config = function()
    local augend = require "dial.augend"
    require("dial.config").augends:register_group {
      default = {
        augend.decimal_fraction.new {
          signed = true,
          point_char = ".",
        },
        augend.integer.alias.decimal_int, -- nonnegative decimal number (0, 1, 2, 3, ...)
        augend.constant.alias.bool,
        augend.integer.alias.hex, -- nonnegative hex number  (0x01, 0x1a1f, etc.)
        augend.semver.alias.semver, -- nonnegative hex number  (0x01, 0x1a1f, etc.)
        augend.date.alias["%Y/%m/%d"], -- date (2022/02/19, etc.)
        augend.date.alias["%Y-%m-%d"], -- date (2022-02-19, etc.)
      },
    }

    vim.keymap.set("n", "<C-a>", require("dial.map").inc_normal(), { noremap = true })
    vim.keymap.set("n", "<C-x>", require("dial.map").dec_normal(), { noremap = true })
    vim.keymap.set("n", "g<C-a>", require("dial.map").inc_gnormal(), { noremap = true })
    vim.keymap.set("n", "g<C-x>", require("dial.map").dec_gnormal(), { noremap = true })
    vim.keymap.set("v", "<C-a>", require("dial.map").inc_visual(), { noremap = true })
    vim.keymap.set("v", "<C-x>", require("dial.map").dec_visual(), { noremap = true })
    vim.keymap.set("v", "g<C-a>", require("dial.map").inc_gvisual(), { noremap = true })
    vim.keymap.set("v", "g<C-x>", require("dial.map").dec_gvisual(), { noremap = true })
  end,
}