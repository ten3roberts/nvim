local function buf_map(buf, mod, lhs, rhs, opt)
  vim.api.nvim_buf_set_keymap(buf, mod, lhs, rhs, opt or {})
end

local aerial = require'aerial'
local diagnostic = vim.lsp.diagnostic
local lsp_install = require 'lspinstall'
local lsp_signature = require'lsp_signature'
local nvim_lsp = require 'lspconfig'
local qf = require'qf'

local M = { buffers = {}, statusline_cache = {} }

local DiagnosticSeverity = require'vim.lsp.protocol'.DiagnosticSeverity

local diagnostic_severities = {
  [DiagnosticSeverity.Error]       = { hl = '%#STError#', type == 'E', kind = 'error', sign = ''};
  [DiagnosticSeverity.Warning]     = { hl = '%#STWarning#', type == 'W', kind = 'warning', sign = ''};
  [DiagnosticSeverity.Information] = { hl = '%#STInfo#', type == 'I', kind = 'info', sign = ''};
  [DiagnosticSeverity.Hint]        = { hl = '%#STHint#', type = 'I', kind = 'hint', sign = ''};
}

function M.on_attach()
  print("LSP started")

  -- Lsp signature
  lsp_signature.on_attach({
    bind = true,
    handler_opts = {
      border = "single"   -- double, single, shadow, none
    },
  })

  aerial.on_attach()

  -- Setup mappings

  -- Jump forwards/backwards with '{' and '}'
  buf_map(0, '', '{',         '<cmd>AerialPrev<CR>')
  buf_map(0, '', '}',         '<cmd>AerialNext<CR>')

  -- Jump forwards/backwards at the same tree level with '[[' and ']]'
  buf_map(0, '', '[[',         '<cmd>AerialPrevUp<CR>')
  buf_map(0, '', ']]',         '<cmd>AerialNextUp<CR>')

  buf_map(0, 'n', 'gD',         '<cmd>lua vim.lsp.buf.declaration()<CR>')
  buf_map(0, 'n', 'gd',         '<cmd>lua vim.lsp.buf.definition()<CR>')
  buf_map(0, 'n', 'K',          '<cmd>lua vim.lsp.buf.hover()<CR>')
  buf_map(0, 'n', 'gi',         '<cmd>lua vim.lsp.buf.implementation()<CR>')
  buf_map(0, 'n', '<leader>cwa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
  buf_map(0, 'n', '<leader>cwr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
  buf_map(0, 'n', '<leader>cwl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')
  buf_map(0, 'n', 'gy',         '<cmd>lua vim.lsp.buf.type_definition()<CR>')
  buf_map(0, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
  -- buf_map(bufnr, 'n', '<leader>a',  ':CodeAction<CR>')
  -- buf_map(bufnr, 'n', 'gr',         ':References<CR>')
  buf_map(0, 'n', '<leader>e',  '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')
  buf_map(0, 'n', '[d',         '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
  buf_map(0, 'n', ']d',         '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
  buf_map(0, 'n', '<leader>q',  '<cmd>lua require"config.lsp".set_loc()<CR>')
  buf_map(0, "n", "<leader>cf", "<cmd>lua vim.lsp.buf.formatting()<CR>")

end

-- Sets th0ation list with predefined options. Does not focus list.
function M.set_loc()
  -- buffer = buffer or vim.fn.bufnr('%')
  local severity_limit = nil
  -- local diagnostic_count = M.buffers[buffer]

  -- -- Don't show hint and info if there are errors to not clutter
  -- if diagnostic_count[DiagnosticSeverity.Error] ~= 0 then
  --   severity_limit = 'Warning'
  -- end

  local opts = { severity_limit = severity_limit, open_loclist = false }

  vim.lsp.diagnostic.set_loclist(opts)
  if not qf.list_visible('c') then
    qf.open('l', true, false)
  end
end

function M.on_publish_diagnostics(err, method, result, client_id, _, _)
  local uri = result.uri
  local bufnr = vim.uri_to_bufnr(uri)

  if not bufnr then
    return
  end

  -- Reset cache for current buffer
  M.clear_buffer_cache(bufnr)

  -- Tally up diagnostics
  local diagnostic_count = {
    [DiagnosticSeverity.Error] = 0,
    [DiagnosticSeverity.Warning] = 0,
    [DiagnosticSeverity.Information] = 0,
    [DiagnosticSeverity.Hint] = 0,
  }

  for _,v in ipairs(result.diagnostics) do
    local severity = v.severity

    diagnostic_count[severity] = diagnostic_count[severity] + 1
  end

  M.buffers[bufnr] = diagnostic_count

  diagnostic.on_publish_diagnostics(err, method, result, client_id, bufnr, {
    -- This will disable virtual text, like doing:
    -- let g:diagnostic_enable_virtual_text = 0
    virtual_text = false,

    -- This is similar to:
    -- let g:diagnostic_show_sign = 1
    -- To configure sign display,
    --  see: ":help diagnostic.set_signs()"
    signs = true,

    -- This is similar to:
    -- "let g:diagnostic_insert_delay = 1"
    update_in_insert = true,
  })

  if vim.api.nvim_get_mode().mode == 'n' then
    M.set_loc()
  end
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
        t[#t+1] = severity.hl .. severity.sign .. ' ' .. v
      end
    end
  else
    for i,v in ipairs(diagnostics) do
      if v > 0 then
        local severity = diagnostic_severities[i]
        t[#t+1] = severity.sign .. ' ' .. v
      end
    end
  end

  local s = table.concat(t, '  ')
  M.statusline_cache[bufnr] = s
  return s
end

M.configs = {
  lua = function() return require 'config.lua-lsp' end,
  rust = function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = false
    capabilities.textDocument.completion.completionItem.resolveSupport = {
      properties = {
        'documentation',
        'detail',
        'additionalTextEdits',
      }
    }

    return {
      setting = {
        ['rust-analyzer'] = {
          cargo = {
            runBuildScripts = false,
          }
        }
      }
    }
  end
}

function M.setup()
  lsp_install.setup()
  local servers = lsp_install.installed_servers()
  for _, server in pairs(servers) do
    local config = M.configs[server]
    config = vim.tbl_extend( "force", { on_attach = M.on_attach }, config and config() or {})
    -- print(vim.inspect(config))

    nvim_lsp[server].setup(config)
  end

  vim.cmd 'sign define LspDiagnosticsSignError text= texthl=LspDiagnosticsSignError linehl= numhl='
  vim.cmd 'sign define LspDiagnosticsSignWarning text= texthl=LspDiagnosticsSignWarning linehl= numhl='
  vim.cmd 'sign define LspDiagnosticsSignInformation text= texthl=LspDiagnosticsSignInformation linehl= numhl='
  vim.cmd 'sign define LspDiagnosticsSignHint text= texthl=LspDiagnosticsSignHint linehl= numhl='
end

return M
