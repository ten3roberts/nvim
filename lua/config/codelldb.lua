local M = {}

function M.get_codelldb()
  local mason = require "mason-registry"
  local pkg = mason.get_package "codelldb"
  local cmd = pkg:get_install_path() .. "/extension/adapter/codelldb"
  local port = math.random(8000, 1000)

  if not pkg:is_installed() then
    vim.notify "Codelldb is not installed"
    return {}
  end

  return function(cb, config)
    local recipe = require "recipe"
    recipe.execute { cmd = { cmd, "--port", port }, key = "codelldb" }
    cb { type = "server", port = port }
  end
  -- local adapter = {
  --   type = "server",
  --   port = vim.g.codelldb_port,
  --   -- executable = {
  --   --   command = cmd,
  --   --   args = { "--port", "${port}" },
  --   -- },
  -- }

  -- vim.notify("Codelldb adapter: " .. vim.inspect(adapter))
end

return M
