local function buf_map(buf, mod, lhs, rhs, opt)
  vim.api.nvim_buf_set_keymap(buf, mod, lhs, rhs, opt or {})
end

local stdpath = vim.fn.stdpath
local aerial = require'aerial'
local diagnostic = vim.diagnostic
local lsp_diagnostic = vim.lsp.diagnostic
local lsp_signature = require'lsp_signature'
local nvim_lsp = require 'lspconfig'
local sev = diagnostic.severity

local M = { buffers = {}, statusline_cache = {} }

local cmd = {
  fzf = {
    references = ':References<CR>',
    type_definitions = ':TypeDefinitions<CR>',
    definitions = ':Definitions<CR>',
    declarations = ':Declarations<CR>',
    code_actions = ":CodeActions<CR>",
  },
  telescope = {
    references = ':Telescope lsp_references<CR>',
    type_definitions = ':Telescope lsp_type_definitions<CR>',
    definitions = ':Telescope lsp_definitions<CR>',
    declarations = ':Telescope lsp_declarations<CR>',
    code_actions = ':Telescope lsp_code_actions<CR>',
  }
}

local provider = 'telescope'

function M.on_attach(client)
  -- Lsp signature
  lsp_signature.on_attach({
    bind = true,
    max_height = 5,
    max_width = 20,
    hint_enable = false,
    -- hint_scheme = "String",
    zindex = 1,
    handler_opts = {
      border = "single"   -- double, single, shadow, none
    },
  })

  aerial.on_attach(client)

  -- Setup mappings

  local silent = { silent = true }

  -- Jump forwards/backwards with '{' and '}'
  buf_map(0, '', '{',         '<cmd>AerialPrev<CR>')
  buf_map(0, '', '}',         '<cmd>AerialNext<CR>')

  -- Jump forwards/backwards at the same tree level with '[[' and ']]'
  buf_map(0, '', '[[',         '<cmd>AerialPrevUp<CR>')
  buf_map(0, '', ']]',         '<cmd>AerialNextUp<CR>')

  local provider_cmds = cmd[provider]

  buf_map(0, '', '<leader>cf',  '<cmd>lua vim.lsp.buf.formatting()<CR>')
  buf_map(0, '', '<leader>cwa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
  buf_map(0, '', '<leader>cwl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')
  buf_map(0, '', '<leader>cwr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
  buf_map(0, '', '<leader>q',   '<cmd>lua require"config.lsp".set_loc()<CR>')
  buf_map(0, '', '<leader>rn',  '<cmd>lua vim.lsp.buf.rename()<CR>')
  buf_map(0, '', '<leader>a',   provider_cmds.code_actions, silent)
  buf_map(0, '', 'K',           '<cmd>lua vim.lsp.buf.hover()<CR>')
  buf_map(0, '', '[d',          '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
  buf_map(0, '', ']d',          '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
  buf_map(0, '', 'gD',          provider_cmds.declarations, silent)
  buf_map(0, '', 'gd',          provider_cmds.definitions, silent)
  buf_map(0, '', 'gi',          '<cmd>lua vim.lsp.buf.implementation()<CR>')
  -- buf_map(0, 'n', 'gr',          provider_cmds.references, silent)
  buf_map(0, '', 'gr',          '<cmd>lua vim.lsp.buf.references()<CR>', silent)
  buf_map(0, '', 'gy',          provider_cmds.type_definitions, silent)
end

-- Sets the location list with predefined options. Does not focus list.
function M.set_loc()
  if vim.o.buftype ~= '' then
    return
  end

  diagnostic.setloclist({
    open = false
  })
end

local diagnostic_severities = {
  [sev.ERROR] = { hl = '%#STError#',   type = 'E', kind = 'error',   sign = ''};
  [sev.WARN]  = { hl = '%#STWarning#', type = 'W', kind = 'warning', sign = ''};
  [sev.INFO]  = { hl = '%#STInfo#',    type = 'I', kind = 'info',    sign = ''};
  [sev.HINT]  = { hl = '%#STHint#',    type = 'H', kind = 'hint',    sign = ''};
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

  for _,v in ipairs(result.diagnostics) do
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
  bufnr = bufnr or vim.fn.bufnr('%')

  local cache = M.statusline_cache[bufnr]

  if cache then
    return cache
  end

  local diagnostics = M.buffers[bufnr]

  if diagnostics == nil then
    return ''
  end

  local t = {}

  if highlight then
    for i,v in ipairs(diagnostics) do
      if v > 0 then
        local severity = diagnostic_severities[i]
        t[#t+1] = severity.hl .. severity.sign .. ' ' .. v .. ' '
      end
    end
  else
    for i,v in ipairs(diagnostics) do
      if v > 0 then
        local severity = diagnostic_severities[i]
        t[#t+1] = severity.sign .. ' ' .. v .. ' '
      end
    end
  end

  local s = table.concat(t)
  M.statusline_cache[bufnr] = s
  return s
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local default_config = {
  on_attach = M.on_attach,
  capabilities = capabilities,
}

local sumneko_root_path = vim.fn.stdpath('config')..'/lsp/lua-language-server'
local sumneko_binary = sumneko_root_path.."/bin/Linux/lua-language-server"

M.configs = {
  sumneko_lua = vim.tbl_extend('force', require 'config.lua-lsp', {
    cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"}, on_attach = M.on_attach, capabilities = capabilities;
  }),
  cssls = { on_attach = M.on_attach, capabilities = capabilities },
  rust_analyzer =
    {
      auto_setup = false,
      on_attach = M.on_attach,
      capabilities = capabilities,
      settings = {
        ['rust-analyzer'] = {
          cargo = {
            runBuildScripts = false,
          } } } },
  omnisharp =
    {
      on_attach = M.on_attach,
      capabilities = capabilities,
      root_dir = nvim_lsp.util.root_pattern("*.csproj","*.sln"),
      cmd = { stdpath("config") .. "/lsp/omnisharp/run", "--languageserver" , "--hostPID", tostring(vim.fn.getpid()) },
      settings = {
        ["omnisharp.useGlobalMono"] = "always",
        omnisharp = {
          useGlobalMono = "always",
        }
      }
    }
  ,
  denols = default_config,
  html = default_config,
}

function M.setup()
  -- local winwidth = vim.fn.winwidth
  -- Config
  diagnostic.config {
    -- Only show virtual text if window is large enough
    -- virtual_text = function()
    --   return winwidth(0) >= 80
    -- end,
    virtual_text = {
      spacing = 16,
      prefix = '~',
    },
    update_in_insert = true,
    severity_sort = true,
  }

  for server, config in pairs(M.configs) do
    if config.auto_setup ~= false then
      nvim_lsp[server].setup(config)
    end
  end

  -- local pid = vim.fn.getpid()
  -- On linux/darwin if using a release build, otherwise under scripts/OmniSharp(.Core)(.cmd)
  -- local omnisharp_bin = "/home/timmer/.local/share/omnisharp/run"
  -- print("Setting up omnisharp at ", omnisharp_bin)

  -- nvim_lsp.omnisharp.setup{
  --   cmd = { omnisharp_bin, "--languageserver" , "--hostPID", tostring(pid) };
  -- root_dir = nvim_lsp.util.root_pattern("*.csproj","*.sln"),
  -- on_attach = M.on_attach,
  -- }

end

-- require('dd').setup {
--   timeout = 50
-- }

return M
