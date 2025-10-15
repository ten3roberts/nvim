local M = {}

function M.get_codelldb()
  local command = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb"
  local port = math.random(8000, 80000)

  local adapter = {
    type = "server",
    port = port,
    executable = {
      command = command,
      args = { "--port", tostring(port) },
    },
  }
  vim.notify("CodeLLDB configured")

  return adapter
end

return M
