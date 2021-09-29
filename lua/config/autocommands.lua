local function autocmd(au_type, where, dispatch)
  vim.cmd(string.format('autocmd %s %s %s', au_type, where, dispatch))
end

vim.cmd 'augroup CONFIG'
vim.cmd 'autocmd!'

autocmd('VimEnter,DirChanged', '*', 'lua require"config.dispatch".load_config(".dispatch.json", false)')
autocmd('BufWrite', '.dispatch.json', 'lua require"config.dispatch".load_config(".dispatch.json", false)')

autocmd('FileType', '*', 'lua require"config.dispatch".on_ft()')

autocmd('BufNew,FileType', '*', 'setlocal foldmethod=expr | setlocal foldexpr=nvim_treesitter#foldexpr()')

-- autocmd('BufWinEnter,TabEnter', '*', 'SaveSession')

-- Auto format on save using LSP
autocmd('BufWritePre', '*', 'lua vim.lsp.buf.formatting_sync()')

-- autocmd('FileType', 'dap-repl', 'lua require(:dap.ext.autocompl").attach()');

autocmd('StdinReadPre', '*', 'let g:std_in=1')
autocmd('VimEnter', '*', 'if getcwd() == $HOME && argc() == 0 && !exists("g:std_in") | execute("SearchSession") | endif')

autocmd('OptionSet', 'errorformat', 'setlocal errorformat+=%f:%l:\\ %t%*[^:]:%m')

-- Automatically create missing directories
autocmd('BufWritePre', '*', 'if (&buftype == "") | call mkdir(expand("<afile>:p:h"), "p") | endif')

autocmd('ColorScheme', '*', 'lua require "config.palette".setup()')

-- Restart language server when modifying Cargo.toml
autocmd('BufWritePost', '*/Cargo.toml', 'echom "Restarting LSP" | LspRestart')

-- Make Esc work in terminal mode (I know, some programs make use of Esc, but that's rare for my use case)
autocmd('TermEnter', '*', 'if &filetype != "fzf" | tnoremap <buffer> <Esc> <C-\\><C-n> | endif')
autocmd('TermOpen,TermEnter', '*', 'lua require"darken".force_darken()')
autocmd('TermOpen', '*', 'setlocal nonumber norelativenumber')

autocmd('FileType', 'fzf', 'tnoremap <A-q> <A-a><CR> | tmap  <C-q> <A-q>')

-- Make <Tab> expand diffs in Fugitive mode
autocmd('FileType', 'fugitive', 'map <buffer> <Tab> =')

autocmd('FileType', '*', 'setlocal formatoptions-=o')

-- Restore last position when opening file
autocmd('BufReadPost', '*', [[ if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif ]])

-- Make windows equal sized when resizing OS window
autocmd('VimResized', '*', 'wincmd =')

-- Clear cached statuslines and errors from deleted buffers
autocmd('BufUnload,BufDelete',  '*', 'lua require"config.lsp".clear_buffer_cache(vim.fn.expand("<abuf>"))')

-- Save before grep,make etc
autocmd('QuickFixCmdPre', '*', ':wa')

autocmd('WinEnter', '*', 'lua if vim.o.buftype == "" and vim.fn.win_gettype(0) == "" then require"config.lsp".set_loc() end')

autocmd('FileType', 'TelescopePrompt', 'let b:autopairs_enabled = 0')

-- autocmd('TabEnter', '*', 'if &buftype == "terminal" && &ft != "fzf" | :startinsert | endif')

vim.cmd 'augroup END'
