return {
  "folke/neoconf.nvim",
  dependencies = { "neovim/nvim-lspconfig" },
  config = function()
    require("neoconf").setup {
      -- override any of the default settings here
    }
  end,
}
