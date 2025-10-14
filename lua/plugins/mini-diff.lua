return {
  "echasnovski/mini.nvim",
  config = function()
    require("mini.diff").setup {
      -- Minimal config for thin getters
      view = {
        style = "sign",
        signs = { add = "▏", change = "▔", delete = "▁" },
      },
      mappings = {
        apply = "gh",
        reset = "gH",
        textobject = "gh",
        goto_first = "[H",
        goto_prev = "[h",
        goto_next = "]h",
        goto_last = "]H",
      },
      options = {
        algorithm = "histogram",
        indent_heuristic = true,
        linematch = 60,
        wrap = true,
      },
    }
  end,
}
