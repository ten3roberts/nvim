local keybinds = require("config.keybind_definitions")

-- Clear search highlight
vim.keymap.set("n", keybinds.getKeybind("nohl"), "<cmd>nohl<CR>", { desc = keybinds.getDesc("nohl") })