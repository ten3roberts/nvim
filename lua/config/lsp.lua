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
    -- Function = "ﬦ",
  },
}

local M = { buffers = {}, statusline_cache = {} }

-- Sets the location list with predefined options. Does not focus list.
function M.set_loc()
  local bufnr = vim.api.nvim_get_current_buf()
  if vim.o.buftype ~= "" or M.buffers[bufnr] == nil then
    return
  end

  diagnostic.setloclist {
    open = false,
  }
  -- qf.tally "l"
end

function M.set_qf()
  if vim.o.buftype ~= "" then
    return
  end

  diagnostic.setqflist {
    open = false,
    severity = { min = diagnostic.severity.WARN },
  }

  qf.tally "c"
  qf.open("c", false, true)
end

local border = "single"

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
      border = border, -- double, single, shadow, none
    },
  }

  aerial.on_attach(client)

  -- Setup mappings

  -- Jump forwards/backwards at the same tree level with '[[' and ']]'
  -- buf_map(0, "n", "[[", "<cmd>AerialPrevUp<CR>")
  -- buf_map(0, "n", "]]", "<cmd>AerialNextUp<CR>")

  local builtin = require "telescope.builtin"
  local ft = vim.o.ft

  buf_map(0, "", "<leader>ce", vim.diagnostic.open_float)
  buf_map(0, "", "<leader>cwa", vim.lsp.buf.add_workspace_folder)
  buf_map(0, "", "<leader>cwl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end)
  buf_map(0, "", "<leader>cwr", vim.lsp.buf.remove_workspace_folder)
  buf_map(0, "", "<leader>q", require("config.lsp").set_qf)
  buf_map(0, "", "<leader>rn", vim.lsp.buf.rename)
  buf_map(0, "n", "<leader>a", vim.lsp.buf.code_action)
  buf_map(0, "x", "<leader>a", vim.lsp.buf.range_code_action)

  if ft ~= "toml" then
    buf_map(0, "", "K", vim.lsp.buf.hover)
  end

  -- buf_map(0, '', '[d', vim.lsp.diagnostic.goto_prev)
  -- buf_map(0, '', ']d', vim.lsp.diagnostic.goto_next)
  buf_map(0, "n", "go", builtin.lsp_outgoing_calls)
  buf_map(0, "n", "gi", builtin.lsp_incoming_calls)
  buf_map(0, "", "gD", vim.lsp.buf.declaration)
  buf_map(0, "", "gd", builtin.lsp_definitions)
  buf_map(0, "", "gI", builtin.lsp_implementations)
  buf_map(0, "", "gr", builtin.lsp_references)
  buf_map(0, "", "gy", builtin.lsp_type_definitions)
end

function M.deferred_loc()
  vim.defer_fn(M.set_loc, 100)
end
local signs = require("config.palette").signs

local diagnostic_severities = {
  [sev.ERROR] = signs.E,
  [sev.WARN] = signs.W,
  [sev.INFO] = signs.I,
  [sev.HINT] = signs.H,
}

local old_diagnostics = vim.lsp.handlers["textDocument/publishDiagnostics"]

-- function M.on_publish_diagnostics(err, method, result, client_id, _, _)
function M.on_publish_diagnostics(err, result, ctx, cfg)
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

  M.set_loc()

  old_diagnostics(err, result, ctx, cfg)
end

local handlers = {
  ["textDocument/publishDiagnostics"] = M.on_publish_diagnostics,
  -- ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
  ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
}

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
        t[#t + 1] = string.format("%%#%s#%s %s ", severity.hl, severity.sign, v)
      end
    end
  else
    for i, v in ipairs(diagnostics) do
      if v > 0 then
        local severity = diagnostic_severities[i]
        t[#t + 1] = string.format("%s %s ", severity.sign, v)
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
  automatic_installation = true,
}

local server_conf = {
  on_attach = M.on_attach,
  capabilities = capabilities,
  handlers = handlers,
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        loadOutDirsFromCheck = true,
        features = "all",
      },
      procMacro = {
        enable = true,
      },
      checkOnSave = {
        command = "clippy",
      },
      diagnostics = {
        enable = true,
        --   disabled = { "unresolved-proc-macro" },
        enableExperimental = true,
      },
      -- cargo = {
      --   loadOutDirsFromCheck = true,
      --   buildScripts = {
      --     enable = false,
      --   },
      -- },
      -- procMacro = {
      --   enable = false,
      -- },
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

local function if_found(executable, func)
  if vim.fn.executable(executable) == 1 then
    func()
  end
end

-- lspconfig.sumneko_lua.setup(vim.tbl_extend("error", require "config.lua-lsp", server_conf))
if_found("rustc", function()
  require("config.rust").setup(server_conf)
end)
if_found("go", function()
  lspconfig.gopls.setup(server_conf)
end)
lspconfig.sqlls.setup(server_conf)
if_found("npm", function()
  lspconfig.svelte.setup(server_conf)
end)
if_found("npm", function()
  lspconfig.tailwindcss.setup(server_conf)
end)
lspconfig.clangd.setup(server_conf)
if_found("mono", function()
  lspconfig.omnisharp.setup(server_conf)
end)
lspconfig.cssls.setup(server_conf)
lspconfig.jsonls.setup(server_conf)
lspconfig.taplo.setup(server_conf)
if_found("npm", function()
  lspconfig.tsserver.setup(server_conf)
end)
lspconfig.yamlls.setup(server_conf)
-- lspconfig.wgsl_analyzer.setup(server_conf)

return M
