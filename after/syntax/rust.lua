require("config.treebind").register({
  r = { "<cmd>RustRunnables<CR>", "Rust runnables" },
  d = { "<cmd>RustDebuggables<CR>", "Rust debuggables" },
  u = { "<cmd>RustParentModule<CR>", "Rust parent module" },
  U = { "<cmd>RustOpenCargo<CR>", "Open Cargo.toml" },
}, { prefix = "<leader>r" })
