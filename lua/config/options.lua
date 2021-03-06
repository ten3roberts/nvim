local o = vim.o
local g = vim.g

-- Vim Options
-- o.clipboard = 'unnamedplus' -- Use system clipboard
o.autoread = true
o.cmdheight = 2
o.switchbuf = 'useopen,usetab'
o.completeopt = 'menuone,noselect'
o.confirm = true -- Disable 'no write'
o.cursorline = true
o.equalalways = true
o.expandtab = true
o.foldlevelstart = 99
o.foldnestmax = 6
o.foldmethod = 'indent'
o.foldtext = 'v:lua.clean_fold()'
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
o.runtimepath = o.runtimepath .. ",~/dev/nvim"
o.scrolloff = 8 -- Lines from the cursor
o.sessionoptions = 'tabpages,terminal'
-- o.sessionoptions="blank,buffers,curdir,folds,help,options,tabpages,winsize,resize,winpos,terminal"
o.shiftwidth = 2
o.shortmess = vim.o.shortmess .. 'c'
o.showmatch = true -- Show matching brackets/parenthesis
o.showmode = false -- Do not output message on the bottom
o.signcolumn = "yes"
o.smartcase = true
o.smartindent = true
o.splitbelow = false -- Splits open on the bottom
o.splitright = true -- Splits open on the right
o.tabstop = 2
o.termguicolors = true
o.textwidth = 80
o.title = true
o.titlestring="nvim %{fnamemodify(getcwd(), ':~')}"
-- o.titlestring="nvim %{fnamemodify(getcwd(), ':~')} %M"
o.undofile = true
o.updatetime = 500
o.wildmenu = true -- Command line completion mode
o.wildmode = 'full' -- Command line completion mode

g.termdebug_wide = 1
g.termdebugger='rust-gdb'

-- g.netrw_keepdir = 0

-- AutoPairs
g.AutoPairsMapBS = 1
g.AutoPairsMultilineClose = 1
g.AutoPairsShortcutToggle = ''

g.yankstack_yank_keys = { 'y', 'd', 'c' }

-- Rooter
g.rooter_patterns = { '.git' }

-- Markdown preview
g.mkdp_refresh_slow = true
g.mkdp_auto_close = false

g.vim_markdown_fenced_languages = { 'rust', 'lua', 'python', 'sh', 'bash' }

-- Nord
g.nord_cursor_line_number_background = 1
g.nord_bold = 1
g.nord_italic = 1
g.nord_uniform_diff_background = 1
g.nord_italic_comments = 1
g.nord_underline = 1

-- Sonokai
g.sonokai_enable_italic = 1
g.sonokai_style = 'default'

-- Set colorscheme from env var or default
vim.cmd ( "colorscheme " .. ( vim.env.VIM_COLORSCHEME or 'nord' ) )
