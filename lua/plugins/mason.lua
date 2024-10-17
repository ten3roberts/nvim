return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    require("mason").setup()
    require("mason-lspconfig").setup {
      automatic_installation = false,
      ensure_installed = {

        -- "prettier",
        -- "stylua",
        "rust_analyzer",
        "lua_ls",

        "svelte",

        "jsonls",
      },
    }
  end,
}
