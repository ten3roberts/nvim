local diagnostic = vim.diagnostic

local border = "single"

local function on_attach(client, bufnr)
  local opts = client.config

  -- vim.lsp.inlay_hint.enable()
  local keymap = {}
  if type(opts.keymap) == "function" then
    keymap = opts.keymap()
  elseif type(opts.keymap) == "table" then
    keymap = opts.keymap
  end

  local function buf_map(mod, lhs, rhs)
    vim.keymap.set(mod, lhs, rhs, { silent = true, buffer = bufnr })
  end

  -- local builtin = require "telescope.builtin"

  buf_map("n", "<leader>ce", vim.diagnostic.open_float)
  buf_map("n", "<leader>cwa", vim.lsp.buf.add_workspace_folder)
  buf_map("n", "<leader>cwl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end)
  buf_map("n", "<leader>cwr", vim.lsp.buf.remove_workspace_folder)
  buf_map("n", "<leader>rn", vim.lsp.buf.rename)
  buf_map({ "n", "x" }, "<leader>a", vim.lsp.buf.code_action)

  buf_map("", "K", keymap.hover or vim.lsp.buf.hover)

  -- buf_map('', '[d', vim.lsp.diagnostic.goto_prev)
  -- buf_map('', ']d', vim.lsp.diagnostic.goto_next)
  buf_map("n", "go", function()
    require("snacks").picker.lsp_outgoing_calls()
  end)

  buf_map("n", "gi", function()
    require("snacks").picker.lsp_incoming_calls()
  end)

  buf_map("n", "gD", function()
    require("snacks").picker.lsp_declaration()
  end)

  buf_map("n", "gd", function()
    require("snacks").picker.lsp_definitions()
  end)

  buf_map("n", "gI", function()
    require("snacks").picker.lsp_implementations()
  end)

  buf_map("n", "gr", function()
    require("snacks").picker.lsp_references()
  end)

  buf_map("n", "gy", function()
    require("snacks").picker.lsp_type_definitions()
  end)
end

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

          -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
          ---@param client vim.lsp.Client
          ---@param method vim.lsp.protocol.Method
          ---@param bufnr? integer some lsp support methods only in specific files
          ---@return boolean
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has "nvim-0.11" == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          local function buf_map(mod, lhs, rhs, desc)
            vim.keymap.set(mod, lhs, rhs, { silent = true, buffer = event.buf, desc = desc })
          end

          local opts = client.config

          -- vim.lsp.inlay_hint.enable()

          local keymap = {}
          if type(opts.keymap) == "function" then
            keymap = opts.keymap()
          elseif type(opts.keymap) == "table" then
            keymap = opts.keymap
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
            require("snacks").picker.lsp_outgoing_calls()
          end, "Outgoing Calls")
          buf_map("n", "gi", function()
            require("snacks").picker.lsp_incoming_calls()
          end, "Incoming Calls")

          buf_map("n", "gd", function()
            require("snacks").picker.lsp_definitions()
          end, "Definitions")
          buf_map("n", "gI", function()
            require("snacks").picker.lsp_implementations()
          end, "Implementations")
          buf_map("n", "gr", function()
            require("snacks").picker.lsp_references()
          end, "References")
          buf_map("n", "gy", function()
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

      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      -- Apply language server specific configurations
      vim.lsp.config("rust_analyzer", require("lsp.rust_analyzer"))
      vim.lsp.config("vtsls", require("lsp.vtsls"))
      vim.lsp.config("vue_ls", require("lsp.vue_ls"))

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
        -- Populated by tool installer
        ensure_installed = {
          "vtsls",
          "vue_ls",
        },
        automatic_enable = true,
      }
    end,
  },
}
