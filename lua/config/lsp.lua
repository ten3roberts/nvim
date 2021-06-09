local function buf_map(buf, mod, lhs, rhs, opt)
  vim.api.nvim_buf_set_keymap(buf, mod, lhs, rhs, opt or {})
end

local lsp_install = require 'lspinstall'
local nvim_lsp = require 'lspconfig'
local qf = require'qf'
local diagnostic = vim.lsp.diagnostic
local util = vim.lsp.util
local api = vim.api

local M = { buffers = {}, statusline_cache = {} }

local DiagnosticSeverity = require'vim.lsp.protocol'.DiagnosticSeverity

local diagnostic_severities = {
  [DiagnosticSeverity.Error]       = { hl = '%#STError#', type == 'E', kind = 'error', sign = ''};
  [DiagnosticSeverity.Warning]     = { hl = '%#STWarning#', type == 'W', kind = 'warning', sign = ''};
  [DiagnosticSeverity.Information] = { hl = '%#STInfo#',type == 'I', kind = 'info', sign = ''};
  [DiagnosticSeverity.Hint]        = { hl = '%#STHint#', type = 'I', kind = 'hint', sign = ''};
}

local to_severity = function(severity)
  if not severity then return nil end
  return type(severity) == 'string' and DiagnosticSeverity[severity] or severity
end

local filter_to_severity_limit = function(severity, diagnostics)
  local filter_level = to_severity(severity)
  if not filter_level then
    return diagnostics
  end

  return vim.tbl_filter(function(t) return t.severity == filter_level end, diagnostics)
end

local filter_by_severity_limit = function(severity_limit, diagnostics)
  local filter_level = to_severity(severity_limit)
  if not filter_level then
    return diagnostics
  end

  return vim.tbl_filter(function(t) return t.severity <= filter_level end, diagnostics)
end


function M.on_attach()
  print("LSP started")

  -- Lsp signature
  require'lsp_signature'.on_attach({
    bind = true,
    handler_opts = {
      border = "single"   -- double, single, shadow, none
    },
  })

  -- Setup mappings
  local opts = {}

  local bufnr = vim.fn.bufnr('.')
  buf_map(bufnr, 'n', 'gd',        '<cmd>lua vim.lsp.buf.declaration()<cr>',                                opts)
  buf_map(bufnr, 'n', 'gd',        '<cmd>lua vim.lsp.buf.definition()<cr>',                                 opts)
  buf_map(bufnr, 'n', 'K',         '<cmd>lua vim.lsp.buf.hover()<CR>',                                      opts)
  buf_map(bufnr, 'n', 'gi',        '<cmd>lua vim.lsp.buf.implementation()<CR>',                             opts)
  buf_map(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>',                       opts)
  buf_map(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>',                    opts)
  buf_map(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_map(bufnr, 'n', '<space>D',  '<cmd>lua vim.lsp.buf.type_definition()<CR>',                            opts)
  buf_map(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>',                                     opts)
  buf_map(bufnr, 'n', '<space>a',  '<cmd>lua vim.lsp.buf.code_action()<CR>',                                opts)
  buf_map(bufnr, 'n', 'gr',        '<cmd>lua vim.lsp.buf.references()<CR>',                                 opts)
  buf_map(bufnr, 'n', '<space>e',  '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>',               opts)
  buf_map(bufnr, 'n', '[d',        '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>',                           opts)
  buf_map(bufnr, 'n', ']d',        '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>',                           opts)
  buf_map(bufnr, 'n', '<space>q',  '<cmd>lua require"config.lsp".set_loc()<CR>',                         opts)
  buf_map(bufnr, "n", "<space>cf", "<cmd>lua vim.lsp.buf.formatting()<CR>",                                 opts)

end

function M.set_loc()
  local opts = { severity_limit = nil  }

  local bufnr = api.nvim_get_current_buf()
  local buffer_diags = diagnostic.get(bufnr, opts.client_id)

  if opts.severity then
    buffer_diags = filter_to_severity_limit(opts.severity, buffer_diags)
  elseif opts.severity_limit then
    buffer_diags = filter_by_severity_limit(opts.severity_limit, buffer_diags)
  end

  local items = {}
  local insert_diag = function(diag)
    local pos = diag.range.start
    local row = pos.line
    local col = util.character_offset(bufnr, row, pos.character)

    local line = (api.nvim_buf_get_lines(bufnr, row, row + 1, false) or {""})[1]

    table.insert(items, {
      bufnr = bufnr,
      lnum = row + 1,
      col = col + 1,
      text = line .. " | " .. diag.message,
      type = diagnostic_severities[diag.severity or DiagnosticSeverity.Error].type or 'E',
    })
  end

  for _, diag in ipairs(buffer_diags) do
    insert_diag(diag)
  end

  table.sort(items, function(a, b) return a.lnum < b.lnum end)

  qf.set('l', items)
end

function M.on_publish_diagnostics(err, method, result, client_id, _, _)
  local uri = result.uri
  local bufnr = vim.uri_to_bufnr(uri)

  if not bufnr then
    return
  end

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

  -- Reset statusline cache for current buffer
  M.statusline_cache[bufnr] = nil

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
    update_in_insert = false,
  })

  -- Only update location list in insert mode
  if api.nvim_get_mode().mode ~= 'i' then
    M.set_loc()
  end
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = M.on_publish_diagnostics

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
  lua = function() return require 'config.lua-lsp' end
}

function M.setup()
  lsp_install.setup()
  local servers = lsp_install.installed_servers()
  for _, server in pairs(servers) do
    local config = M.configs[server]
    config = vim.tbl_extend( "force", { on_attach = M.on_attach }, config and config() or {})

    nvim_lsp[server].setup(config)
  end

  vim.cmd 'sign define LspDiagnosticsSignError text= texthl=LspDiagnosticsSignError linehl= numhl='
  vim.cmd 'sign define LspDiagnosticsSignWarning text= texthl=LspDiagnosticsSignWarning linehl= numhl='
  vim.cmd 'sign define LspDiagnosticsSignInformation text= texthl=LspDiagnosticsSignInformation linehl= numhl='
  vim.cmd 'sign define LspDiagnosticsSignHint text= texthl=LspDiagnosticsSignHint linehl= numhl='
end

return M
