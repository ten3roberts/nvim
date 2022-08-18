local function buf_map(buf, mod, lhs, rhs)
  vim.keymap.set(mod, lhs, rhs, { silent = true, buffer = buf })
end

local aerial = require "aerial"
local diagnostic = vim.diagnostic
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
  if vim.o.buftype == "quickfix" then
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

local function on_attach(client)
  local opts = client.config

  local keymap = {}
  if type(opts.keymap) == "function" then
    keymap = opts.keymap()
  elseif type(opts.keymap) == "table" then
    keymap = opts.keymap
  end

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

  buf_map(0, "", "<leader>ce", vim.diagnostic.open_float)
  buf_map(0, "", "<leader>cwa", vim.lsp.buf.add_workspace_folder)
  buf_map(0, "", "<leader>cwl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end)
  buf_map(0, "", "<leader>cwr", vim.lsp.buf.remove_workspace_folder)
  buf_map(0, "", "<leader>q", require("config.lsp").set_qf)
  buf_map(0, "", "<leader>rn", vim.lsp.buf.rename)
  buf_map(0, "n", "<leader>a", keymap.code_action or vim.lsp.buf.code_action)
  buf_map(0, "x", "<leader>a", vim.lsp.buf.range_code_action)

  buf_map(0, "", "K", keymap.hover or vim.lsp.buf.hover)

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

local default_conf = {
  on_attach = on_attach,
  capabilities = capabilities,
  handlers = handlers,
  keymap = {},
}

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
  sumneko_lua = function()
    lspconfig.sumneko_lua.setup(vim.tbl_deep_extend("force", default_conf, require "config.lua-lsp"))
  end,
  -- Next, you can provide targeted overrides for specific servers.
  -- For example, a handler override for the `rust_analyzer`:
  ["rust_analyzer"] = function()
    local conf = vim.tbl_deep_extend("force", default_conf, {
      keymap = function()
        local rt = require "rust-tools"
        return { hover = rt.hover_actions.hover_actions }
      end,
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
    })

    require("rust-tools").setup {
      tools = { -- rust-tools options
        inlay_hints = {
          auto = true,
          -- prefix for parameter hints
          parameter_hints_prefix = "<- ",

          -- prefix for all the other hints (type, chaining)
          other_hints_prefix = "=> ",

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
        adapter = require("recipe.debug_adapters").codelldb,
      },

      -- all the opts to send to nvim-lspconfig
      -- these override the defaults set by rust-tools.nvim
      -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
      server = conf,
    }
  end,
}

-- local server_conf = {
--   on_attach = M.on_attach,
--   capabilities = capabilities,
--   handlers = handlers,
--   keymap = {},
-- }

-- local ok, lua_server = installer.get_server "sumneko_lua"
-- if ok and lua_server:is_installed() then
--   local c = lua_server:get_default_options()
--   c.cmd = {
--     vim.fn.stdpath "data" .. "/lsp_servers/sumneko_lua/extension/server/bin/lua-language-server",
--     "-E",
--     vim.fn.stdpath "data" .. "/lsp_servers/sumneko_lua/extension/server/main.lua",
--   }
--   require("nlua.lsp.nvim").setup(lspconfig, vim.tbl_deep_extend("keep", server_conf, c))
-- end

-- local function if_found(executable, func)
--   if vim.fn.executable(executable) == 1 then
--     func()
--   end
-- end

-- -- lspconfig.sumneko_lua.setup(vim.tbl_extend("error", require "config.lua-lsp", server_conf))
-- if_found("rustc", function()
--   local rt = require "rust-tools"
--   require("config.rust").setup(vim.tbl_deep_extend("force", server_conf, {
--     keymap = function()
--       return { hover = rt.hover_actions.hover_actions }
--     end,
--   }))
-- end)
-- if_found("go", function()
--   lspconfig.gopls.setup(server_conf)
-- end)
-- lspconfig.sqlls.setup(server_conf)
-- if_found("npm", function()
--   lspconfig.svelte.setup(server_conf)
-- end)
-- if_found("npm", function()
--   lspconfig.tailwindcss.setup(server_conf)
-- end)
-- lspconfig.clangd.setup(server_conf)
-- if_found("mono", function()
--   lspconfig.omnisharp.setup(server_conf)
-- end)
-- lspconfig.cssls.setup(server_conf)
-- lspconfig.jsonls.setup(server_conf)

-- lspconfig.taplo.setup(vim.tbl_deep_extend("force", server_conf, {
--   keymap = function()
--     return { hover = require("crates").show_crate_popup }
--   end,
-- }))

-- if_found("npm", function()
--   lspconfig.tsserver.setup(server_conf)
-- end)
-- lspconfig.yamlls.setup(server_conf)
-- -- lspconfig.wgsl_analyzer.setup(server_conf)

return M
