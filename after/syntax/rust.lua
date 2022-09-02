local wk = require "which-key"
wk.register({
  r = { "<cmd>RustRunnables<CR>", "Rust runnables" },
  d = { "<cmd>RustDebuggables<CR>", "Rust debuggables" },
  u = { "<cmd>RustParentModule<CR>", "Rust parent module" },
  U = { "<cmd>RustOpenCargo<CR>", "Open Cargo.toml" },
}, { prefix = "<leader>r" })
