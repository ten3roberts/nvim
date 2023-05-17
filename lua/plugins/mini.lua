return {
  "echasnovski/mini.nvim",
  version = false,
  config = function()
    require("mini.ai").setup {
      custom_textobjects = {
        ["B"] = { { "%b[]", "%b{}" }, "^.().*().$" },
      },
    }
    require("mini.bracketed").setup {}
    require("mini.move").setup {}
  end,
}
