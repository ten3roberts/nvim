return {
  "lukas-reineke/lsp-format.nvim",
  config = function()
    require("lsp-format").setup {
      lua = { exclude = { "lua_ls" } },
      typescript = { exclude = { "tsserver" } },
    }
  end,
}
