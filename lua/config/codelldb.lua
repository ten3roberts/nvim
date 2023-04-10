local M = {}
local adapter = nil

function M.get_codelldb()
  if adapter then
    return adapter
  end

  local mason = require "mason-registry"
  local pkg = mason.get_package "codelldb"
  local command = pkg:get_install_path() .. "/extension/adapter/codelldb"
  local port = math.random(8000, 1000)

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
    port = "${port}",
    executable = {
      command = command,
      args = { "--port", "${port}" },
    },
  }

  return adapter
end

return M
