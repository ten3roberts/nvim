return {
  settings = {
    typescript = {
      inlayHints = {
        parameterNames = { enabled = "literals" },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = false },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
      },
      preferences = {
        importModuleSpecifier = "non-relative",
        quoteStyle = "double",
      },
      suggest = {
        completeFunctionCalls = true,
      },
      updateImportsOnFileMove = {
        enabled = "always",
      },
    },
    javascript = {
      inlayHints = {
        parameterNames = { enabled = "literals" },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = false },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
      },
      preferences = {
        importModuleSpecifier = "non-relative",
        quoteStyle = "double",
      },
      suggest = {
        completeFunctionCalls = true,
      },
      updateImportsOnFileMove = {
        enabled = "always",
      },
    },
    vtsls = {
      autoUseWorkspaceTsdk = true,
      experimental = {
        completion = {
          enableServerSideFuzzyMatch = true,
        },
      },
    },
  },
  -- Vite-specific settings
  root_dir = function(fname)
    local lspconfig = require "lspconfig"
    return lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git")(fname)
  end,
}
