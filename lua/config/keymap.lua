local function map(mod, lhs, rhs, opt)
  vim.api.nvim_set_keymap(mod, lhs, rhs, opt or {})
end

local silent = { silent = true }

vim.g.mapleader = ' '

-- map('n', '<leader>f',  ':Vaffle %<CR>')
map('n', '<leader>pe', ':call execute("edit " . expand("%:p:h"))<CR>')
map('n', '<leader>f', ':lua require"lir.float".init()<CR>')
map('n', '<leader>po', ':AerialOpen<CR>')

-- Fzf
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
map('n',    '<leader><leader>', ':Telescope find_files<CR>')
-- map('n',    '<leader>f',        '<cmd>lua require "telescope".extensions.file_browser.file_browser { path="%:p:h" }<CR>')
map('n',    '<leader>rf',       ':Telescope oldfiles<CR>')
map('n',    '<M-x>',            ':Telescope command_history<CR>')
-- map('n',    '<leader>ro',       ':Telescope oldfiles<CR>')
map('n',    '<leader>,',        ':Telescope buffers<CR>')
map('n',    '<leader>/',        ':Telescope current_buffer_fuzzy_find<CR>')
map('n',    '<leader>/',        ':Telescope current_buffer_fuzzy_find<CR>')
map('n',    '<leader>rg',       ':Telescope live_grep<CR>')
map('n',    '<leader>gl',       ':Telescope git_commits<CR>')
map('n',    '<leader>gs',       ':Telescope git_status<CR>')
map('n',    '<leader>o',        ':Telescope lsp_document_symbols<CR>')
map('n',    '<leader>O',        ':Telescope lsp_dynamic_workspace_symbols<CR>')
map('n',    '<leader>dd',       ':Telescope lsp_document_diagnostics<CR>')
map('n',    '<leader>D',        ':Telescope diagnostics<CR>')
map('n',    '<leader>pp',       ":lua require'telescope'.extensions.project.project{ display_type = 'full' }<CR>")

-- Harpoon
map('n', '<leader>ha', ':lua require("harpoon.mark").add_file()<CR>')
map('n', '<leader>ho', ':lua require("harpoon.ui").toggle_quick_menu()<CR>')
map('n', '<leader>hh', ':lua require("harpoon.ui").toggle_quick_menu()<CR>')
map('n', '<leader>ht', ':lua require("harpoon.term").gotoTerminal(1)<CR>')

for i = 0, 9 do
  map('n', '<leader>h' .. i, string.format(':lua require("harpoon.term").gotoTerminal(%d)<CR>', i))
end

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

map('n', ']q', ':Qbelow<CR>', silent) -- Go to next quickfix entry from cursor
map('n', '[q', ':Qabove<CR>', silent) -- Go to previous quickfix entry from cursor
map('n', '<leader>J', '<cmd>lua require"qf".below("visible")<CR>', silent) -- Go to next quickfix entry from cursor
map('n', '<leader>K', '<cmd>lua require"qf".above("visible")<CR>', silent) -- Go to previous quickfix entry from cursor

map('v', 'gl', ':<c-u>lua require"config.onlines"()<CR>', silent)
-- Dispatching
map('n', '<leader>eb', '<cmd>lua require"config.dispatch".dispatch("build")<CR>')
map('n', '<leader>er', '<cmd>lua require"config.dispatch".dispatch("run")<CR>')
map('n', '<leader>et', '<cmd>lua require"config.dispatch".dispatch("test")<CR>')
map('n', '<leader>ed', '<cmd>lua require"config.dispatch".dispatch("doc")<CR>')
map('n', '<leader>el', '<cmd>lua require"config.dispatch".dispatch("lint")<CR>')
map('n', '<leader>ec', '<cmd>lua require"config.dispatch".dispatch("check")<CR>')
map('n', '<leader>eC', '<cmd>lua require"config.dispatch".dispatch("check")<CR>')

-- Tabs
map('n', '<leader>N', ':tabnew<CR>')
map('n', '<leader>S', ':tab split<CR>')
map('n', '<leader>Q', ':tabclose<CR>')
map('n', '<leader>to', ':tabonly<CR>')

for i = 0,9 do
  map('n', '<leader>' .. i , i .. 'gt')
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
map('n', '<leader>W',  ':WindowSwap<CR>')

-- Git mappings
map('n', '<leader>gg',  ':Ge :<CR>')
map('n', '<leader>gd',  ':G difftool --name-status<CR>')
map('n', '<leader>ga',  ':Git add %<CR>')
map('n', '<leader>gS',  ':Git stage .<CR>')
map('n', '<leader>gc',  ':Git commit<CR>')
map('n', '<leader>gpp', ':Git push<CR>')
map('n', '<leader>gpu', ':Git pull<CR>')
-- map('n', '<leader>gpf', ':Git push --force<CR>')
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

-- Clear search highlight
map('n', '<Esc>', '<plug>(searchhi-clear-all)')

-- Easy align
map('x', 'ga', '<plug>(EasyAlign)')
map('n', 'ga', '<plug>(EasyAlign)')

-- Snippet expansion
map('i', '<C-l>', 'vsnip#available(1) ? "<plug>(vsnip-expand-or-jump)" : "<C-l>"', { expr = true})
map('n', '<C-l>', 'vsnip#available(1) ? "<plug>(vsnip-expand-or-jump)" : "<C-l>"', { expr = true})

-- Movements
map('', '<C-j>', '}', { noremap = true })
map('', '<C-k>', '{', { noremap = true })
map('i', '<C-5>', '<C-o>%', { noremap = true })

-- map('', '<C-a>', '^')
map('', '<C-e>', '$')

-- Transpose word
-- map('', 'L', 'daWWPB')
-- map('', 'H', 'daWBPB')
-- map('', 'M', '2dWBhP')

-- Move lines
map('n', '<A-k>', ':m .-2<CR>', silent)
map('n', '<A-j>', ':m .+1<CR>', silent)

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

-- DAP
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

-- Rust
map('', '<leader>rr', ':RustRunnables<CR>')
map('', '<leader>rd', ':RustDebuggables<CR>')
map('', '<leader>ru', ':RustParentModule<CR>')
map('', '<leader>ro', ':RustOpenCargo<CR>')
