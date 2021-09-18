local function buf_map(buf, mod, lhs, rhs, opt)
  vim.api.nvim_buf_set_keymap(buf, mod, lhs, rhs, opt or {})
end

local aerial = require'aerial'
local diagnostic = vim.diagnostic
local lsp_diagnostic = vim.lsp.diagnostic
local lsp_install = require 'lspinstall'
local lsp_signature = require'lsp_signature'
local nvim_lsp = require 'lspconfig'
local sev = diagnostic.severity

local M = { buffers = {}, statusline_cache = {} }

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
      border = "none"   -- double, single, shadow, none
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

  buf_map(0, "n", "<leader>cf",  "<cmd>lua vim.lsp.buf.formatting()<CR>")
  buf_map(0, 'n', '<leader>cwa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
  buf_map(0, 'n', '<leader>cwl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')
  buf_map(0, 'n', '<leader>cwr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
  buf_map(0, 'n', '<leader>e',   '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')
  buf_map(0, 'n', '<leader>q',   '<cmd>lua require"config.lsp".set_loc()<CR>')
  buf_map(0, 'n', '<leader>rn',  '<cmd>lua vim.lsp.buf.rename()<CR>')
  buf_map(0, 'n', 'K',           '<cmd>lua vim.lsp.buf.hover()<CR>')
  buf_map(0, 'n', '[d',          '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
  buf_map(0, 'n', ']d',          '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
  buf_map(0, 'n', 'gD',          '<cmd>lua vim.lsp.buf.declaration()<CR>')
  buf_map(0, 'n', 'gd',          ':Telescope lsp_definitions<CR>', silent)
  buf_map(0, 'n', 'gi',          '<cmd>lua vim.lsp.buf.implementation()<CR>')
  buf_map(0, 'n', 'gr',          ':Telescope lsp_references<CR>', silent)
  buf_map(0, 'n', 'gy',          '<cmd>lua vim.lsp.buf.type_definition()<CR>')
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
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      'documentation',
      'detail',
      -- 'additionalTextEdits',
    }
  }

  local default_config = {
    on_attach = M.on_attach,
    capabilities = capabilities,
  }

  M.configs = {
    lua = function() return vim.tbl_extend('force', require 'config.lua-lsp', default_config) end,
    css = function()
      return { on_attach = M.on_attach, capabilities = capabilities }
    end,

    rust = function()
      return {
        on_attach = M.on_attach,
        capabilities = capabilities,
        settings = {
          ['rust-analyzer'] = {
            cargo = {
              runBuildScripts = false,
            }
          }
        }
      }
    end,
    csharp = function()
      return {
        on_attach = M.on_attach,
        capabilities = capabilities,
        root_dir = nvim_lsp.util.root_pattern("*.csproj","*.sln"),
        cmd = { "omnisharp_run", "--languageserver" , "--hostPID", tostring(vim.fn.getpid()) },
        -- settings = {
          --   ["omnisharp.useGlobalMono"] = "always",
          --   omnisharp = {
            --     useGlobalMono = "always",
            --   }
            -- }
          }
        end
      }

      function M.setup()
        -- Config
        diagnostic.config {
          virtual_text = false,
          update_in_insert = true,
          severity_sort = true,
        }

        lsp_install.setup()
        local servers = lsp_install.installed_servers()
        for _, server in pairs(servers) do
          local config = M.configs[server]
          config = config and config() or default_config

          nvim_lsp[server].setup(config)
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

        return M
