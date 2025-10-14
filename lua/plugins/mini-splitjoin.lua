return {
  "echasnovski/mini.nvim",
  config = function()
    require("mini.splitjoin").setup {
      -- Split/join mappings
      mappings = {
        toggle = "gS",
      },
    }
  end,
}