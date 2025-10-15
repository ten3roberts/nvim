local keybinds = require("config.keybind_definitions")

vim.keymap.set("n", keybinds.getKeybind("diagnostic-next"), function()
  vim.diagnostic.jump { count = 1, float = true }
end, { desc = keybinds.getDesc("diagnostic-next") })

vim.keymap.set("n", keybinds.getKeybind("diagnostic-prev"), function()
  vim.diagnostic.jump { count = -1, float = true }
end, { desc = keybinds.getDesc("diagnostic-prev") })

vim.keymap.set("n", keybinds.getKeybind("diagnostic-next-error"), function()
  vim.diagnostic.jump { count = 1, float = true, severity = vim.diagnostic.severity.ERROR }
end, { desc = keybinds.getDesc("diagnostic-next-error") })

vim.keymap.set("n", keybinds.getKeybind("diagnostic-prev-error"), function()
  vim.diagnostic.jump { count = -1, float = true, severity = vim.diagnostic.severity.ERROR }
end, { desc = keybinds.getDesc("diagnostic-prev-error") })