
return {
  {
    "rebelot/heirline.nvim",
    enabled = vim.g.statusline_provider == "heirline",
    config = function()
      require("config.heirline").setup()
    end,
  },
}
