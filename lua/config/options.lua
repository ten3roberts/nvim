local o = vim.o
local g = vim.g

o.autoread = true
o.clipboard = 'unnamedplus' -- Use system clipboard
o.cmdheight = 2
o.completeopt = 'menuone,noselect,longest'
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
o.laststatus = 2
o.linebreak = true
o.mouse = 'nvc'
o.number = true
o.path = o.path .. '**'
o.pumheight = 8
o.relativenumber = true
o.scrolloff = 8 -- Lines from the cursor
o.sessionoptions = ''
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
o.updatetime = 500
o.wildmenu = true -- Command line completion mode
o.wildmode = 'full' -- Command line completion mode

g.mkdp_refresh_slow = true

g.gruvbox_contrast_dark = 'medium'
g.gruvbox_contrast_light = 'medium'
g.gruvbox_sign_column = 'bg0'

g.nord_cursor_line_number_background = 0
g.nord_bold = 1
g.nord_italic = 1
g.nord_uniform_diff_background = 1
g.nord_italic_comments = 1
g.nord_underline = 1

g.sonokai_enable_italic = 1
g.sonokai_style = 'default'

vim.cmd ( "colorscheme " .. ( vim.env.VIM_COLORSCHEME or 'sonokai' ) )
