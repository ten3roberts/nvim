local o = vim.o

o.clipboard = 'unnamedplus' -- Use system clipboard
o.confirm = true -- Disable 'no write'
o.cursorline = true
o.equalalways = true
o.expandtab = true
o.foldexpr = 'nvim_treesitter#foldexpr()'
o.foldlevelstart = 99
o.foldmethod = 'expr'
o.formatoptions = "tqj"
o.hlsearch = true -- Highlight search results (enforce)
o.ignorecase = true
o.inccommand = 'split' -- Show effects of command as you type in a split
o.incsearch = true -- Move cursor during search
o.linebreak = true
o.mouse = 'a'
o.number = true
o.path = o.path .. '**'
o.relativenumber = true
o.scrolloff = 0
o.scrolloff = 8 -- Lines from the cursor
o.grepprg='rg --vimgrep --no-heading'
o.grepformat='%f:%l:%c:%m,%f:%l:%m'
o.shiftwidth = 2
o.shortmess = vim.o.shortmess .. 'c'
o.showmatch = true -- Show matching brackets/parenthesis
o.showmode = false -- Do not output message on the bottom
o.signcolumn = "yes"
o.smartcase = true
o.smartindent = true
o.splitbelow = true -- Splits open on the bottom
o.splitright = true -- Splits open on the right
o.tabstop = 2
o.termguicolors = true
o.updatetime = 300
o.wildmenu = true -- Command line completion mode
o.wildmode = 'full' -- Command line completion mode

-- Set colorscheme
vim.cmd "colorscheme nord"
