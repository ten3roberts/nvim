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
      inlayHints = {
        enable = true,
        showParameterNames = true,
        parameterHintsPrefix = "<- ",
        otherHintsPrefix = "=> ",
      },
      diagnostics = {
        enable = true,
        experimental = {
          enable = true,
        },
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
