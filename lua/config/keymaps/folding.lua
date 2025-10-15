local keybinds = require("config.keybind_definitions")

for i = 1, 9 do
  local o = vim.o
  vim.keymap.set("n", "z" .. i, function()
    o.foldlevel = i - 1
    vim.notify("Foldlevel: " .. o.foldlevel, vim.log.levels.INFO)
  end)
end