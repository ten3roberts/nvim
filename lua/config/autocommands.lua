local function autocmd(au_type, where, dispatch)
  vim.cmd(string.format('autocmd %s %s %s', au_type, where, dispatch))
end

vim.cmd 'augroup CONFIG'
vim.cmd 'autocmd!'

-- Auto format on save using LSP
autocmd('BufWritePre', '*', 'lua vim.lsp.buf.formatting_sync()')

-- Automatically create missing directories
autocmd('BufWritePre', '*', 'if (&buftype == "") | call mkdir(expand("<afile>:p:h"), "p") | endif')

-- Restart language server when modifying Cargo.toml
autocmd('BufWritePost', '*/Cargo.toml', 'echom "Restarting LSP" | LspRestart')

-- Auto compile when there are changes in plugins.lua
autocmd('BufWritePost', 'plugins.lua', 'echo "Compiling Packer" | Reload config.plugins | PackerCompile')

-- Make Esc work in terminal mode (I know, some programs make use of Esc, but that's rare for my use case)
autocmd('TermEnter', '*', 'if (&filetype != "fzf") | tnoremap <buffer> <Esc> <C-\\><C-n> | endif')

-- Make <Tab> expand diffs in Fugitive mode
autocmd('FileType', 'fugitive', 'map <buffer> <Tab> =')

-- Restore last position when opening file
autocmd('BufReadPost', '*', [[ if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif ]])

-- Make windows equal sized when resizing OS window
autocmd('VimResized', '*', 'wincmd =')

-- Clear cached statuslines and errors from deleted buffers
autocmd('BufUnload,BufDelete',  '*', 'lua require"config.lsp".clear_buffer_cache(vim.fn.expand("<abuf>"))')

-- Save before grep,make etc
autocmd('QuickFixCmdPre', '*', ':wa')

autocmd('InsertLeave,TextChanged', '*', 'lua require"config.lsp".set_loc()')

autocmd('WinLeave', '*', 'AerialClose')

vim.cmd 'augroup END'
