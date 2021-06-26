local function map(mod, lhs, rhs, opt)
  vim.api.nvim_set_keymap(mod, lhs, rhs, opt or {})
end

local silent = { silent = true }

vim.g.mapleader = ' '

map('n', '<leader>f',  ':NvimTreeFindFile<CR>')
map('n', '<leader>pe', ':NvimTreeToggle<CR>')
map('n', '<leader>po', ':AerialToggle<CR>')

-- -- Fzf
-- map('n', '<leader><leader>', ':Files<CR>')
-- map('n', '<leader>,',        ':Buffers<CR>')
-- map('n', '<leader>/',        ':BLines<CR>')
-- map('n', '<leader>rg',       ':Rg<CR>')
-- map('n', '<leader>o',        ':Files<CR>')
-- map('n', '<leader>O',        ':Files<CR>')
-- map('n', '<leader>gl',       ':Commits<CR>')
-- map('n', '<leader>gs',       ':GFiles?<CR>')
-- map('n', '<leader>o',        ':DocumentSymbols<CR>')
-- map('n', '<leader>O',        ':WorkspaceSymbols<CR>')
-- map('n', '<leader>d',        ':Diagnostics<CR>')
-- map('n', '<leader>D',        ':DiagnosticsAll<CR>')

-- Telescope
map('n', '<leader><leader>', ':Telescope find_files<CR>')
map('n', '<leader>,',        ':Telescope buffers<CR>')
map('n', '<leader>/',        ':Telescope current_buffer_fuzzy_find<CR>')
map('n', '<leader>rg',       ':Telescope live_grep<CR>')
map('n', '<leader>o',        ':Telescope lsp_document_symbols<CR>')
map('n', '<leader>O',        ':Telescope lsp_workspace_symbols<CR>')
map('n', '<leader>gl',       ':Telescope git_commits<CR>')
map('n', '<leader>gs',       ':Telescope git_status<CR>')
map('n', '<leader>pp',       ':Telescope session-lens search_session<CR>')
map('n', '<leader>d',        ':Telescope lsp_document_symbols<CR>')
map('n', '<leader>D',        ':Telescope lsp_workspace_diagnostics<CR>')
map('n', '<leader>a',        ':Telescope lsp_code_actions theme=get_dropdown<CR>')
map('n', 'gr',               ':Telescope lsp_references<CR>')

-- map('n', '<leader><leader>', '<cmd>lua require"telescope.builtin".find_files()<CR>')
-- map('n', '<leader>,          ', '<cmd>lua require"telescope.builtin".buffers()<CR>')
-- map('n', '<leader>/',        '<cmd>lua require"telescope.builtin".current_buffer_fuzzy_find(require"telescope.themes".get_dropdown({}))<CR>')
-- map('n', '<leader>rg',       '<cmd>lua require"telescope.builtin".live_grep(require"telescope.themes".get_dropdown({}))<CR>')
-- map('n', '<leader>o',        '<cmd>lua require"telescope.builtin".lsp_document_symbols(require"telescope.themes".get_dropdown({}))<CR>')
-- map('n', '<leader>O',        '<cmd>lua require"telescope.builtin".lsp_workspace_symbols(require"telescope.themes".get_dropdown({}))<CR>')
-- map('n', '<leader>gl',       '<cmd>lua require"telescope.builtin".git_commits(require"telescope.themes".get_dropdown({}))<CR>')


-- Quickfix and location list
map('n', '<leader>ll', '<cmd>lua require"qf".open("l")<CR>') -- Open location list
map('n', '<leader>lo', '<cmd>lua require"qf".open("l")<CR>') -- Open location list
map('n', '<leader>lc', '<cmd>lua require"qf".close("l")<CR>') -- Close location list
map('n', '<leader>lt', '<cmd>lua require"qf".toggle("l", true)<CR>') -- Toggle location list and stay in current window

map('n', '<leader>co', '<cmd>lua require"qf".open("c")<CR>') -- Open quickfix list
map('n', '<leader>cc', '<cmd>lua require"qf".close("c")<CR>') -- Close quickfix list
map('n', '<leader>cl', '<cmd>lua require"qf".toggle("c", true)<CR>') --Toggle quickfix list and stay in current window

map('v', 'gl', ':<c-u>lua require"config.onlines"()<CR>')

map('n', '<leader>j', '<cmd>lua require"qf".below("l")<CR>') -- Go to next location list entry from cursor
map('n', '<leader>k', '<cmd>lua require"qf".above("l")<CR>') -- Go to previous location list entry from cursor

map('n', '<leader>J', '<cmd>lua require"qf".below("c")<CR>') -- Go to next quickfix entry from cursor
map('n', '<leader>K', '<cmd>lua require"qf".above("c")<CR>') -- Go to previous quickfix entry from cursor
map('n', ']q', '<cmd>lua require"qf".below("visible")<CR>') -- Go to next quickfix entry from cursor
map('n', '[q', '<cmd>lua require"qf".above("visible")<CR>') -- Go to previous quickfix entry from cursor

-- Dispatching
map('n', '<leader>eb', '<cmd>lua require"config.dispatch".dispatch("build")<CR>')
map('n', '<leader>er', '<cmd>lua require"config.dispatch".dispatch("run")<CR>')
map('n', '<leader>et', '<cmd>lua require"config.dispatch".dispatch("test")<CR>')
map('n', '<leader>el', '<cmd>lua require"config.dispatch".dispatch("lint")<CR>')
map('n', '<leader>ec', '<cmd>lua require"config.dispatch".dispatch("check")<CR>')

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

map('n', '<A-q>',      ':BufferClose<CR>')
map('n', '<leader>bk', ':BufferClose<CR>')
map('n', '<leader>bo', ':BufferCloseAllButCurrent<CR>')
map('n', '<leader>bp', '<C-^>')

-- Window mappings
map('n', '<leader>wo', '<C-w>o')
map('n', '<leader>ws', '<C-w>s')
map('n', '<leader>wv', '<C-w>v')
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
map('n', '<leader>w|', '<C-w>|')
map('n', '<leader>w_', '<C-w>_')

map('n', '<leader>w+', ':vertical resize +20 | :resize +20<CR>')
map('n', '<leader>w-', ':vertical resize -20 | :resize -20<CR>')

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
map('n', '<leader>gg',  ':Ge :<CR>')
map('n', '<leader>ga',  ':Git add %<CR>')
map('n', '<leader>gc',  ':Git commit<CR>')
map('n', '<leader>gpp', ':Git push<CR>')
map('n', '<leader>gpf', ':Git push --force<CR>')
map('n', '<leader>gf',  ':Git fetch<CR>')

-- Search highlighting
map('n', 'n',  '<plug>(searchhi-n)')
map('n', 'N',  '<plug>(searchhi-N)')
map('n', '*',  '<plug>(searchhi-*)')
map('n', 'g*', '<plug>(searchhi-g*)')
map('n', '#',  '<plug>(searchhi-#)')
map('n', 'g#', '<plug>(searchhi-g#)')
map('n', 'gd', '<plug>(searchhi-gd)')
map('n', 'gD', '<plug>(searchhi-gD)')

map('v', 'n',  '<plug>(searchhi-v-n)')
map('v', 'N',  '<plug>(searchhi-v-N)')
map('v', '*',  '<plug>(searchhi-v-*)')
map('v', 'g*', '<plug>(searchhi-v-g*)')
map('v', '#',  '<plug>(searchhi-v-#)')
map('v', 'g#', '<plug>(searchhi-v-g#)')
map('v', 'gd', '<plug>(searchhi-v-gd)')
map('v', 'gD', '<plug>(searchhi-v-gD)')

map('n', '<Esc>', '<plug>(searchhi-clear-all)')

-- Easy align
map('x', 'ga', '<plug>(EasyAlign)')
map('n', 'ga', '<plug>(EasyAlign)')

-- Snippet expansion
map('i', '<C-l>', 'vsnip#available(1) ? "<plug>(vsnip-expand-or-jump)" : "<C-l>"', { expr = true})
map('n', '<C-l>', 'vsnip#available(1) ? "<plug>(vsnip-expand-or-jump)" : "<C-l>"', { expr = true})

-- Completion
map('i', '<tab>', '<Plug>(completion_smart_tab)')
map('i', '<s-tab>', '<Plug>(completion_smart_s_tab)')

-- Movements
map('', '<C-j>', '}', { noremap = true })
map('', '<C-k>', '{', { noremap = true })

map('', '<C-e>', '$')
map('', '<C-b>', '^')

map('i', '<C-e>', '<C-o>$')
map('i', '<C-b>', '<C-o>^')
map('i', '<C-a>', '<C-o>^')

-- Move lines
map('n', '<A-k>', ':m .-2<CR>', silent)
map('n', '<A-j>', ':m .+1<CR>', silent)

map('v', '<A-k>', ':m \'<-2<CR>gv', silent)
map('v', '<A-j>', ':m \'>+1<CR>gv', silent)

map('n', '<A-h>', ':SidewaysLeft<CR>', silent)
map('n', '<A-l>', ':SidewaysRight<CR>', silent)

-- Textobjects for inside and around arguments/lists,paramater constraints
map('o', 'a,', '<Plug>SidewaysArgumentTextobjA', silent)
map('x', 'a,', '<Plug>SidewaysArgumentTextobjA', silent)

map('o', 'i,', '<Plug>SidewaysArgumentTextobjI', silent)
map('x', 'i,', '<Plug>SidewaysArgumentTextobjI', silent)

-- Toggle bool
map('n', 'gb', '<cmd>lua require"toggle".toggle()<CR>')

-- Folding
for i = 1, 9 do
  map('n', 'z' .. i, ':set foldlevel='.. i-1 ..'<CR>')
end

-- Indent whole buffer
map('n', '<leader>ci', 'mggg=G`g')

-- Dev utils
map('n', '<leader>xx', '<cmd>lua require"config.dev_utils".save_and_exec()<CR>')

map('n', '<leader><cr>', ':ToggleCheckbox<CR>')

-- Make Y behave like D and C
map('n', 'Y', 'y$')
