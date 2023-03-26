local diagnostic = vim.diagnostic

local border = "single"

local function on_attach(client, bufnr)
  local opts = client.config

  local keymap = {}
  if type(opts.keymap) == "function" then
    keymap = opts.keymap()
  elseif type(opts.keymap) == "table" then
    keymap = opts.keymap
  end

  -- Lsp signature
  if client.name == "lua_ls" then
    client.server_capabilities.documentFormattingProvider = false -- 0.8 and later
  end

  local function buf_map(mod, lhs, rhs)
    vim.keymap.set(mod, lhs, rhs, { silent = true, buffer = bufnr })
  end

  -- local lsp_signature = require "lsp_signature"
  -- lsp_signature.on_attach {
  --   bind = true,
  --   max_height = 5,
  --   max_width = 20,
  --   hint_enable = false,
  --   -- hint_scheme = "String",
  --   zindex = 1,
  --   handler_opts = {
  --     border = border, -- double, single, shadow, none
  --   },
  -- }

  -- local aerial = require "aerial"
  -- aerial.on_attach(client)

  -- Setup mappings

  -- Jump forwards/backwards at the same tree level with '[[' and ']]'

  local builtin = require "telescope.builtin"

  buf_map("n", "<leader>ce", vim.diagnostic.open_float)
  buf_map("n", "<leader>cwa", vim.lsp.buf.add_workspace_folder)
  buf_map("n", "<leader>cwl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end)
  buf_map("n", "<leader>cwr", vim.lsp.buf.remove_workspace_folder)
  buf_map("n", "<leader>Q", require("config.lsp").set_qf)
  buf_map("n", "<leader>q", function()
    require("config.lsp").set_loc()
  end)
  buf_map("n", "<leader>rn", vim.lsp.buf.rename)
  buf_map({ "n", "x" }, "<leader>a", keymap.code_action or vim.lsp.buf.code_action)

  buf_map("", "K", keymap.hover or vim.lsp.buf.hover)

  -- buf_map('', '[d', vim.lsp.diagnostic.goto_prev)
  -- buf_map('', ']d', vim.lsp.diagnostic.goto_next)
  buf_map("n", "go", builtin.lsp_outgoing_calls)
  buf_map("n", "gi", builtin.lsp_incoming_calls)
  buf_map("n", "gD", vim.lsp.buf.declaration)
  buf_map("n", "gd", builtin.lsp_definitions)
  buf_map("n", "gI", builtin.lsp_implementations)
  buf_map("n", "gr", builtin.lsp_references)
  buf_map("n", "gy", builtin.lsp_type_definitions)
end

local function ensure_uri_scheme(uri)
  if not vim.startswith(uri, "file://") then
    return "file://" .. uri
  end
  return uri
end

local function is_local(uri)
  uri = ensure_uri_scheme(uri)
  local path = vim.uri_to_fname(uri)
  local workspace_dir = vim.fn.getcwd()
  vim.notify(vim.inspect { path = path, cur_dir = workspace_dir })

  return vim.startswith(path, workspace_dir)
end

local function rust_analyzer_root_dir(fname)
  local util = require "lspconfig.util"
  local startpath_uri = vim.uri_from_fname(fname)
  vim.notify(string.format("Root dir %q uri: %q", fname, startpath_uri))

  if not is_local(fname) then
    vim.notify(string.format("%q is not in the workspace", fname), vim.log.levels.ERROR)
    return nil
  end

  vim.notify "Directory is local"
  local cargo_crate_dir = util.root_pattern "Cargo.toml"(fname)
  local cmd = { "cargo", "metadata", "--no-deps", "--format-version", "1" }
  if cargo_crate_dir ~= nil then
    cmd[#cmd + 1] = "--manifest-path"
    cmd[#cmd + 1] = util.path.join(cargo_crate_dir, "Cargo.toml")
  end
  local cargo_metadata = ""
  local cargo_metadata_err = ""
  local cm = vim.fn.jobstart(cmd, {
    on_stdout = function(_, d, _)
      cargo_metadata = table.concat(d, "\n")
    end,
    on_stderr = function(_, d, _)
      cargo_metadata_err = table.concat(d, "\n")
    end,
    stdout_buffered = true,
    stderr_buffered = true,
  })
  if cm > 0 then
    cm = vim.fn.jobwait({ cm })[1]
  else
    cm = -1
  end
  local cargo_workspace_dir = nil
  if cm == 0 then
    cargo_workspace_dir = vim.json.decode(cargo_metadata)["workspace_root"]
    if cargo_workspace_dir ~= nil then
      cargo_workspace_dir = util.path.sanitize(cargo_workspace_dir)
    end
  else
    vim.notify(
      string.format("[lspconfig] cmd (%q) failed:\n%s", table.concat(cmd, " "), cargo_metadata_err),
      vim.log.levels.WARN
    )
  end
  return cargo_workspace_dir
    or cargo_crate_dir
    or util.root_pattern "rust-project.json"(fname)
    or util.find_git_ancestor(fname)
end

return {
  {
    enabled = false,
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup {

        text = {
          spinner = "dots",
        },
      }
    end,
  },
  {

    "neovim/nvim-lspconfig",
    dependencies = {
      -- "mfussenegger/nvim-dap",
      "tjdevries/nlua.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "simrat39/rust-tools.nvim",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "jose-elias-alvarez/null-ls.nvim",
    },
    config = function()
      require("lspkind").init {}

      local handlers = {
        ["textDocument/publishDiagnostics"] = require("config.lsp").on_publish_diagnostics,
        -- ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
        ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
      }

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      diagnostic.config {
        -- Only show virtual text if window is large enough
        -- virtual_text = function()
        --   return winwidth(0) >= 80
        -- end,
        virtual_text = {
          spacing = 16,
          prefix = "~",
        },
        -- update_in_insert = true,
        severity_sort = true,
      }

      local default_conf = {
        on_attach = on_attach,
        capabilities = capabilities,
        handlers = handlers,
        keymap = {},
      }

      local lspconfig = require "lspconfig"
      require("mason-lspconfig").setup_handlers {
        -- The first entry (without a key) will be the default handler
        -- and will be called for each installed server that doesn't have
        -- a dedicated handler.
        function(server_name) -- default handler (optional)
          lspconfig[server_name].setup(default_conf)
        end,
        taplo = function()
          lspconfig.taplo.setup(vim.tbl_deep_extend("force", default_conf, {
            keymap = function()
              return { hover = require("crates").show_crate_popup }
            end,
          }))
        end,
        lua_ls = function()
          lspconfig.lua_ls.setup(vim.tbl_deep_extend("force", default_conf, require "config.lua-lsp"))
        end,
        -- Next, you can provide targeted overrides for specific servers.
        -- For example, a handler override for the `rust_analyzer`:
        ["rust_analyzer"] = function()
          local conf = vim.tbl_deep_extend("force", default_conf, {
            keymap = function()
              local rt = require "rust-tools"
              return { hover = rt.hover_actions.hover_actions }
            end,
            standalone = false,

            root_dir = rust_analyzer_root_dir,
            --   local startpath_uri = vim.uri_from_fname(startpath)
            --   if not is_in_workspace(startpath) then
            --     vim.notify(string.format("%q is not in the workspace", startpath))
            --     return nil
            --   end

            --   local root = lspconfig.util.root_pattern("Cargo.toml", "rust-project.json")(startpath)
            --   vim.notify("Adding workspace roots: " .. vim.inspect(root))
            --   return root
            -- end,
            settings = {
              ["rust-analyzer"] = {
                cargo = {
                  loadOutDirsFromCheck = true,
                  buildScripts = {
                    enable = false,
                  },
                  -- features = "all",
                },
                references = {
                  excludeImports = true,
                },
                -- procMacro = {
                --   enable = true,
                -- },
                check = {
                  command = "clippy",
                },
                -- diagnostics = {
                -- enable = true,
                -- --   disabled = { "unresolved-proc-macro" },
                -- enableExperimental = true,
                -- },
                -- cargo = {
                --   loadOutDirsFromCheck = true,
                --   buildScripts = {
                --     enable = false,
                --   },
                -- },
                -- procMacro = {
                --   enable = false,
                -- },
                workspace = {
                  symbol = {
                    search_kind = "all_symbols",
                  },
                },
              },
            },
          })

          require("rust-tools").setup {
            tools = { -- rust-tools options
              inlay_hints = {
                auto = true,
                only_current_line = true,
                -- prefix for parameter hints
                parameter_hints_prefix = "  • ",

                -- prefix for all the other hints (type, chaining)
                other_hints_prefix = "  => ",

                -- whether to align to the length of the longest line in the file
                max_len_align = false,

                -- padding from the left if max_len_align is true
                max_len_align_padding = 4,

                -- padding from the left if max_len_align is true
                -- whether to align to the extreme right or not
                right_align = false,

                -- padding from the right if right_align is true
                right_align_padding = 8,

                -- The color of the hints
                highlight = "InlayHint",
              },
              hover_actions = {
                border = "single",
              },
            },
            dap = {
              adapter = require("config.codelldb").get_codelldb(),
            },

            -- all the opts to send to nvim-lspconfig
            -- these override the defaults set by rust-tools.nvim
            -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
            server = conf,
          }
        end,
      }
    end,
  },
  {

    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      local null_ls = require "null-ls"
      null_ls.setup {
        sources = {
          -- shell
          -- null_ls.builtins.diagnostics.shellcheck,
          -- null_ls.builtins.formatting.shfmt.with {
          --   extra_args = { "-i", "2", "-ci" },
          -- },
          -- md
          -- null_ls.builtins.diagnostics.markdownlint,
          -- null_ls.builtins.completion.spell,

          -- null_ls.builtins.diagnostics.alex,
          -- null_ls.builtins.diagnostics.jsonlint,
          -- null_ls.builtins.diagnostics.yamllint,
          -- null_ls.builtins.diagnostics.selene,
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.prettier,
        },
      }
    end,
  },
}
