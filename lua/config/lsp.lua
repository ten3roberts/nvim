local function buf_map(buf, mod, lhs, rhs)
  vim.keymap.set(mod, lhs, rhs, { silent = true, buffer = buf })
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

  -- Jump forwards/backwards at the same tree level with '[[' and ']]'
  buf_map(0, '', '[[',         '<cmd>AerialPrevUp<CR>')
  buf_map(0, '', ']]',         '<cmd>AerialNextUp<CR>')

  local provider_cmds = cmd[provider]

  buf_map(0, '', '<leader>cf',  vim.lsp.buf.formatting)
  buf_map(0, '', '<leader>cf',  vim.lsp.buf.formatting)
  buf_map(0, '', '<leader>de',  vim.diagnostic.open_float)
  buf_map(0, '', '<leader>cwa', vim.lsp.buf.add_workspace_folder)
  buf_map(0, '', '<leader>cwl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end)
  buf_map(0, '', '<leader>cwr', vim.lsp.buf.remove_workspace_folder)
  buf_map(0, '', '<leader>q',   require"config.lsp".set_loc)
  buf_map(0, '', '<leader>rn',  vim.lsp.buf.rename)
  buf_map(0, '', '<leader>a',   vim.lsp.buf.code_action)
  buf_map(0, '', 'K',           vim.lsp.buf.hover)
  buf_map(0, '', '[d',          vim.lsp.diagnostic.goto_prev)
  buf_map(0, '', ']d',          vim.lsp.diagnostic.goto_next)
  buf_map(0, '', 'gD',          provider_cmds.declarations)
  buf_map(0, '', 'gd',          provider_cmds.definitions)
  buf_map(0, '', 'gi',          vim.lsp.buf.implementation)
  buf_map(0, '', 'gr',          vim.lsp.buf.references)
  buf_map(0, '', 'gy',          vim.lsp.buf.type_definition)

end

-- Sets the location list with predefined options. Does not focus list.
function M.set_loc()
  if vim.o.buftype ~= '' then
    return
  end

  diagnostic.setloclist({
    open = false,
    severity = { min = diagnostic.severity.WARN },
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

-- M.configs = {
--   sumneko_lua = vim.tbl_extend('force', require 'config.lua-lsp', {
--     cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"}, on_attach = M.on_attach, capabilities = capabilities;
--   }),
--   cssls = { on_attach = M.on_attach, capabilities = capabilities },
--   rust_analyzer =
--     {
--       auto_setup = false,
--       on_attach = M.on_attach,
--       capabilities = capabilities,
--       settings = {
--         ['rust-analyzer'] = {
--           cargo = {
--             runBuildScripts = false,
--           } } } },
--   omnisharp =
--     {
--       on_attach = M.on_attach,
--       capabilities = capabilities,
--       root_dir = nvim_lsp.util.root_pattern("*.csproj","*.sln"),
--       cmd = { stdpath("config") .. "/lsp/omnisharp/run", "--languageserver" , "--hostPID", tostring(vim.fn.getpid()) },
--       settings = {
--         ["omnisharp.useGlobalMono"] = "always",
--         omnisharp = {
--           useGlobalMono = "always",
--         }
--       }
--     }
--   ,
--   denols = default_config,
--   html = default_config,
-- }

-- function M.setup()
--   -- local winwidth = vim.fn.winwidth
--   -- Config
--   diagnostic.config {
--     -- Only show virtual text if window is large enough
--     -- virtual_text = function()
--     --   return winwidth(0) >= 80
--     -- end,
--     virtual_text = {
--       spacing = 16,
--       prefix = '~',
--     },
--     update_in_insert = true,
--     severity_sort = true,
--   }

--   for server, config in pairs(M.configs) do
--     if config.auto_setup ~= false then
--       nvim_lsp[server].setup(config)
--     end
--   end

--   -- local pid = vim.fn.getpid()
--   -- On linux/darwin if using a release build, otherwise under scripts/OmniSharp(.Core)(.cmd)
--   -- local omnisharp_bin = "/home/timmer/.local/share/omnisharp/run"
--   -- print("Setting up omnisharp at ", omnisharp_bin)

--   -- nvim_lsp.omnisharp.setup{
--   --   cmd = { omnisharp_bin, "--languageserver" , "--hostPID", tostring(pid) };
--   -- root_dir = nvim_lsp.util.root_pattern("*.csproj","*.sln"),
--   -- on_attach = M.on_attach,
--   -- }

-- end

-- require('dd').setup {
--   timeout = 50
-- }


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

local lsp_installer = require("nvim-lsp-installer")
-- Register a handler that will be called for each installed server when it's ready (i.e. when installation is finished
-- or if the server is already installed).
lsp_installer.on_server_ready(function(server)
  local opts = {
    on_attach = M.on_attach,
    capabilities = capabilities,
  }

  if server.name == "sumneko_lua" then
    opts = vim.tbl_extend("error", opts, require "config.lua-lsp")
  end

  -- (optional) Customize the options passed to the server
  -- if server.name == "tsserver" then
  --     opts.root_dir = function() ... end
  -- end

  -- This setup() function will take the provided server configuration and decorate it with the necessary properties
  -- before passing it onwards to lspconfig.
  -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
  server:setup(opts)
end)

return M
