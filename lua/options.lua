local o = vim.o

o.updatetime = 300
o.foldlevelstart = 99
o.termguicolors = true
o.mouse = 'a'
o.ignorecase = true
o.smartcase = true
o.scrolloff = 0
o.incsearch = true
o.confirm = true -- Disable 'no write'
o.scrolloff = 8 -- Lines from the cursor
o.incsearch = true -- Move cursor during search
o.splitright = true -- Splits open on the right
o.splitbelow = true -- Splits open on the bottom
o.wildmenu = true -- Command line completion mode
o.wildmode = 'full' -- Command line completion mode
o.hlsearch = true -- Highlight search results (enforce)
o.showmatch = true -- Show matching brackets/parenthesis
o.showmode = false -- Do not output message on the bottom
o.inccommand = 'split' -- Show effects of command as you type in a split
o.clipboard = 'unnamedplus' -- Use system clipboard
o.shortmess = vim.o.shortmess .. 'c'
o.expandtab = true
o.tabstop = 2
o.shiftwidth = 2
o.formatoptions = "tqj"
o.smartindent = true
o.relativenumber = true
o.number = true
o.linebreak = true
o.signcolumn = "yes"
o.cursorline = true

-- Set colorscheme
vim.cmd "colorscheme nord"
