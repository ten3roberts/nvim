return {

  {
    enabled = false,
    "ggandor/leap.nvim",
    config = function()
      require("leap").set_default_keymaps()
    end,
  },
  {
    enabled = false,
    "ggandor/leap-spooky.nvim",
    dependencies = { "ggandor/leap.nvim" },
    config = function()
      require("leap-spooky").setup {}
    end,
  },
  {
    enabled = false,
    "ggandor/flit.nvim",
    dependencies = { "ggandor/leap.nvim" },
    config = function()
      require("flit").setup {}
    end,
  },
}
