return {
  "Saecki/crates.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  filetype = "toml",
  config = function()
    require("crates").setup {
      max_parallel_requests = 2,
      popup = {
        autofocus = true,
      },
    }
  end,
}