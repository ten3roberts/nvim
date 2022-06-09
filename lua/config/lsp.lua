local function buf_map(buf, mod, lhs, rhs)
  vim.keymap.set(mod, lhs, rhs, { silent = true, buffer = buf })
end

local aerial = require "aerial"
local diagnostic = vim.diagnostic
local lsp_diagnostic = vim.lsp.diagnostic
local lspconfig = require "lspconfig"
local lsp_signature = require "lsp_signature"
local qf = require "qf"
local sev = diagnostic.severity

require("lspkind").init {
  symbol_map = {
    Function = "ﬦ",
  },
}

local M = { buffers = {}, statusline_cache = {} }

local cmd = {
  fzf = {
    references = ":References<CR>",
    type_definitions = ":TypeDefinitions<CR>",
    definitions = ":Definitions<CR>",
    declarations = ":Declarations<CR>",
    code_actions = ":CodeActions<CR>",
  },
  telescope = {
    references = ":Telescope lsp_references<CR>",
    type_definitions = ":Telescope lsp_type_definitions<CR>",
    definitions = ":Telescope lsp_definitions<CR>",
    declarations = ":Telescope lsp_declarations<CR>",
    code_actions = ":Telescope lsp_code_actions<CR>",
  },
}

local provider = "telescope"

-- Sets the location list with predefined options. Does not focus list.
function M.set_loc()
  local bufnr = vim.api.nvim_get_current_buf()
  if vim.o.buftype ~= "" or M.buffers[bufnr] == nil then
    return
  end

  diagnostic.setloclist {
    open = false,
  }
  qf.tally "l"
end

function M.set_qf()
  if vim.o.buftype ~= "" then
    return
  end

  diagnostic.setqflist {
    open = false,
    severity_sort = true,
  }

  qf.tally "c"
  qf.open("c", false, true)
end

function M.on_attach(client)
  -- Lsp signature
  if client.name == "sumneko_lua" then
    client.server_capabilities.documentFormattingProvider = false -- 0.8 and later
  end

  lsp_signature.on_attach {
    bind = true,
    max_height = 5,
    max_width = 20,
    hint_enable = false,
    -- hint_scheme = "String",
    zindex = 1,
    handler_opts = {
      border = "single", -- double, single, shadow, none
    },
  }

  aerial.on_attach(client)

  -- Setup mappings

  -- Jump forwards/backwards at the same tree level with '[[' and ']]'
  buf_map(0, "n", "[[", "<cmd>AerialPrevUp<CR>")
  buf_map(0, "n", "]]", "<cmd>AerialNextUp<CR>")

  local provider_cmds = cmd[provider]

  local builtin = require "telescope.builtin"

  buf_map(0, "", "<leader>cf", vim.lsp.buf.formatting)
  buf_map(0, "", "<leader>ce", vim.diagnostic.open_float)
  buf_map(0, "", "<leader>cwa", vim.lsp.buf.add_workspace_folder)
  buf_map(0, "", "<leader>cwl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end)
  buf_map(0, "", "<leader>cwr", vim.lsp.buf.remove_workspace_folder)
  buf_map(0, "", "<leader>q", require("config.lsp").set_qf)
  buf_map(0, "", "<leader>rn", vim.lsp.buf.rename)
  buf_map(0, "", "<leader>a", vim.lsp.buf.code_action)
  buf_map(0, "", "K", vim.lsp.buf.hover)
  -- buf_map(0, '', '[d', vim.lsp.diagnostic.goto_prev)
  -- buf_map(0, '', ']d', vim.lsp.diagnostic.goto_next)
  buf_map(0, "", "gD", vim.lsp.buf.declaration)
  buf_map(0, "", "gd", builtin.lsp_definitions)
  buf_map(0, "", "gi", builtin.lsp_implementations)
  buf_map(0, "", "gr", builtin.lsp_references)
  buf_map(0, "", "gy", builtin.lsp_type_definitions)
end

function M.deferred_loc()
  vim.defer_fn(M.set_loc, 100)
end

local diagnostic_severities = {
  [sev.ERROR] = { hl = "%#STError#", type = "E", kind = "error", sign = "" },
  [sev.WARN] = { hl = "%#STWarning#", type = "W", kind = "warning", sign = "" },
  [sev.INFO] = { hl = "%#STInfo#", type = "I", kind = "info", sign = "" },
  [sev.HINT] = { hl = "%#STHint#", type = "H", kind = "hint", sign = "" },
}

-- function M.on_publish_diagnostics(err, method, result, client_id, _, _)
function M.on_publish_diagnostics(_, result, ctx, cfg)
  local uri = result.uri
  local bufnr = vim.uri_to_bufnr(uri)

  if not bufnr then
    return
  end

  -- Reset cache for current buffer
  M.clear_buffer_cache(bufnr)

  -- Tally up diagnostics
  local diagnostic_count = {
    [sev.ERROR] = 0,
    [sev.WARN] = 0,
    [sev.INFO] = 0,
    [sev.HINT] = 0,
  }

  for _, v in ipairs(result.diagnostics) do
    local severity = v.severity

    diagnostic_count[severity] = diagnostic_count[severity] + 1
  end

  M.buffers[bufnr] = diagnostic_count

  lsp_diagnostic.on_publish_diagnostics(_, result, ctx, cfg)

  -- if vim.api.nvim_get_mode().mode == 'n' then
  M.set_loc()
  -- end
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = M.on_publish_diagnostics

function M.clear_buffer_cache(bufnr)
  M.buffers[bufnr] = nil
  M.statusline_cache[bufnr] = nil
end

-- Returns a formatted statusline
function M.statusline(bufnr, highlight)
  bufnr = bufnr or vim.fn.bufnr "%"

  local cache = M.statusline_cache[bufnr]

  if cache then
    return cache
  end

  local diagnostics = M.buffers[bufnr]

  if diagnostics == nil then
    return ""
  end

  local t = {}

  if highlight then
    for i, v in ipairs(diagnostics) do
      if v > 0 then
        local severity = diagnostic_severities[i]
        t[#t + 1] = severity.hl .. severity.sign .. " " .. v .. " "
      end
    end
  else
    for i, v in ipairs(diagnostics) do
      if v > 0 then
        local severity = diagnostic_severities[i]
        t[#t + 1] = severity.sign .. " " .. v .. " "
      end
    end
  end

  local s = table.concat(t)
  M.statusline_cache[bufnr] = s
  return s
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

diagnostic.config {
  -- Only show virtual text if window is large enough
  -- virtual_text = function()
  --   return winwidth(0) >= 80
  -- end,
  virtual_text = {
    spacing = 16,
    prefix = "~",
  },
  update_in_insert = true,
  severity_sort = true,
}

local installer = require "nvim-lsp-installer"

installer.setup {
  automatic_installation = false,
}

local server_conf = {
  on_attach = M.on_attach,
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      diagnostics = {
        enable = true,
        disabled = { "unresolved-proc-macro" },
        enableExperimental = true,
      },
      cargo = {
        loadOutDirsFromCheck = true,
        buildScripts = {
          enable = true,
        },
      },
      procMacro = {
        enable = true,
      },
    },
  },
}

local ok, lua_server = installer.get_server "sumneko_lua"
if ok and lua_server:is_installed() then
  local c = lua_server:get_default_options()
  c.cmd = {
    vim.fn.stdpath "data" .. "/lsp_servers/sumneko_lua/extension/server/bin/lua-language-server",
    "-E",
    vim.fn.stdpath "data" .. "/lsp_servers/sumneko_lua/extension/server/main.lua",
  }
  require("nlua.lsp.nvim").setup(lspconfig, vim.tbl_deep_extend("keep", server_conf, c))
end

-- lspconfig.sumneko_lua.setup(vim.tbl_extend("error", require "config.lua-lsp", server_conf))
require("config.rust").setup(server_conf)
lspconfig.gopls.setup(server_conf)
lspconfig.sqlls.setup(server_conf)
lspconfig.svelte.setup(server_conf)
lspconfig.tailwindcss.setup(server_conf)
lspconfig.clangd.setup(server_conf)
lspconfig.omnisharp.setup(server_conf)
lspconfig.cssls.setup(server_conf)
lspconfig.jsonls.setup(server_conf)
lspconfig.taplo.setup(server_conf)
lspconfig.tsserver.setup(server_conf)
lspconfig.yamlls.setup(server_conf)

return M
