local registry = require "mason-registry"

local M = {}

---@param package_name string
function M.install(package_name)
  local pkg = registry.get_package(package_name)

  if not pkg:is_installed() then
    pkg:install()
  end
end

---comment
---@param packages string[]
function M.ensure_installed(packages)
  for _, v in pairs(packages) do
    M.install(v)
  end
end

return M
