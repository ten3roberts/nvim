return {
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        loadOutDirsFromCheck = true,
        features = "all",
      },
      references = {
        excludeImports = true,
      },
      procMacro = {
        enable = true,
      },
      check = {
        -- command = "clippy",
      },
      workspace = {
        symbol = {
          search_kind = "all_symbols",
        },
      },
    },
  },
}
