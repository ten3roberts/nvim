local crates = require "crates"
vim.keymap.set("n", "K", crates.show_crate_popup, { buffer = true })
vim.keymap.set("n", "<leader>cv", crates.show_versions_popup, { buffer = true })
vim.keymap.set("n", "<leader>cf", crates.show_features_popup, { buffer = true })
vim.keymap.set("n", "<leader>cd", crates.show_dependencies_popup, { buffer = true })
vim.keymap.set("n", "<leader>cu", crates.update_crate, { buffer = true })
vim.keymap.set("n", "<leader>cU", crates.update_all_crates, { buffer = true })
