local M = {}
local buffers = {}
local statusline_cache = {}

local diagnostic = vim.diagnostic
local sev = diagnostic.severity

local signs = require("config.palette").signs
local diagnostic_severities = {
  [sev.ERROR] = signs.E,
  [sev.WARN] = signs.W,
  [sev.INFO] = signs.I,
  [sev.HINT] = signs.H,
}

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
end

function M.set_qf()
  if vim.o.buftype ~= "" then
    return
  end

  diagnostic.setqflist {
    open = false,
    severity = { min = diagnostic.severity.WARN },
  }
end

return M
