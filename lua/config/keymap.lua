local function map(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, opts)
end

local graphene = require "graphene"

-- local neotest = require "neotest"

local tree = require "config.treebind"

tree.register({
  f = {
    function()
      graphene.init()
    end,
    "Open parent folder",
  },
  -- F = {
  --   function()
  --     graphene.init "."
  --   end,
  --   "Open root",
  -- },
  -- n = {
  --   r = {
  --     function()
  --       neotest.run.run()
  --     end,
  --   },
  --   f = {
  --     function()
  --       neotest.run.run(vim.fn.expand "%")
  --     end,
  --   },
  -- },

  t = {
    name = "tabs",

    o = { "<cmd>tabonly<CR>", "Close other tabs" },
    t = { "<cmd>tab split<CR>", "New tab" },
    q = { "<cmd>tabclose<CR>", "Close tab" },
  },

  b = {
    name = "buffer",
    k = {
      require("config.bclose").close,
      "Close buffer",
    },
    o = {
      require("config.bclose").close_hidden,
      "Close all hidden buffers",
    },
  },

  j = {
    vim.diagnostic.goto_next,
    "Next diagnostic item",
  },
  k = {
    vim.diagnostic.goto_prev,
    "Prev diagnostic item",
  },
}, { prefix = "<leader>" })

for i = 0, 9 do
  map("n", "<leader>" .. i, i .. "gt")
end

map("n", "<A-,>", "<cmd>tabprevious<CR>")
map("n", "<A-.>", "<cmd>tabnext<CR>")
map("n", "<A-<>", "<cmd>tabmove -1<CR>")
map("n", "<A->>", "<cmd>tabmove +1<CR>")

-- Search highlighting
-- map("n", "n", "<plug>(searchhi-n)")
-- map("n", "N", "<plug>(searchhi-N)")
-- map("n", "*", "<plug>(searchhi-*)")
-- map("n", "g*", "<plug>(searchhi-g*)")
-- map("n", "#", "<plug>(searchhi-#)")
-- map("n", "g#", "<plug>(searchhi-g#)")
-- map("n", "gd", "<plug>(searchhi-gd)")
-- map("n", "gD", "<plug>(searchhi-gD)")
--
-- map("x", "n", "<plug>(searchhi-v-n)")
-- map("x", "N", "<plug>(searchhi-v-N)")
-- map("x", "*", "<plug>(searchhi-v-*)")
-- map("x", "g*", "<plug>(searchhi-v-g*)")
-- map("x", "#", "<plug>(searchhi-v-#)")
-- map("x", "g#", "<plug>(searchhi-v-g#)")
-- map("x", "gd", "<plug>(searchhi-v-gd)")
-- map("x", "gD", "<plug>(searchhi-v-gD)")

-- map({ "n", "x" }, "*", "<Plug>(asterisk-z*)")
-- map({ "n", "x" }, "#", "<Plug>(asterisk-z#)")
-- map({ "n", "x" }, "g*", "<Plug>(asterisk-gz*)")
-- map({ "n", "x" }, "g#", "<Plug>(asterisk-gz#)")

-- map({ "n", "x" }, "z*", "<Plug>(asterisk-z*)")
-- map({ "n", "x" }, "z#", "<Plug>(asterisk-z#)")
-- map({ "n", "x" }, "gz*", "<Plug>(asterisk-gz*)")
-- map({ "n", "x" }, "gz#", "<Plug>(asterisk-gz#)")

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohl<CR>", {})

-- Folding
for i = 1, 9 do
  local o = vim.o
  map("n", "z" .. i, function()
    o.foldlevel = i - 1
    print("Foldlevel: ", o.foldlevel)
  end)
end

-- Indent whole buffer
map("n", "<leader>ci", "mggg=G`g")

-- Dev utils
map("n", "<leader>xx", '<cmd>lua require"config.dev_utils".save_and_exec()<CR>')

require("config.treebind").register({
  r = { "<cmd>RustRunnables<CR>", "Rust runnables" },
  d = { "<cmd>RustDebuggables<CR>", "Rust debuggables" },
  u = { "<cmd>RustParentModule<CR>", "Rust parent module" },
  U = { "<cmd>RustOpenCargo<CR>", "Open Cargo.toml" },
}, { prefix = "<leader>r" })
