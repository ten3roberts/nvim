local function map(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, opts)
end

local graphene = require "graphene"

-- local neotest = require "neotest"

map("n", "<leader>j", function()
  vim.diagnostic.jump { count = 1, float = true, severity = { min = vim.diagnostic.severity.WARN } }
end)

map("n", "<leader>k", function()
  vim.diagnostic.jump { count = -1, float = true, severity = { min = vim.diagnostic.severity.WARN } }
end)

map("n", "<leader>l", function()
  vim.diagnostic.jump { count = 1, float = true, severity = vim.diagnostic.severity.ERROR }
end)

map("n", "<leader>h", function()
  vim.diagnostic.jump { count = -1, float = true, severity = vim.diagnostic.severity.ERROR }
end)

map("n", "<leader>bo", function()
  require("config.bclose").close_hidden()
end)

map("n", "<leader>to", "<cmd>tabonly<CR>")
map("n", "<leader>tt", "<cmd>tab split<CR>")
map("n", "<leader>tq", "<cmd>tabclose<CR>")

map("n", "<leader>f", function()
  graphene.init()
end)

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
map("n", "<leader>XX", '<cmd>lua require"config.dev_utils".save_and_exec()<CR>')
