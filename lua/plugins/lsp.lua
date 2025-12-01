local diagnostic = vim.diagnostic

return {
  {
    "j-hui/fidget.nvim",
    enabled = true,
    opts = {
      progress = {

        display = {
          progress_icon = {
            "dots_pulse",
          },
          done_icon = {
            { "󰄬" },
          },
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "folke/neodev.nvim",
      "folke/neoconf.nvim",
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      require("neoconf").setup {
        -- override any of the default settings here
      }

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)

          local function client_supports_method(client, method, bufnr)
            return client:supports_method(method, bufnr)
          end

          local function buf_map(mod, lhs, rhs, desc)
            vim.keymap.set(mod, lhs, rhs, { silent = true, buffer = event.buf, desc = desc })
          end

          buf_map("n", "<leader>ce", vim.diagnostic.open_float, "Diagnostic Float")
          buf_map("n", "<leader>cwa", vim.lsp.buf.add_workspace_folder, "Add Workspace Folder")
          buf_map("n", "<leader>cwl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()), "Workspace Folders")
          end, "List Workspace Folders")
          buf_map("n", "<leader>cwr", vim.lsp.buf.remove_workspace_folder, "Remove Workspace Folder")
          buf_map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
          buf_map({ "n", "x" }, "<leader>a", vim.lsp.buf.code_action, "Code Action")
          buf_map("n", "go", function()
            vim.g.last_lsp_mode = "lsp"
            require("snacks").picker.lsp_outgoing_calls()
          end, "Outgoing Calls")
          buf_map("n", "gi", function()
            vim.g.last_lsp_mode = "lsp"
            require("snacks").picker.lsp_incoming_calls()
          end, "Incoming Calls")

          buf_map("n", "gd", function()
            vim.g.last_lsp_mode = "lsp"
            require("snacks").picker.lsp_definitions()
          end, "Definitions")
          buf_map("n", "gI", function()
            vim.g.last_lsp_mode = "lsp"
            require("snacks").picker.lsp_implementations()
          end, "Implementations")
          buf_map("n", "gr", function()
            vim.g.last_lsp_mode = "lsp"
            require("snacks").picker.lsp_references()
          end, "References")
          buf_map("n", "gy", function()
            vim.g.last_lsp_mode = "lsp"
            require("snacks").picker.lsp_type_definitions()
          end, "Type Definitions")

          -- Toggle inlay hints
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            buf_map("n", "<leader>li", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, "Toggle Inlay Hints")
          end

          -- Toggle diagnostic virtual text
          buf_map("n", "<leader>ld", function()
            local config = vim.diagnostic.config()
            vim.diagnostic.config { virtual_text = not config.virtual_text }
          end, "Toggle Diagnostic Virtual Text")

          -- Call hierarchy
          buf_map("n", "<leader>ch", function()
            require("snacks").picker.lsp_calls()
          end, "Call Hierarchy")

          -- Hover with actions (enhanced hover)
          buf_map("n", "<leader>ha", vim.lsp.buf.hover, "Hover with Actions")

          -- Next error
          buf_map("n", "<leader>le", function()
            vim.diagnostic.goto_next { severity = vim.diagnostic.severity.ERROR }
          end, "Next Error")

          -- Rust-specific
          if client.name == "rust_analyzer" then
            buf_map("n", "<leader>rt", function()
              require("neotest").run.run()
            end, "Run Tests")
            buf_map("n", "<leader>me", function()
              vim.lsp.buf.code_action { context = { only = { "refactor.rewrite.expandMacro" } } }
            end, "Expand Macro")
          end
        end,
      })

      local capabilities = require("blink.cmp").get_lsp_capabilities {}

      local palette = require "config.palette"
      diagnostic.config {
        update_in_insert = true,
        severity_sort = true,

        -- float = { border = "rounded", source = "if_many" },
        underline = { severity = { min = vim.diagnostic.severity.WARN } },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = palette.signs.E.sign,
            [vim.diagnostic.severity.WARN] = palette.signs.W.sign,
            [vim.diagnostic.severity.INFO] = palette.signs.I.sign,
            [vim.diagnostic.severity.HINT] = palette.signs.H.sign,
          },
        },
        virtual_text = {
          spacing = 4,
        },
      }

      local ensure_installed = {}

      vim.list_extend(ensure_installed, {
        "stylua", -- Used to format Lua code
        "prettier",
      })

      require("mason-tool-installer").setup { ensure_installed = ensure_installed }

      require("mason").setup()
      require("mason-lspconfig").setup {
        ensure_installed = {
          "rust_analyzer",
          "vtsls",
          "vue_ls",
        },
        automatic_enable = true,
      }

      -- Global capabilities for all servers
      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      -- rust-analyzer specific settings
      vim.lsp.config("rust_analyzer", {
        settings = {
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = false,
              loadOutDirsFromCheck = true,
              buildScripts = { enable = true },
              autoreload = true,
            },
            references = {
              excludeImports = true,
            },
            procMacro = {
              enable = true,
              attributes = { enable = true },
            },
            check = {
              command = "check",
              workspace = true,
            },
            diagnostics = {
              enable = true,
              experimental = { enable = false },
              refreshDelay = 300,
            },
            workspace = {
              symbol = { search = { kind = "all_symbols" } },
            },
            cachePriming = {
              enable = true,
              numThreads = "physical",
            },
            lru = { capacity = 256 },
            notifications = { cargoTomlNotFound = false },
          },
        },
      })
    end,
  },
}
