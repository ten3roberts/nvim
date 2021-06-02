local function autocmd(au_type, where, dispatch)
  vim.cmd(string.format('au! %s %s %s', au_type, where, dispatch))
end

autocmd('BufNewFile, BufRead', '*.frag,*.vert', 'set ft=glsl')
autocmd('FileType', 'rust', 'compiler cargo')
autocmd('BufWritePost', '*.rs', 'make build')

-- Auto compile when there are changes in plugins.lua
autocmd('BufWritePost', 'plugins.lua', 'PackerCompile')
