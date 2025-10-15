local keybinds = require("config.keybind_definitions")

-- Clear search highlight
vim.keymap.set("n", keybinds.getKeybind("nohl"), "<cmd>nohl<CR>", { desc = keybinds.getDesc("nohl") })

-- Search highlighting (commented out)
-- vim.keymap.set("n", "n", "<plug>(searchhi-n)")
-- vim.keymap.set("n", "N", "<plug>(searchhi-N)")
-- vim.keymap.set("n", "*", "<plug>(searchhi-*)")
-- vim.keymap.set("n", "g*", "<plug>(searchhi-g*)")
-- vim.keymap.set("n", "#", "<plug>(searchhi-#)")
-- vim.keymap.set("n", "g#", "<plug>(searchhi-g#)")
-- vim.keymap.set("n", "gd", "<plug>(searchhi-gd)")
-- vim.keymap.set("n", "gD", "<plug>(searchhi-gD)")
--
-- vim.keymap.set("x", "n", "<plug>(searchhi-v-n)")
-- vim.keymap.set("x", "N", "<plug>(searchhi-v-N)")
-- vim.keymap.set("x", "*", "<plug>(searchhi-v-*)")
-- vim.keymap.set("x", "g*", "<plug>(searchhi-v-g*)")
-- vim.keymap.set("x", "#", "<plug>(searchhi-v-#)")
-- vim.keymap.set("x", "g#", "<plug>(searchhi-v-g#)")
-- vim.keymap.set("x", "gd", "<plug>(searchhi-v-gd)")
-- vim.keymap.set("x", "gD", "<plug>(searchhi-v-gD)")
--
-- vim.keymap.set({ "n", "x" }, "*", "<Plug>(asterisk-z*)")
-- vim.keymap.set({ "n", "x" }, "#", "<Plug>(asterisk-z#)")
-- vim.keymap.set({ "n", "x" }, "g*", "<Plug>(asterisk-gz*)")
-- vim.keymap.set({ "n", "x" }, "g#", "<Plug>(asterisk-gz#)")
--
-- vim.keymap.set({ "n", "x" }, "z*", "<Plug>(asterisk-z*)")
-- vim.keymap.set({ "n", "x" }, "z#", "<Plug>(asterisk-z#)")
-- vim.keymap.set({ "n", "x" }, "gz*", "<Plug>(asterisk-gz*)")
-- vim.keymap.set({ "n", "x" }, "gz#", "<Plug>(asterisk-gz#)")