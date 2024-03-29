return {
  "ten3roberts/recipe.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },

  keys = {
    { "<leader>e", "<cmd>Telescope recipe pick_recipe<CR>" },
    { "<leader>be", "<cmd>Telescope recipe pick_local<CR>" },
    { "`<CR>", "<cmd>RecipeBake! check<CR>" },
    { "`b", "<cmd>RecipeBake! build<CR>" },
    {
      "<leader>ht",
      function()
        require("recipe").execute({ cmd = "zsh", adapter = "term" }):focus {}
      end,
    },
  },
  opts = {
    term = {
      auto_close = true,
      kind = "smart",
    },
    default_components = {
      qf = { open = false },
    },
  },
}
