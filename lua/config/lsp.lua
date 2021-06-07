local function buf_map(buf, mod, lhs, rhs, opt)
  vim.api.nvim_buf_set_keymap(buf, mod, lhs, rhs, opt or {})
end

local nvim_lsp = require 'lspconfig'
local lsp_install = require 'lspinstall'

local M = {}

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
  buf_map(bufnr, 'n', '<space>q',  '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>',                         opts)
  buf_map(bufnr, "n", "<space>cf", "<cmd>lua vim.lsp.buf.formatting()<CR>",                                 opts)

end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
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
  }
)

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
