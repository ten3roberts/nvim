-- Vim Options
local opt = vim.opt
local o = vim.o
local g = vim.g

opt.autoread = true
opt.conceallevel = 0
opt.cmdheight = 2
opt.confirm = true -- Disable 'no write'
opt.cursorline = true
opt.laststatus = 2
opt.spelllang = { "en_us" }
opt.spell = false
opt.equalalways = true

-- o.foldtext = "v:lua.clean_fold()"
o.grepformat = "%f:%l:%c:%m,%f:%l:%m"
o.grepprg = "rg --vimgrep --no-heading"
o.hidden = true
o.hlsearch = true -- Highlight search results (enforce)
o.ignorecase = true
o.inccommand = "split" -- Show effects of command as you type in a split
o.incsearch = true -- Move cursor during search
o.linebreak = true
o.mouse = "a"
o.number = false
o.path = o.path .. "**"
-- o.pumheight = 8
-- o.pumwidth = 20
o.relativenumber = false
o.scrolloff = 8 -- Lines from the cursor

o.expandtab = true
o.shiftwidth = 4

o.showmatch = true -- Show matching brackets/parenthesis
o.showmode = false -- Do not output message on the bottom
o.signcolumn = "yes"
o.smartcase = true
o.smartindent = true
o.splitbelow = false -- Splits open on the bottom
o.splitright = true -- Splits open on the right
-- o.switchbuf = "useopen"
o.tabstop = 2
o.termguicolors = true
-- o.textwidth = 80
o.title = true
o.titlestring = "nvim %{fnamemodify(getcwd(), ':~')}"
o.undofile = true
o.swapfile = true
o.updatetime = 500
o.shortmess = o.shortmess .. 'A'
-- o.wildmenu = true -- Command line completion mode
o.wildmode = "full" -- Command line completion mode

opt.fillchars:append "diff:╱"

g.mapleader = " "

g.termdebug_wide = 1
g.termdebugger = "rust-gdb"
g.rooter_cd_cmd = "tcd"
g.rooter_manual_only = 0
g.rooter_patterns = { ".git", "Cargo.lock" }

-- Markdown preview
g.mkdp_refresh_slow = true
g.mkdp_auto_close = false
g.vim_markdown_fenced_languages = { "rust", "lua", "python", "sh", "bash" }
