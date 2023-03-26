return {
  "stevearc/dressing.nvim",
  dependencies = { "telescope.nvim" },
  config = function()
    require("dressing").setup {
      select = {
        telescope = require("telescope.themes").get_dropdown {
          border = false,
        },
      },
    }
  end,
}
