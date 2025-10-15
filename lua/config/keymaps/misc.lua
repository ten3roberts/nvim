local graphene = require "graphene"
local keybinds = require("config.keybind_definitions")

vim.keymap.set("n", keybinds.getKeybind("graphene-init"), function()
  graphene.init()
end, { desc = keybinds.getDesc("graphene-init") })

vim.keymap.set("n", keybinds.getKeybind("indent-buffer"), "mggg=G`g", { desc = keybinds.getDesc("indent-buffer") })

vim.keymap.set("n", keybinds.getKeybind("dev-save-exec"), '<cmd>lua require"config.dev_utils".save_and_exec()<CR>', { desc = keybinds.getDesc("dev-save-exec") })