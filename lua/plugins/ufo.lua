return {
  "kevinhwang91/nvim-ufo",
  dependencies = "kevinhwang91/promise-async",
  lazy = false,
  keys = {
    {
      "zR",
      function()
        require("ufo").openAllFolds()
      end,
    },
    {
      "zM",
      function()
        require("ufo").closeAllFolds()
      end,
    },
    {
      "zr",
      function()
        require("ufo").openFoldsExceptKinds()
      end,
    },
    {
      "zm",
      function()
        require("ufo").closeFoldsWith()
      end,
    },
  },
  config = function()
    vim.o.foldcolumn = "0" -- '0' is not bad
    vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    require("ufo").setup {
      -- provider_selector = function(_, _, _)
      --   return { "treesitter", "indent" }
      -- end,
    }
  end,
}
