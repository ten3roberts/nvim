local o = vim.o


o.autoread = true
o.clipboard = 'unnamedplus' -- Use system clipboard
o.confirm = true -- Disable 'no write'
o.cursorline = true
o.equalalways = true
o.expandtab = true
o.foldlevelstart = 99
o.foldmethod = 'indent'
o.formatoptions = 'jcrqltn'
o.grepformat='%f:%l:%c:%m,%f:%l:%m'
o.grepprg='rg --vimgrep --no-heading'
o.hidden = true
o.hlsearch = true -- Highlight search results (enforce)
o.ignorecase = true
o.inccommand = 'split' -- Show effects of command as you type in a split
o.incsearch = true -- Move cursor during search
o.linebreak = true
o.mouse = 'nvc'
o.number = true
o.path = o.path .. '**'
o.pumheight = 8
o.relativenumber = true
o.scrolloff = 8 -- Lines from the cursor
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
o.title = true
o.updatetime = 300
o.wildmenu = true -- Command line completion mode
o.wildmode = 'full' -- Command line completion mode
vim.g.mkdp_refresh_slow = true

vim.g.gruvbox_contrast_dark = 'medium'
vim.g.gruvbox_contrast_light = 'medium'
vim.g.gruvbox_sign_column = 'bg0'

vim.g.nord_cursor_line_number_background = 0
vim.g.nord_bold = 1
vim.g.nord_italic = 1
vim.g.nord_uniform_diff_background = 1
vim.g.nord_italic_comments = 1
vim.g.nord_underline = 1

vim.g.sonokai_enable_italic = 1

vim.cmd "colorscheme sonokai"
