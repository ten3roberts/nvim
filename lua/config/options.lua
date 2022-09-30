local o = vim.o
local opt = vim.opt
local g = vim.g

-- Vim Options
-- opt.guifont = "Fira Code Retina:h12"
-- o.guifont = "JetBrains Mono Nerd Font:h12"
opt.guifont = "JetBrainsMono Nerd Font:h12"

g.neovide_cursor_trail_length = 0.1
g.neovide_cursor_animation_length = 0.01
g.neovide_cursor_antialiasing = true

g.neovide_floating_blur_amount_x = 1.0
g.neovide_floating_blur_amount_y = 1.0
-- g.neovide_scroll_animation_length = 0.5

opt.autoread = true
opt.cmdheight = 1
opt.confirm = true -- Disable 'no write'
opt.cursorline = true
opt.laststatus = 2
opt.spelllang = { "en_us" }
opt.spell = false
opt.equalalways = true
opt.foldlevelstart = 12
opt.foldmethod = "indent"
-- o.foldmethod = "expr"
-- o.foldexpr = "nvim_treesitter#foldexpr()"
-- o.foldminlines = 6
-- o.foldnestmax = 6
o.foldtext = "v:lua.clean_fold()"
o.formatoptions = "jcrqltn"
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
o.pumheight = 8
o.pumwidth = 20
o.relativenumber = false
o.runtimepath = o.runtimepath .. ",~/dev/nvim"
o.scrolloff = 8 -- Lines from the cursor

o.expandtab = true
o.shiftwidth = 4

o.shortmess = vim.o.shortmess .. "c"
o.showmatch = true -- Show matching brackets/parenthesis
o.showmode = false -- Do not output message on the bottom
o.signcolumn = "yes"
o.smartcase = true
o.smartindent = true
o.splitbelow = false -- Splits open on the bottom
o.splitright = true -- Splits open on the right
o.switchbuf = "useopen"
o.tabstop = 2
o.termguicolors = true
o.textwidth = 80
o.title = true
o.titlestring = "nvim %{fnamemodify(getcwd(), ':~')}"
o.undofile = true
o.updatetime = 500
o.wildmenu = true -- Command line completion mode
o.wildmode = "full" -- Command line completion mode

g.termdebug_wide = 1
g.termdebugger = "rust-gdb"
g.rooter_cd_cmd = "tcd"
g.rooter_manual_only = 0
g.rooter_patterns = { ".git", "Cargo.lock" }

-- Markdown preview
g.mkdp_refresh_slow = true
g.mkdp_auto_close = false
g.vim_markdown_fenced_languages = { "rust", "lua", "python", "sh", "bash" }

g.vsnip_snippet_dirs = { vim.fn.stdpath "config" .. "/vsnip" }

-- Nord
g.nord_cursor_line_number_background = 1
g.nord_bold = 1
g.nord_italic = 1
g.nord_uniform_diff_background = 1
g.nord_italic_comments = 1
g.nord_underline = 1
g.nord_borders = true

-- Sonokai
g.sonokai_enable_italic = 1
g.sonokai_style = "default"

-- Set colorscheme from env var or default
vim.cmd("colorscheme " .. (vim.env.VIM_COLORSCHEME or "nord"))
