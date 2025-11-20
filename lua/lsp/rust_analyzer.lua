return {
  settings = {
    ["rust-analyzer"] = {
      -- Cargo settings
      cargo = {
        allFeatures = true,
        loadOutDirsFromCheck = true,
        buildScripts = {
          enable = true,
        },
      },

      -- Procedural macro support
      procMacro = {
        enable = true,
        ignored = {
          -- ["async-trait"] = { "async_trait" },
          -- ["napi-derive"] = { "napi" },
          -- ["async-recursion"] = { "async_recursion" },
        },
      },

      -- Check settings
      check = {
        command = "clippy",
        extraArgs = { "--all-targets" },
      },

      -- Diagnostics
      diagnostics = {
        enable = true,
        disabled = {},
        experimental = {
          enable = true,
        },
      },

      -- Inlay hints
      inlayHints = {
        bindingModeHints = {
          enable = false,
        },
        chainingHints = {
          enable = true,
        },
        closingBraceHints = {
          enable = true,
          minLines = 25,
        },
        closureReturnTypeHints = {
          enable = "never",
        },
        lifetimeElisionHints = {
          enable = "never",
          useParameterNames = false,
        },
        maxLength = 25,
        parameterHints = {
          enable = true,
        },
        reborrowHints = {
          enable = "never",
        },
        renderColons = true,
        typeHints = {
          enable = true,
          hideClosureInitialization = false,
          hideNamedConstructor = false,
        },
      },

      -- Lens settings
      lens = {
        enable = true,
        implementations = {
          enable = true,
        },
        references = {
          adt = {
            enable = true,
          },
          enumVariant = {
            enable = true,
          },
          method = {
            enable = true,
          },
          trait = {
            enable = true,
          },
        },
        run = {
          enable = true,
        },
      },

      -- Hover actions
      hover = {
        actions = {
          enable = true,
          references = {
            enable = true,
          },
        },
        documentation = {
          enable = true,
        },
      },

      -- Completion settings
      completion = {
        autoimport = {
          enable = true,
        },
        autoself = {
          enable = true,
        },
        callable = {
          snippets = "fill_arguments",
        },
        postfix = {
          enable = true,
        },
        privateEditable = {
          enable = false,
        },
      },

      -- Workspace symbol settings
      workspace = {
        symbol = {
          search = {
            kind = "all_symbols",
          },
        },
      },

      -- Semantic highlighting
      semanticHighlighting = {
        operator = {
          enable = true,
          specialization = {
            enable = false,
          },
        },
        punctuation = {
          enable = false,
          separate = {
            macro = {
              bang = false,
            },
          },
          specialization = {
            enable = false,
          },
        },
      },

      -- Assist settings
      assist = {
        importGranularity = "module",
        importPrefix = "by_self",
      },

      -- Files to exclude
      files = {
        excludeDirs = { ".direnv", "node_modules" },
      },

      -- Typing settings
      typing = {
        autoClosingAngleBrackets = {
          enable = false,
        },
      },
    },
  },
}
