local function autocmd(au_type, where, dispatch)
  vim.cmd(string.format('au! %s %s %s', au_type, where, dispatch))
end

autocmd('BufNewFile, BufRead', '*.frag,*.vert', 'set ft=glsl')
autocmd('FileType', 'rust', 'compiler cargo')
autocmd('BufWritePost', '*.rs', 'make build')

-- Auto compile when there are changes in plugins.lua
autocmd('BufWritePost', 'plugins.lua', 'echo "Compiling Packer" | PackerCompile')

autocmd('TermEnter', '*', 'if (&filetype != "fzf") | tnoremap <buffer> <Esc> <C-\\><C-n> | endif')

autocmd('FileType', 'fugitive', 'map <buffer> <Tab> =')

autocmd('BufReadPost', '*', [[ if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif ]])
