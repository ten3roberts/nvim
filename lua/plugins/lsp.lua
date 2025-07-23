local diagnostic = vim.diagnostic

local border = "single"

local function on_attach(client, bufnr)
  local opts = client.config

  require("lsp-format").on_attach(client)

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
    enabled = false,
    "j-hui/fidget.nvim",
    opts = {},
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

          local builtin = require "telescope.builtin"

          buf_map("n", "<leader>ce", vim.diagnostic.open_float, "Diagnostic Float")
          buf_map("n", "<leader>cwa", vim.lsp.buf.add_workspace_folder, "Add Workspace Folder")
          buf_map("n", "<leader>cwl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()), "Workspace Folders")
          end)
          buf_map("n", "<leader>cwr", vim.lsp.buf.remove_workspace_folder, "Remove Workspace Folder")
          buf_map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
          buf_map({ "n", "x" }, "<leader>a", vim.lsp.buf.code_action, "Code Action")

          buf_map("", "K", keymap.hover or vim.lsp.buf.hover, "Hover")

          buf_map("n", "go", builtin.lsp_outgoing_calls, "Outgoing Calls")
          buf_map("n", "gi", builtin.lsp_incoming_calls, "Incoming Calls")
          buf_map("n", "gD", vim.lsp.buf.declaration, "Declaration")
          buf_map("n", "gd", builtin.lsp_definitions, "Definitions")
          buf_map("n", "gI", builtin.lsp_implementations, "Implementations")
          buf_map("n", "gr", builtin.lsp_references, "References")
          buf_map("n", "gy", builtin.lsp_type_definitions, "Type Definitions")

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            buf_map("n", "<C-t>", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, "Inlay Hints")
          end
        end,
      })

      local capabilities = require("blink.cmp").get_lsp_capabilities {}

      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      local palette = require "config.palette"
      diagnostic.config {
        update_in_insert = true,
        severity_sort = true,

        -- float = { border = "rounded", source = "if_many" },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = palette.signs.E.sign,
            [vim.diagnostic.severity.WARN] = palette.signs.W.sign,
            [vim.diagnostic.severity.INFO] = palette.signs.I.sign,
            [vim.diagnostic.severity.HINT] = palette.signs.H.sign,
          },
        },
        virtual_text = {
          -- source = 'if_many',
          spacing = 4,
          -- format = function(diagnostic)
          --   local diagnostic_message = {
          --     [vim.diagnostic.severity.ERROR] = diagnostic.message,
          --     [vim.diagnostic.severity.WARN] = diagnostic.message,
          --     [vim.diagnostic.severity.INFO] = diagnostic.message,
          --     [vim.diagnostic.severity.HINT] = diagnostic.message,
          --   }
          --   return diagnostic_message[diagnostic.severity]
          -- end,
        },
      }

      -- require "lspconfig"

      local ensure_installed = {}

      vim.list_extend(ensure_installed, {
        "stylua", -- Used to format Lua code
        "prettier",
      })

      require("mason-tool-installer").setup { ensure_installed = ensure_installed }

      require("mason").setup()
      require("mason-lspconfig").setup {
        -- Populated by tool installer
        ensure_installed = {},
        automatic_enable = true,
      }
    end,
  },
}
