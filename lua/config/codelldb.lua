local M = {}

M.adapter = nil

function M.get_codelldb()
  if M.adapter then
    return M.adapter
  end

  local command = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb"
  local port = math.random(8000, 80000)

  M.adapter = {
    type = "server",
    port = port,
    executable = {
      command = command,
      args = { "--port", tostring(port) },
    },
  }
  vim.notify "CodeLLDB ready"

  return M.adapter
end

return M
