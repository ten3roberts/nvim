local M = {}

local function parse_mappings(prefix, node, result)
  if #node == 0 then
    for k, v in pairs(node) do
      if k ~= "name" then
        if type(k) ~= "string" then
          vim.notify(string.format("Expected string as key, found: %s.%s", prefix, k), vim.log.levels.ERROR)
        end

        parse_mappings(prefix .. k, v, result)
      end
    end
  else
    -- leaf keybind
    local cmd = node[1]

    if cmd == nil then
      vim.notify(string.format("Command for mapping: %q is nil", prefix), vim.log.levels.ERROR)
      return
    end
    local desc = node[2]

    table.insert(result, { lhs = prefix, cmd = cmd, desc = desc })
  end
end

---@class TreebindOpts
---@field mode string|nil Default: n
---@field prefix string|nil
---@field buffer number|nil
---@field remap boolean|nil

---@param bindings MappingTree
---@param opts TreebindOpts
function M.register(bindings, opts)
  opts = opts or {}
  local result = {}

  parse_mappings(opts.prefix or "", bindings, result)

  for _, v in ipairs(result) do
    local o = { desc = v.desc, buffer = opts.buffer, remap = opts.remap }

    if type(v.cmd) == "string" and v.cmd:lower():sub(1, #"<plug>") == "<plug" then
      o.remap = true
    end

    vim.keymap.set(opts.mode or "n", v.lhs, v.cmd, o)
  end
end

return M
