return {
  "dcampos/nvim-snippy",
  dependencies = {
    "honza/vim-snippets",
  },
  config = function()
    local mappings = require "snippy.mapping"

    vim.keymap.set({ "i", "s" }, "<c-k>", mappings.next())
    vim.keymap.set({ "i", "s" }, "<c-j>", mappings.previous())

    -- vim.keymap.set("x", "<Tab>", mappings.cut_text, { remap = true })
    -- vim.keymap.set("n", "g<Tab>", mappings.cut_text, { remap = true })

    require("snippy").setup {}
  end,
}
