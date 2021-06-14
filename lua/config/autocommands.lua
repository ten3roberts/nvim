local function autocmd(au_type, where, dispatch)
  vim.cmd(string.format('au! %s %s %s', au_type, where, dispatch))
end

vim.cmd 'augroup CONFIG'
vim.cmd 'autocmd!'

autocmd('BufNewFile, BufRead', '*.frag,*.vert', 'set ft=glsl')
autocmd('FileType', 'rust', 'compiler cargo')

autocmd('BufWritePre', '*.rs', 'lua vim.lsp.buf.formatting()')

-- Restart language server when modifying Cargo.toml
autocmd('BufWritePost', '*/Cargo.toml', 'echom Restarting LSP | LspRestart')

-- Auto compile when there are changes in plugins.lua
autocmd('BufWritePost', 'plugins.lua', 'echo "Compiling Packer" | Reload config.plugins | PackerCompile')

autocmd('TermEnter', '*', 'if (&filetype != "fzf") | tnoremap <buffer> <Esc> <C-\\><C-n> | endif')

autocmd('FileType', 'fugitive', 'map <buffer> <Tab> =')

autocmd('BufReadPost', '*', [[ if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif ]])

-- Resize and lock outline size
autocmd('FileType', 'Outline', 'vertical resize 40 | set winfixwidth')

autocmd('VimResized', '*', 'wincmd =')
autocmd('BufUnload,BufDelete',  '*', 'lua require"config.lsp".clear_buffer_cache(vim.fn.expand("<abuf>"))')

vim.cmd 'augroup END'
