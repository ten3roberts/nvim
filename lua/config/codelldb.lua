local M = {}
local adapter = nil

function M.get_codelldb()
  if true then return {} end
  if adapter then
    return adapter
  end

  local mason = require "mason-registry"
  local pkg = mason.get_package "codelldb"
  local install_path = vim.fn.expand("$MASON/packages/codelldb")

  vim.notify("Codelldb found at " .. install_path)

  local command = install_path .. "/extension/adapter/codelldb"
  local port = math.random(8000, 80000)

  if not pkg:is_installed() then
    vim.notify "Codelldb is not installed"
    return {}
  end

  -- return function(cb, config)
  --   local recipe = require "recipe"
  --   recipe.execute { cmd = { cmd, "--port", port }, key = "codelldb" }
  --   cb { type = "server", port = port }
  -- end
  adapter = {
    type = "server",
    port = port,
    executable = {
      command = command,
      args = { "--port", port },
    },
  }
  vim.notify("Configured codelldb: " .. vim.inspect(adapter))

  return adapter
end

return M
