local M = {}
local buffers = {}
local statusline_cache = {}

local qf = require "qf"
local diagnostic = vim.diagnostic
local sev = diagnostic.severity

local signs = require("config.palette").signs
local diagnostic_severities = {
  [sev.ERROR] = signs.E,
  [sev.WARN] = signs.W,
  [sev.INFO] = signs.I,
  [sev.HINT] = signs.H,
}

function M.clear_buffer_cache(bufnr)
  buffers[bufnr] = nil
  statusline_cache[bufnr] = nil
end

-- Returns a formatted statusline
function M.statusline(bufnr, highlight)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  local cache = statusline_cache[bufnr]

  if cache then
    return cache
  end

  local diagnostics = buffers[bufnr]

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
  statusline_cache[bufnr] = s
  return s
end

local old = vim.lsp.buf.add_workspace_folder
vim.lsp.buf.add_workspace_folder = function(...)
  vim.notify("Adding workspace folder from: " .. vim.inspect(debug.traceback))
  old(...)
end

-- Sets the location list with predefined options. Does not focus list.
function M.set_loc(open)
  diagnostic.setloclist {
    open = false,
    severity = { min = diagnostic.severity.WARN },
  }

  qf.open("l", false, true)
end

function M.set_qf()
  if vim.o.buftype ~= "" then
    return
  end

  diagnostic.setqflist {
    open = false,
    severity = { min = diagnostic.severity.WARN },
  }

  qf.open("c", false, true)
end

return M
