local graphene = require "graphene"
local keybinds = require("config.keybind_definitions")

vim.keymap.set("n", keybinds.getKeybind("graphene-init"), function()
  graphene.init()
end, { desc = keybinds.getDesc("graphene-init") })

vim.keymap.set("n", keybinds.getKeybind("indent-buffer"), "mggg=G`g", { desc = keybinds.getDesc("indent-buffer") })

vim.keymap.set("n", keybinds.getKeybind("dev-save-exec"), '<cmd>lua require"config.dev_utils".save_and_exec()<CR>', { desc = keybinds.getDesc("dev-save-exec") })

-- Git workflow keybindings
vim.keymap.set("n", keybinds.getKeybind("git-status"), "<cmd>GitStatus<CR>", { desc = keybinds.getDesc("git-status") })
vim.keymap.set("n", keybinds.getKeybind("git-commit"), function()
  require("snacks").picker.git_log()
end, { desc = keybinds.getDesc("git-commit") })
vim.keymap.set("n", keybinds.getKeybind("git-push"), "<cmd>!git push<CR>", { desc = keybinds.getDesc("git-push") })
vim.keymap.set("n", keybinds.getKeybind("git-pull"), "<cmd>!git pull<CR>", { desc = keybinds.getDesc("git-pull") })

-- Bracket-based navigation (vim-unimpaired style)
vim.keymap.set("n", keybinds.getKeybind("bracket-prev-buffer"), "<cmd>bprevious<CR>", { desc = keybinds.getDesc("bracket-prev-buffer") })
vim.keymap.set("n", keybinds.getKeybind("bracket-next-buffer"), "<cmd>bnext<CR>", { desc = keybinds.getDesc("bracket-next-buffer") })
vim.keymap.set("n", keybinds.getKeybind("bracket-prev-tab"), "<cmd>tabprevious<CR>", { desc = keybinds.getDesc("bracket-prev-tab") })
vim.keymap.set("n", keybinds.getKeybind("bracket-next-tab"), "<cmd>tabnext<CR>", { desc = keybinds.getDesc("bracket-next-tab") })
vim.keymap.set("n", keybinds.getKeybind("bracket-prev-quickfix"), "<cmd>cprevious<CR>", { desc = keybinds.getDesc("bracket-prev-quickfix") })
vim.keymap.set("n", keybinds.getKeybind("bracket-next-quickfix"), "<cmd>cnext<CR>", { desc = keybinds.getDesc("bracket-next-quickfix") })
vim.keymap.set("n", keybinds.getKeybind("bracket-prev-loclist"), "<cmd>lprevious<CR>", { desc = keybinds.getDesc("bracket-prev-loclist") })
vim.keymap.set("n", keybinds.getKeybind("bracket-next-loclist"), "<cmd>lnext<CR>", { desc = keybinds.getDesc("bracket-next-loclist") })
vim.keymap.set("n", keybinds.getKeybind("bracket-prev-diagnostic"), vim.diagnostic.goto_prev, { desc = keybinds.getDesc("bracket-prev-diagnostic") })
vim.keymap.set("n", keybinds.getKeybind("bracket-next-diagnostic"), vim.diagnostic.goto_next, { desc = keybinds.getDesc("bracket-next-diagnostic") })
vim.keymap.set("n", keybinds.getKeybind("bracket-prev-error"), function() vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.ERROR } end, { desc = keybinds.getDesc("bracket-prev-error") })
vim.keymap.set("n", keybinds.getKeybind("bracket-next-error"), function() vim.diagnostic.goto_next { severity = vim.diagnostic.severity.ERROR } end, { desc = keybinds.getDesc("bracket-next-error") })

-- Clipboard keybindings for system clipboard
vim.keymap.set({ "n", "v" }, keybinds.getKeybind("clipboard-yank"), '"+y', { desc = keybinds.getDesc("clipboard-yank") })
vim.keymap.set({ "n", "v" }, keybinds.getKeybind("clipboard-paste"), '"+p', { desc = keybinds.getDesc("clipboard-paste") })
vim.keymap.set({ "n", "v" }, keybinds.getKeybind("clipboard-paste-before"), '"+P', { desc = keybinds.getDesc("clipboard-paste-before") })