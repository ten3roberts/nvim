local function map(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, opts)
end

local silent = { silent = true }

vim.g.mapleader = ' '

map("n", "<leader>f", ":Graphene", silent)
map("n", "<leader>pe", ":Graphene .", silent)

-- Harpoon
local harpoon_term = require("harpoon.term")
local harpoon_ui = require("harpoon.ui")
map('n', '<leader>ha', require("harpoon.mark").add_file)
map('n', '<leader>ho', harpoon_ui.toggle_quick_menu)
map('n', '<leader>hh', harpoon_ui.toggle_quick_menu)
map('n', '<leader>ht', function() harpoon_term.gotoTerminal(1) end)

for i = 0, 9 do
  map('n', '<leader>h' .. i, function() harpoon_ui.nav_file(i) end)
end

-- Quickfix and location list
map('n', '<leader>ll', ':Lopen<CR>', silent) -- Open location list
map('n', '<leader>lo', ':Lopen true<CR>', silent) -- Open location list
map('n', '<leader>lc', ':Lclose<CR>', silent) -- Close location list
map('n', '<leader>lt', ':Ltoggle true<CR>', silent) -- Toggle location list and stay in current window

map('n', '<leader>co', ':Qopen<CR>', silent) -- Open quickfix list
map('n', '<leader>cl', ':clast<CR>', silent) -- Open quickfix list
map('n', '<leader>cf', ':cfirst<CR>', silent) -- Open quickfix list
-- map('n', '<leader>co', '<cmd>lua require"qf".open("c")<CR>') -- Open quickfix list
map('n', '<leader>cc', ':Qclose<CR>', silent) -- Close quickfix list
map('n', '<leader>C', ':Qclose<CR>', silent) -- Close quickfix list
map('n', '<leader>ct', ':Qtoggle true<CR>', silent) --Toggle quickfix list and stay in current window


map('n', '<leader>j', ':Lbelow<CR>', silent) -- Go to next location list entry from cursor
map('n', '<leader>k', ':Labove<CR>', silent) -- Go to previous location list entry from cursor

map('n', ']q', ':Vbelow<CR>', silent) -- Go to next quickfix entry from cursor
map('n', '[q', ':Vabove<CR>', silent) -- Go to previous quickfix entry from cursor
map('n', '<leader>J', 'Qbelow', silent) -- Go to next quickfix entry from cursor
map('n', '<leader>K', 'Qabove', silent) -- Go to previous quickfix entry from cursor

map('x', 'gl', ':<c-u>lua require"config.onlines"()<CR>', silent)

-- Dispatching
local recipe = require "recipe"

map('n', '<leader>e', function() recipe.pick() end)
map('n', '<leader>Eb', function() recipe.bake("build") end)
map('n', '<leader>Er', function() recipe.bake("run") end)
map('n', '<leader>Ec', function() recipe.bake("check") end)
map('n', '`<CR>', function() recipe.bake("check") end)

-- Tabs
map('n', '<leader>N', ':tabnew<CR>')
map('n', '<leader>S', ':tab split<CR>')
map('n', '<leader>Q', ':tabclose<CR>')
map('n', '<leader>to', ':tabonly<CR>')

for i = 0, 9 do
  map('n', '<leader>' .. i, i .. 'gt')
  map('n', '<A-' .. i .. '>', i .. 'gt')
  map('!', '<A-' .. i .. '>', '<ESC>' .. i .. 'gt')
  map('t', '<A-' .. i .. '>', '<C-\\><C-n>' .. i .. 'gt')
end

map('n', '<A-,>', ':tabprevious<CR>')
map('n', '<A-.>', ':tabnext<CR>')
map('n', '<A-<>', ':tabmove -1<CR>')
map('n', '<A->>', ':tabmove +1<CR>')

-- Buffers
map('n', '<leader>bk', ':lua require"config.bclose".close()<CR>')
map('n', '<leader>bo', ':lua require"config.bclose".close_hidden()<CR>')
map('n', '<leader>bp', '<C-^>')

map('n', '<leader>w', ':WindowPick<CR>')
map('n', '<leader>W', ':WindowSwap<CR>')

-- Git mappings
map('n', '<leader>gg', ':Ge :<CR>')
map('n', '<leader>gd', ':G difftool --name-status<CR>')
map('n', '<leader>ga', ':Git add %<CR>')
map('n', '<leader>gS', ':Git stage .<CR>')
map('n', '<leader>gc', ':Git commit<CR>')
map('n', '<leader>gpp', ':Git push<CR>')
map('n', '<leader>gpf', ':Git push --force-with-lease<CR>')
map('n', '<leader>g2', ':diffget //2<CR>')
map('n', '<leader>g3', ':diffget //3<CR>')

-- -- Neogit
-- map('', '<leader>gg', ':Neogit<CR>')
-- map('', '<leader>gd', ':DiffviewOpen<CR>')
-- map('', '<leader>gq', ':DiffviewClose<CR>')
-- map('', '<leader>gD', ':DiffviewOpen master<CR>')
-- map('', '<leader>gl', ':Neogit log<CR>')
-- map('', '<leader>gp', ':Neogit push<CR>')

map('n', '<leader>gpu', ':Git pull<CR>')
-- map('n', '<leader>gpf', ':Git push --force<CR>')
map('n', '<leader>gf', ':Git fetch<CR>')

-- Search highlighting
map('n', 'n', '<plug>(searchhi-n)')
map('n', 'N', '<plug>(searchhi-N)')
map('n', '*', '<plug>(searchhi-*)')
map('n', 'g*', '<plug>(searchhi-g*)')
map('n', '#', '<plug>(searchhi-#)')
map('n', 'g#', '<plug>(searchhi-g#)')
map('n', 'gd', '<plug>(searchhi-gd)')
map('n', 'gD', '<plug>(searchhi-gD)')

map('x', 'n', '<plug>(searchhi-v-n)')
map('x', 'N', '<plug>(searchhi-v-N)')
map('x', '*', '<plug>(searchhi-v-*)')
map('x', 'g*', '<plug>(searchhi-v-g*)')
map('x', '#', '<plug>(searchhi-v-#)')
map('x', 'g#', '<plug>(searchhi-v-g#)')
map('x', 'gd', '<plug>(searchhi-v-gd)')
map('x', 'gD', '<plug>(searchhi-v-gD)')

-- Clear search highlight
map('n', '<Esc>', '<plug>(searchhi-clear-all)')

-- Easy align
map('x', 'ga', '<plug>(EasyAlign)')
map('n', 'ga', '<plug>(EasyAlign)')

-- Snippet expansion
map('i', '<C-l>', "<Plug>(vsnip-expand-or-jump)")
map('n', '<C-l>', "<Plug>(vsnip-expand-or-jump)")
map('i', '<C-h>', "<Plug>(vsnip-jump-prev)")
map('n', '<C-h>', "<Plug>(vsnip-jump-prev)")

-- Movements
map('', '<C-j>', '}', { noremap = true })
map('', '<C-k>', '{', { noremap = true })
map('i', '<C-5>', '<C-o>%', { noremap = true })

-- Clipboard
-- map('n', 'p',     '<Plug>(miniyank-autoput)')
-- map('n', 'P',     '<Plug>(miniyank-autoPut)')
-- map('n', '<A-p>', '<Plug>(miniyank-cycle)')
-- map('n', '<A-P>', '<Plug>(miniyank-cycleback)')

map("n", "p", "<Plug>(YankyPutAfter)")
map("n", "P", "<Plug>(YankyPutBefore)")
map("x", "p", "<Plug>(YankyPutAfter)")
map("x", "P", "<Plug>(YankyPutBefore)")
map("n", "gp", "<Plug>(YankyGPutAfter)")
map("n", "gP", "<Plug>(YankyGPutBefore)")
map("x", "gp", "<Plug>(YankyGPutAfter)")
map("x", "gP", "<Plug>(YankyGPutBefore)")
map("n", "<A-n>", "<Plug>(YankyCycleForward)")
map("n", "<A-p>", "<Plug>(YankyCycleBackward)")
-- map('', '<C-a>', '^')
-- map('', '<C-e>', '$')

-- Transpose word
-- map('', 'L', 'daWWPB')
-- map('', 'H', 'daWBPB')
-- map('', 'M', '2dWBhP')

-- Move lines

map('n', '<A-k>', ":m .-2<CR>==", silent)
map('n', '<A-j>', ":m .+1<CR>==", silent)
map('x', '<A-k>', ":m '<-2<CR>gv=gv", silent)
map('x', '<A-j>', ":m '>+1<CR>gv=gv", silent)

map('n', '<A-h>', ':SidewaysLeft<CR>', silent)
map('n', '<A-l>', ':SidewaysRight<CR>', silent)

-- Textobjects for inside and around arguments/lists,paramater constraints
map({ "x", "o" }, 'aa', '<Plug>SidewaysArgumentTextobjA', silent)
map({ "x", "o" }, 'a,', '<Plug>SidewaysArgumentTextobjA', silent)

map({ "x", "o" }, 'ia', '<Plug>SidewaysArgumentTextobjI', silent)
map({ "x", "o" }, 'i,', '<Plug>SidewaysArgumentTextobjI', silent)

map({ "x", "o" }, 'i,', '<Plug>SidewaysArgumentTextobjI', silent)

-- map('x', 'x', ':lua require"treesitter-unit".select()<CR>',      silent)
-- map('o', 'x', ':<c-u>lua require"treesitter-unit".select()<CR>', silent)
-- map('n', 'X', ':lua require"treesitter-unit".select()<CR>', silent)

-- Toggle bool
map('n', 'gb', '<cmd>lua require"toggle".toggle()<CR>')

-- Folding
for i = 1, 9 do
  local o = vim.o
  map('n', 'z' .. i, function() o.foldlevel = i - 1 print("Foldlevel: ", o.foldlevel) end)
end

map('n', 'z-', ':set foldlevel-=1 | echo "Foldlevel: " . &foldlevel<CR>', silent)
map('n', 'z+', ':set foldlevel+=1 | echo "Foldlevel: " . &foldlevel<CR>', silent)

-- Indent whole buffer
map('n', '<leader>ci', 'mggg=G`g')

-- Dev utils
map('n', '<leader>xx', '<cmd>lua require"config.dev_utils".save_and_exec()<CR>')

map('n', '<leader><cr>', ':ToggleCheckbox<CR>')

-- DAP
-- Rust
map('n', '<leader>rr', ':RustRunnables<CR>')
map('n', '<leader>rd', ':RustDebuggables<CR>')
map('n', '<leader>ru', ':RustParentModule<CR>')
map('n', '<leader>ro', ':RustOpenCargo<CR>')

map("n", "<C-a>", require("dial.map").inc_normal(), { noremap = true })
map("n", "<C-x>", require("dial.map").dec_normal(), { noremap = true })
map("v", "<C-a>", require("dial.map").inc_visual(), { noremap = true })
map("v", "<C-x>", require("dial.map").dec_visual(), { noremap = true })
map("v", "g<C-a>", require("dial.map").inc_gvisual(), { noremap = true })
map("v", "g<C-x>", require("dial.map").dec_gvisual(), { noremap = true })

-- Asterisk
map('n', '*', '<Plug>(asterisk-z*)')
map('n', '#', '<Plug>(asterisk-z#)')
map('n', 'g*', '<Plug>(asterisk-gz*)')
map('n', 'g#', '<Plug>(asterisk-gz#)')
-- map *  <Plug>(asterisk-z*)
-- map #  <Plug>(asterisk-z#)
-- map g* <Plug>(asterisk-gz*)
-- map g# <Plug>(asterisk-gz#)
