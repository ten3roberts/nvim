local function buf_map(buf, mod, lhs, rhs, opt)
  vim.api.nvim_buf_set_keymap(buf, mod, lhs, rhs, opt or {})
end

local lsp_install = require 'lspinstall'
local nvim_lsp = require 'lspconfig'
local qf = require'qf'

local M = { buffers = {} }

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

local DiagnosticSeverity = require'vim.lsp.protocol'.DiagnosticSeverity

local diagnostic_severities = {
  [DiagnosticSeverity.Error]       = { guifg = "Red", kind = 'error', sign = ''};
  [DiagnosticSeverity.Warning]     = { guifg = "Orange", kind = 'warning', sign = ''};
  [DiagnosticSeverity.Information] = { guifg = "LightBlue", kind = 'info', sign = ''};
  [DiagnosticSeverity.Hint]        = { guifg = "LightGrey", kind = 'hint', sign = ''};
}


function M.set_loc()
  vim.lsp.diagnostic.set_loclist({ open_loclist = false })

  qf.open('l', true)
end

function M.on_publish_diagnostics(err, method, result, client_id, _, _)
  print("Publishing diagnostic")
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

  print(vim.inspect(diagnostic_count))

  M.buffers[bufnr] = diagnostic_count


  vim.lsp.diagnostic.on_publish_diagnostics(err, method, result, client_id, bufnr, {
    -- This will disable virtual text, like doing:
    -- let g:diagnostic_enable_virtual_text = 0
    virtual_text = false,

    -- This is similar to:
    -- let g:diagnostic_show_sign = 1
    -- To configure sign display,
    --  see: ":help vim.lsp.diagnostic.set_signs()"
    signs = true,

    -- This is similar to:
    -- "let g:diagnostic_insert_delay = 1"
    update_in_insert = false,
  })

  -- Only update location list in insert mode
  if vim.api.nvim_get_mode().mode ~= 'i' then
    M.set_loc()
  end

end

vim.lsp.handlers["textDocument/publishDiagnostics"] = M.on_publish_diagnostics

-- Returns a formatted statusline
function M.statusline(sep, bufnr)
  bufnr = bufnr or vim.fn.bufnr('%')

  local diagnostics = M.buffers[bufnr]

  local t = {}

  for k,v in pairs(diagnostics) do
    if v > 0 then
      t[#t+1] = diagnostic_severities[k].sign .. ' ' .. v
    end
  end

  local s = table.concat(t, sep or ' | ')
  M.statusline_str = s
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
