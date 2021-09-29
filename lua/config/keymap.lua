local function map(mod, lhs, rhs, opt)
  vim.api.nvim_set_keymap(mod, lhs, rhs, opt or {})
end

local silent = { silent = true }

vim.g.mapleader = ' '

map('n', '<leader>f',  ':Vaffle %<CR>')
map('n', '<leader>pe', ':Vaffle<CR>')
map('n', '<leader>po', ':AerialToggle<CR>')

-- -- Fzf
-- map('n', '<leader><leader>', ':Files<CR>')
-- map('n', '<leader>,',        ':Buffers<CR>')
-- map('n', '<leader>/',        ':BLines<CR>')
-- map('n', '<leader>?',        ':BLines<CR>')
-- map('n', '<leader>rg',       ':Rg<CR>')
-- map('n', '<leader>o',        ':Files<CR>')
-- map('n', '<leader>O',        ':Files<CR>')
-- map('n', '<leader>gl',       ':Commits<CR>')
-- map('n', '<leader>gs',       ':GFiles?<CR>')
-- map('n', '<leader>a',        ':CodeActions<CR>')
-- map('n', '<leader>o',        ':DocumentSymbols<CR>')
-- map('n', '<leader>O',        ':WorkspaceSymbols<CR>')
-- map('n', '<leader>dd',       ':Diagnostics<CR>')
-- map('n', '<leader>D',        ':DiagnosticsAll<CR>')

-- Telescope
map('n', '<leader><leader>', ':Telescope find_files<CR>')
map('n', '<leader>,',        ':Telescope buffers<CR>')
map('n', '<leader>/',        ':Telescope current_buffer_fuzzy_find<CR>')
map('n', '<leader>/',        ':Telescope current_buffer_fuzzy_find<CR>')
map('n', '<leader>rg',       ':Telescope live_grep<CR>')
map('n', '<leader>gl',       ':Telescope git_commits<CR>')
map('n', '<leader>gs',       ':Telescope git_status<CR>')
map('n', '<leader>a',        ':Telescope lsp_code_actions<CR>')
map('n', '<leader>o',        ':Telescope lsp_document_symbols<CR>')
map('n', '<leader>O',        ':Telescope lsp_dynamic_workspace_symbols<CR>')
map('n', '<leader>dd',       ':Telescope lsp_document_diagnostics<CR>')
map('n', '<leader>D',        ':Telescope lsp_workspace_diagnostics<CR>')
map('n', '<leader>pp',       ':SearchSession<CR>')

-- Quickfix and location list
map('n', '<leader>ll', ':Lopen<CR>', silent) -- Open location list
map('n', '<leader>lo', ':Lopen true<CR>', silent) -- Open location list
map('n', '<leader>lc', ':Lclose<CR>', silent) -- Close location list
map('n', '<leader>lt', ':Ltoggle true<CR>', silent) -- Toggle location list and stay in current window

map('n', '<leader>co', ':Qopen<CR>', silent) -- Open quickfix list
-- map('n', '<leader>co', '<cmd>lua require"qf".open("c")<CR>') -- Open quickfix list
map('n', '<leader>cc', ':Qclose<CR>', silent) -- Close quickfix list
map('n', '<leader>C', ':Qclose<CR>', silent) -- Close quickfix list
map('n', '<leader>ct', ':Qtoggle true<CR>', silent) --Toggle quickfix list and stay in current window


map('n', '<leader>j', ':Lbelow<CR>', silent) -- Go to next location list entry from cursor
map('n', '<leader>k', ':Labove<CR>', silent) -- Go to previous location list entry from cursor

map('n', '<leader>J', ':Qbelow<CR>', silent) -- Go to next quickfix entry from cursor
map('n', '<leader>K', ':Qabove<CR>', silent) -- Go to previous quickfix entry from cursor
map('n', ']q', '<cmd>lua require"qf".below("visible")<CR>', silent) -- Go to next quickfix entry from cursor
map('n', '[q', '<cmd>lua require"qf".above("visible")<CR>', silent) -- Go to previous quickfix entry from cursor

map('v', 'gl', ':<c-u>lua require"config.onlines"()<CR>', silent)
-- Dispatching
map('n', '<leader>eb', '<cmd>lua require"config.dispatch".dispatch("build")<CR>')
map('n', '<leader>er', '<cmd>lua require"config.dispatch".dispatch("run")<CR>')
map('n', '<leader>et', '<cmd>lua require"config.dispatch".dispatch("test")<CR>')
map('n', '<leader>el', '<cmd>lua require"config.dispatch".dispatch("lint")<CR>')
map('n', '<leader>ec', '<cmd>lua require"config.dispatch".dispatch("check")<CR>')

-- Barbar
-- map('n', '<A-,>', ':BufferPrevious<CR>')
-- map('n', '<A-.>', ':BufferNext<CR>')
-- map('n', '<A-<>', ':BufferMovePrevious<CR>')
-- map('n', '<A->>', ':BufferMoveNext<CR>')

-- map('n', '<A-1>', ':BufferGoto 1<CR>')
-- map('n', '<A-2>', ':BufferGoto 2<CR>')
-- map('n', '<A-3>', ':BufferGoto 3<CR>')
-- map('n', '<A-4>', ':BufferGoto 4<CR>')
-- map('n', '<A-5>', ':BufferGoto 5<CR>')
-- map('n', '<A-6>', ':BufferGoto 6<CR>')
-- map('n', '<A-7>', ':BufferGoto 7<CR>')
-- map('n', '<A-8>', ':BufferGoto 8<CR>')
-- map('n', '<A-9>', ':BufferLast<CR>')

-- Tabs
map('n', '<leader>N', ':tabnew<CR>')
map('n', '<leader>S', ':tab split<CR>')
map('n', '<leader>Q', ':tabclose<CR>')

for i = 0,9 do
map('n', '<leader>' .. i , i .. 'gt')
map('n', '<A-' .. i .. '>', i .. 'gt')
map('!', '<A-' .. i .. '>', '<ESC>' .. i .. 'gt')
map('t', '<A-' .. i .. '>', '<C-\\><C-n>' .. i .. 'gt')
end

map('n', '<A-,>', ':tabprevious<CR>')
map('n', '<A-.>', ':tabnext<CR>')

-- Buffers
map('n', '<leader>bk', ':lua require"config.bclose".close()<CR>')
map('n', '<leader>bo', ':lua require"config.bclose".close_hidden()<CR>')
map('n', '<leader>bp', '<C-^>')

-- Window mappings
map('n', '<leader>w=', '<C-w>=')
map('n', '<leader>wH', '<C-w>H')
map('n', '<leader>wJ', '<C-w>J')
map('n', '<leader>wK', '<C-w>K')
map('n', '<leader>wL', '<C-w>L')
map('n', '<leader>wR', '<C-w>R')
map('n', '<leader>w_', '<C-w>_')
map('n', '<leader>wh', '<C-w>h')
map('n', '<leader>wj', '<C-w>j')
map('n', '<leader>wk', '<C-w>k')
map('n', '<leader>wl', '<C-w>l')
map('n', '<leader>wo', '<C-w>o')
map('n', '<leader>wp', '<C-w>p')
map('n', '<leader>wq', '<C-w>q')
map('n', '<leader>wr', '<C-w>r')
map('n', '<leader>ws', '<C-w>s')
map('n', '<leader>wv', '<C-w>v')
map('n', '<leader>w|', '<C-w>|')

map('n', '<leader>w+', ':vertical resize +20 | :resize +20<CR>')
map('n', '<leader>w-', ':vertical resize -20 | :resize -20<CR>')

map('n', '<leader>w<C-h>', '<C-w>h<C-w>q')
map('n', '<leader>w<C-j>', '<C-w>j<C-w>q')
map('n', '<leader>w<C-k>', '<C-w>k<C-w>q')
map('n', '<leader>w<C-l>', '<C-w>l<C-w>q')

map('n', '<leader>ww', ':WindowPick<CR>')
map('n', '<leader>W',  ':WindowSwap<CR>')

map('', '<C-p>', '"0p')

-- map('',  's',     ':HopChar1<CR>')
-- map('',  'S',     ':HopWord<CR>')
-- map('',  'S',     ':HopWord<CR>')
-- map('v', '<C-s>', ':HopWord<CR>')
-- map('',  '\\',    ':HopLines<CR>')
-- map('', 'f', ':HopChar1AC<CR>')
-- map('', 'F', ':HopChar1BC<CR>')
-- map('', 't', ':HopChar1AC<CR>')
-- map('', 'T', ':HopChar1AC<CR>')

-- Git mappings
map('n', '<leader>gg',  ':Ge :<CR>')
map('n', '<leader>gd',  ':G difftool --name-status<CR>')
map('n', '<leader>ga',  ':Git add %<CR>')
map('n', '<leader>gS',  ':Git stage .<CR>')
map('n', '<leader>gc',  ':Git commit<CR>')
map('n', '<leader>gpp', ':Git push<CR>')
map('n', '<leader>gpf', ':Git push --force<CR>')
map('n', '<leader>gf',  ':Git pull<CR>')

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

-- Clear search highlight
map('n', '<Esc>', '<plug>(searchhi-clear-all)')

-- Easy align
map('x', 'ga', '<plug>(EasyAlign)')
map('n', 'ga', '<plug>(EasyAlign)')

-- Snippet expansion
map('i', '<C-l>', 'vsnip#available(1) ? "<plug>(vsnip-expand-or-jump)" : "<C-l>"', { expr = true})
map('n', '<C-l>', 'vsnip#available(1) ? "<plug>(vsnip-expand-or-jump)" : "<C-l>"', { expr = true})

-- map('i', '<Tab>', 'vsnip#available(1) ? "<plug>(vsnip-expand-or-jump)" : "<Tab>"', { expr = true})
-- map('s', '<Tab>', 'vsnip#available(1) ? "<plug>(vsnip-expand-or-jump)" : "<Tab>"', { expr = true})

-- Movements
map('', '<C-j>', '}', { noremap = true })
map('', '<C-k>', '{', { noremap = true })
map('', '<C-5>', '<C-o>%', { noremap = true })

map('', '<C-e>', '$')
map('', '<C-b>', '^')

-- Readline like
map('i', '<C-e>', '<C-o>$')
map('i', '<C-b>', '<C-o>^')
map('i', '<C-a>', '<C-o>^')
map('i', '<C-a>', '<C-o>^')
map('i', '<A-b>', '<C-o>b')
map('i', '<A-f>', '<C-o>w')

-- Transpose word
-- map('', 'L', 'daWWPB')
-- map('', 'H', 'daWBPB')
-- map('', 'M', '2dWBhP')

-- Move lines
map('n', '<A-k>', ':m .-2<CR>==', silent)
map('n', '<A-j>', ':m .+1<CR>==', silent)

map('v', '<A-k>', ':m \'<-2<CR>gv', silent)
map('v', '<A-j>', ':m \'>+1<CR>gv', silent)

map('n', '<A-h>', ':SidewaysLeft<CR>', silent)
map('n', '<A-l>', ':SidewaysRight<CR>', silent)

-- Textobjects for inside and around arguments/lists,paramater constraints
map('o', 'aa', '<Plug>SidewaysArgumentTextobjA', silent)
map('x', 'aa', '<Plug>SidewaysArgumentTextobjA', silent)
map('x', 'aa', '<Plug>SidewaysArgumentTextobjA', silent)
map('o', 'a,', '<Plug>SidewaysArgumentTextobjA', silent)
map('x', 'a,', '<Plug>SidewaysArgumentTextobjA', silent)

map('o', 'ia', '<Plug>SidewaysArgumentTextobjI', silent)
map('x', 'ia', '<Plug>SidewaysArgumentTextobjI', silent)
map('o', 'i,', '<Plug>SidewaysArgumentTextobjI', silent)
map('x', 'i,', '<Plug>SidewaysArgumentTextobjI', silent)

map('o', 'i,', '<Plug>SidewaysArgumentTextobjI', silent)
map('x', 'i,', '<Plug>SidewaysArgumentTextobjI', silent)

map('v', 'x', ':lua require"treesitter-unit".select()<CR>',      silent)
map('o', 'x', ':<c-u>lua require"treesitter-unit".select()<CR>', silent)
map('n', 'X', ':lua require"treesitter-unit".select()<CR>', silent)

-- Select all
map('', 'vA', 'ggVG');

-- Toggle bool
map('n', 'gb', '<cmd>lua require"toggle".toggle()<CR>')

-- Folding
for i = 1, 9 do
  map('n', 'z' .. i, ':set foldlevel='.. i ..'| echo "Foldlevel: " . &foldlevel<CR>', silent)
end

map('n', 'z-', ':set foldlevel-=1 | echo "Foldlevel: " . &foldlevel<CR>', silent)
map('n', 'z=', ':set foldlevel+=1 | echo "Foldlevel: " . &foldlevel<CR>', silent)

-- Indent whole buffer
map('n', '<leader>ci', 'mggg=G`g')

-- Dev utils
map('n', '<leader>xx', '<cmd>lua require"config.dev_utils".save_and_exec()<CR>')

map('n', '<leader><cr>', ':ToggleCheckbox<CR>')

-- Make Y behave like D and C
map('n', 'Y', 'y$')

map('', '<leader>dn', ':lua require"config.dbg".dap.step_over()<CR>')
map('', '<leader>dl', ':lua require"config.dbg".dap.step_into()<CR>')
map('', '<leader>dh', ':lua require"config.dbg".dap.step_out()<CR>')
map('', '<leader>dj', ':lua require"config.dbg".dap.down()<CR>')
map('', '<leader>dk', ':lua require"config.dbg".dap.up()<CR>')
map('', '<leader>ds', ':lua require"config.dbg".dap.pause()<CR>')
map('', '<leader>dQ', ':lua require"config.dbg".dap.close()<CR>')

map('', '<leader>db', ':lua require"config.dbg".dap.toggle_breakpoint()<CR>')
map('', '<leader>dB', ':lua require"config.dbg".dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))()<CR>')
map('', '<leader>deb', ':lua require"config.dbg".dap.set_exception_breakpoints()<CR>')


map('', '<leader>dc', ':lua require"config.dbg".dap.continue()<CR>')
map('', '<leader>dr', ':lua require"config.dbg".dap.run_last()<CR>')
map('', '<leader>dg', ':lua require"config.dbg".dap.run_to_cursor()<CR>')
map('', '<leader>dO', ':lua require"config.dbg".dap.repl_open()<CR>')
map('', '<leader>do', ':lua require"config.dbg".ui.toggle()<CR>')

map('', '<leader>dlv', ':Telescope dap variables<CR>')
map('', '<leader>dlb', ':Telescope dap list_breakpoints<CR>')
map('', '<leader>dlf', ':Telescope dap frames<CR>')
map('', '<leader>dlc', ':Telescope dap commands<CR>')

map('', '<F5>', ':lua require"config.dbg".dap.continue()<CR>' )
map('', '<F10>', ':lua require"config.dbg".dap.step_over()<CR>' )
map('', '<F11>', ':lua require"config.dbg".dap.step_into()<CR>' )
map('', '<F12>', ':lua require"config.dbg".dap.step_out()<CR>' )

    -- nnoremap <silent> <F5> :lua require'dap'.continue()<CR>
    -- nnoremap <silent> <F10> :lua require'dap'.step_over()<CR>
    -- nnoremap <silent> <F11> :lua require'dap'.step_into()<CR>
    -- nnoremap <silent> <F12> :lua require'dap'.step_out()<CR>
    -- nnoremap <silent> <leader>b :lua require'dap'.toggle_breakpoint()<CR>
    -- nnoremap <silent> <leader>B :lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
    -- nnoremap <silent> <leader>lp :lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
    -- nnoremap <silent> <leader>dr :lua require'dap'.repl.open()<CR>
    -- nnoremap <silent> <leader>dl :lua require'dap'.run_last()<CR>

-- -- GDB
-- map('n', '<leader>dr', ':Run<CR>')
-- map('n', '<leader>dn', ':Over<CR>')
-- map('n', '<leader>di', ':Step<CR>')
-- map('n', '<leader>db', ':Break<CR>')
-- map('n', '<leader>dB', ':Clear<CR>')
-- map('n', '<leader>df', ':Finish<CR>')
-- map('n', '<leader>dc', ':Continue<CR>')
