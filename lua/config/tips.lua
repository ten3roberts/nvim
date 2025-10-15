local function parse_readme()
  local readme_path = vim.fn.stdpath("config") .. "/README.md"
  local file = io.open(readme_path, "r")
  if not file then
    return {}
  end

  local lines = {}
  for line in file:lines() do
    table.insert(lines, line)
  end
  file:close()

  local tips = {}
  local in_keymaps = false
  for _, line in ipairs(lines) do
    if line:match("^# Keymaps") then
      in_keymaps = true
    elseif line:match("^# ") and in_keymaps then
      break
    elseif in_keymaps and line:match("^- ") then
      local mode, key, action = line:match("%*%*Mode%*%*: ([^|]+) %| %*%*Key%*%*: `([^`]+)` %| %*%*Action%*%*: ([^|]+)")
      if mode and key and action then
        table.insert(tips, "Tip: Press " .. key .. " to " .. action:lower())
      end
    end
  end

  local in_features = false
  for _, line in ipairs(lines) do
    if line:match("^## Features") then
      in_features = true
    elseif line:match("^## ") and in_features then
      break
    elseif in_features and line:match("^- %*%*") then
      local feature, desc = line:match("^- %*%*([^%*%*]+)%*%*: (.+)")
      if feature and desc then
        table.insert(tips, "Tip: " .. feature .. ": " .. desc)
      end
    end
  end

  return tips
end

local tips = parse_readme()

return tips