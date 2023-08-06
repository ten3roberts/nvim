return {
  "echasnovski/mini.nvim",
  version = false,
  config = function()
    require("mini.ai").setup {
      custom_textobjects = {
        ["B"] = { { "%b[]", "%b{}" }, "^.().*().$" },
      },
    }
    -- require("mini.bracketed").setup {}
    require("mini.move").setup {

      left = "<",
      right = ">",
      down = "<M-j>",
      up = "<M-k>",

      -- Move current line in Normal mode
      line_left = "<",
      line_right = ">",
      line_down = "<M-j>",
      line_up = "<M-k>",
    }
  end,
}
