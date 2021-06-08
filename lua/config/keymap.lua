local function map(mod, lhs, rhs, opt)
  vim.api.nvim_set_keymap(mod, lhs, rhs, opt or {})
end

vim.g.mapleader = ' '

map('n', '<leader>f', ':NvimTreeFindFile<CR>')

-- Telescope
map('n', '<leader><leader>', '<cmd>lua require"telescope.builtin".find_files()<CR>')
map('n', '<leader>,          ', '<cmd>lua require"telescope.builtin".buffers()<CR>')
map('n', '<leader>rg',       '<cmd>lua require"telescope.builtin".live_grep()<CR>')
map('n', '<leader>p',        '<cmd>lua require"telescope".extensions.project.project{}<CR>')
map('n', '<leader>o',        '<cmd>lua require"telescope.builtin".lsp_document_symbols()<CR>')
map('n', '<leader>O',        '<cmd>lua require"telescope.builtin".lsp_workspace_symbols()<CR>')
map('n', '<leader>a',        '<cmd>lua require"telescope.builtin".lsp_code_actions()<CR>')
map('n', '<leader>gl',       '<cmd>lua require"telescope.builtin".git_commits()<CR>')

-- Quickfix and location list
map('n', '<leader>l', '<cmd>lua require"qf".open("l")<CR>') -- Open location list
-- map('n', '<leader>lc', '<cmd>lua require"qf".close("l")<CR>') -- Close location list
-- map('n', '<leader>lt', '<cmd>lua require"qf".toggle("l", true)<CR>') -- Toggle location list and stay in current window

map('n', '<leader>co', '<cmd>lua require"qf".open("c")<CR>') -- Open quickfix list
map('n', '<leader>cc', '<cmd>lua require"qf".close("c")<CR>') -- Close quickfix list
map('n', '<leader>cl', '<cmd>lua require"qf".toggle("c", true)<CR>') --Toggle quickfix list and stay in current window

map('n', '<leader>j', '<cmd>lua require"qf".below("l")<CR>') -- Go to next location list entry from cursor
map('n', '<leader>k', '<cmd>lua require"qf".above("l")<CR>') -- Go to previous location list entry from cursor

map('n', '<leader>J', '<cmd>lua require"qf".below("c")<CR>') -- Go to next quickfix entry from cursor
map('n', '<leader>K', '<cmd>lua require"qf".above("c")<CR>') -- Go to previous quickfix entry from cursor

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
map('n', '<leader>bo', ':BufferCloseAllButCurrent<CR>')

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

map('n', '<leader>w<C-h>', '<C-w>h<C-w>q')
map('n', '<leader>w<C-j>', '<C-w>j<C-w>q')
map('n', '<leader>w<C-k>', '<C-w>k<C-w>q')
map('n', '<leader>w<C-l>', '<C-w>l<C-w>q')

-- Sneak (easyclip conflict mappings)
map('n', 'f', '<plug>Sneak_f')
map('n', 'F', '<plug>Sneak_F')
map('n', 't', '<plug>Sneak_t')
map('n', 'T', '<plug>Sneak_T')
map('n', 's', '<plug>Sneak_s')
map('n', 'S', '<plug>Sneak_S')

-- Git mappings
map('n', '<leader>gg', ':Ge :<CR>')
map('n', '<leader>ga', ':Git add %<CR>')
map('n', '<leader>gc', ':Git commit<CR>')
map('n', '<leader>gpp', ':Git push<CR>')
map('n', '<leader>gpf', ':Git push --force<CR>')
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

map('v', 'n', '<plug>(searchhi-v-n)')
map('v', 'N', '<plug>(searchhi-v-N)')
map('v', '*', '<plug>(searchhi-v-*)')
map('v', 'g*', '<plug>(searchhi-v-g*)')
map('v', '#', '<plug>(searchhi-v-#)')
map('v', 'g#', '<plug>(searchhi-v-g#)')
map('v', 'gd', '<plug>(searchhi-v-gd)')
map('v', 'gD', '<plug>(searchhi-v-gD)')

map('n', '<Esc>', '<plug>(searchhi-clear-all)')

-- Easy align
map('x', 'ga', '<plug>(EasyAlign)')
map('n', 'ga', '<plug>(EasyAlign)')


-- Movements
map('', '<C-j>', '}')
map('', '<C-k>', '{')

map('', '<C-e>', '$')
map('', '<C-b>', '^')

map('i', '<C-e>', '<C-o>$')
map('i', '<C-b>', '<C-o>^')

-- Move lines
map('n', '<A-k>', ':m .-2<CR>')
map('n', '<A-j>', ':m .+1<CR>')

map('v', '<A-k>', ':m \'<-2<CR>gv')
map('v', '<A-j>', ':m \'>+1<CR>gv')

-- Toggle bool
map('n', 'gb', '<cmd>lua require"toggle".toggle()<CR>')

-- Folding
for i = 0, 9 do
  map('n', 'z'..i, ':set foldlevel='..i..'<CR>')
end

-- Indent whole buffer
map('n', '<leader>ci', 'mggg=G`g')

-- Dev utils
map('n', '<leader>xx', '<cmd>lua require"config.dev_utils".save_and_exec()<CR>')

map('n', '<leader><cr>', ':ToggleCheckbox<CR>')

-- Make Y behave like D and C
map('n', 'Y', 'y$')
