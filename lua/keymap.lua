function map(mod, lhs, rhs, opt)
  vim.api.nvim_set_keymap(mod, lhs, rhs, opt or {})
end

vim.g.mapleader = ' '

map('n', '<leader>f', ':NvimTreeOpen<CR>')

-- Barbar
map('n', '<A-,>', ':BufferPrevious<CR>')
map('n', '<A-.>', ':BufferNext<CR>')
map('n', '<A-<>', ':BufferMovePrevious<CR>')
map('n', '<A->>', ':BufferMoveNext<CR>')

map('n', '<A-1>', ':BufferGoto 1<CR>')
map('n', '<A-2>', ':BufferGoto 2<CR>')
map('n', '<A-3>', ':BufferGoto 3<CR>')
map('n', '<A-4>', ':BufferGoto 4<CR>')
map('n', '<A-5>', ':BufferGoto 5<CR>')
map('n', '<A-6>', ':BufferGoto 6<CR>')
map('n', '<A-7>', ':BufferGoto 7<CR>')
map('n', '<A-8>', ':BufferGoto 8<CR>')
map('n', '<A-9>', ':BufferLast<CR>')

map('n', '<A-q>', ':BufferClose<CR>')
map('n', '<leader>bk', ':BufferClose<CR>')
map('n', '<leader>bo', 'BufferCloseAllButCurrent<CR>')

-- Window mappings
map('n', '<leader>wo', '<C-w>o')
map('n', '<leader>wq', '<C-w>q')
map('n', '<leader>wp', '<C-w>P')
map('n', '<leader>wH', '<C-w>H')
map('n', '<leader>wJ', '<C-w>J')
map('n', '<leader>wK', '<C-w>K')
map('n', '<leader>wL', '<C-w>L')
map('n', '<leader>wh', '<C-w>h')
map('n', '<leader>wj', '<C-w>j')
map('n', '<leader>wk', '<C-w>k')
map('n', '<leader>wl', '<C-w>l')
map('n', '<leader>w=', '<C-w>=')

-- Git mappings
map('n', '<leader>gg', ':Ge :<CR>')
map('n', '<leader>ga', ':Git add %<CR>')
map('n', '<leader>gc', ':Git commit<CR>')
map('n', '<leader>gp', ':Git push<CR>')
map('n', '<leader>gf', ':Git fetch<CR>')

-- Movements
map('', '<C-j>', '}')
map('', '<C-k>', '{')

map('', '<C-e>', '$')
map('', '<C-a>', '^')

map('i', '<C-e>', '<C-o>$')
map('i', '<C-a>', '<C-o>^')

-- Move lines
map('n', '<A-j>', ':m .-1<CR>==')
map('n', '<A-k>>', ':m .+1<CR>==')

map('v', '<A-j>', ':m \'>-1<CR>==')
map('v', '<A-k>', ':m \'<+1<CR>==')

-- Folding
for i = 0, 9 do
  map('n', 'z'..i, ':set foldlevel='..i..'<CR>')
end
