return {
  settings = {
    vue = {
      inlayHints = {
        inlineHandlerLeading = true,
        missingProps = true,
        optionsWrapper = true,
        vBindShorthand = true,
      },
      server = {
        petiteVue = {
          supportHtmlFile = false,
        },
        vitePress = {
          supportMdFile = false,
        },
      },
    },
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
    },
  },
  filetypes = { "vue" },
  root_dir = function(fname)
    local lspconfig = require "lspconfig"
    return lspconfig.util.root_pattern("package.json", "vue.config.js", "vite.config.ts", "vite.config.js", ".git")(
      fname
    )
  end,
  init_options = {
    typescript = {
      tsdk = "",
    },
  },
  on_new_config = function(new_config, new_root_dir)
    -- Try to find the TypeScript SDK in the project
    local util = require "lspconfig.util"
    local function find_tsdk()
      local paths = {
        util.path.join(new_root_dir, "node_modules", "typescript", "lib"),
        util.path.join(new_root_dir, ".pnpm", "node_modules", "typescript", "lib"),
      }
      for _, path in ipairs(paths) do
        if vim.fn.isdirectory(path) == 1 then
          return path
        end
      end
      return ""
    end
    new_config.init_options.typescript.tsdk = find_tsdk()
  end,
}
