require'nvim-treesitter.configs'.setup {
  ensure_installed = "all",
  autopairs = { enable = true },
  playground = { enable = true },
  matchup = { enable = true },
  highlight = {
    enable = true,
    disable = { "latex" }
  },
  indent = { enable = true, },
}
