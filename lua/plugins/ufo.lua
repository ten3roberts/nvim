return {
  "kevinhwang91/nvim-ufo",
  dependencies = "kevinhwang91/promise-async",
   config = function()
     vim.o.foldcolumn = "1" -- '0' is not bad
     vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
     vim.o.foldlevelstart = 99
     vim.o.foldenable = true
     vim.o.foldmethod = "expr"
     vim.o.foldexpr = "nvim_treesitter#foldexpr()"
     vim.o.foldminlines = 6
     vim.o.foldnestmax = 6

    local ufo = require "ufo"
    ufo.setup {
      provider_selector = function(_, _, _)
        return { "treesitter", "indent" }
      end,
    }

    vim.keymap.set("n", "zR", ufo.openAllFolds)
    vim.keymap.set("n", "zM", ufo.closeAllFolds)
  end,
}
