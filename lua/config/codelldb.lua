local mason = require "mason-registry"
local M = {}
function M.get_codelldb()
  local pkg = mason.get_package "codelldb"
  local cmd = pkg:get_install_path() .. "/extension/adapter/codelldb"
  -- local port = math.random(8000, 1000)

  if not pkg:is_installed() then
    vim.notify "Codelldb is not installed"
    return {}
  end

  local adapter = {
    type = "server",
    port = "${port}",
    executable = {
      command = cmd,
      args = { "--port", "${port}" },
    },
  }

  -- vim.notify("Codelldb adapter: " .. vim.inspect(adapter))
  return adapter
end

return M
