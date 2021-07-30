local o = vim.o
local g = vim.g

-- Vim Options
-- o.clipboard = 'unnamedplus' -- Use system clipboard
o.autoread = true
o.cmdheight = 2
o.switchbuf = 'useopen,usetab'
o.completeopt = 'menuone,noselect'
o.confirm = true -- Disable 'no write'
o.cursorline = false
o.equalalways = true
o.expandtab = true
o.foldlevelstart = 99
o.foldnestmax = 3
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
o.number = false
o.path = o.path .. '**'
o.pumheight = 8
o.relativenumber = false
o.runtimepath = o.runtimepath .. ",~/dev/nvim"
o.scrolloff = 8 -- Lines from the cursor
o.sessionoptions = 'folds,tabpages,terminal'
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
o.titlestring="nvim %{fnamemodify(getcwd(), ':~')} %M"
o.undofile = true
o.updatetime = 500
o.wildmenu = true -- Command line completion mode
o.wildmode = 'full' -- Command line completion mode

g.termdebug_wide = 1
g.termdebugger='rust-gdb'

g.windowswap_map_keys = 0

-- AutoPairs
g.AutoPairsMapBS = 1
g.AutoPairsShortcutToggle = ''

-- Sneak
g[ 'sneak#label' ] = 1
g[ 'sneak#s_next' ] = 0
g[ 'sneak#absolute_dir' ] = 1
g[ 'sneak#use_ic_scs' ] = 1

-- NvimTree
g.nvim_tree_ignore = { '.git' }
g.nvim_tree_width = 28
g.nvim_tree_auto_open = 1
g.nvim_tree_auto_close = 1
g.nvim_tree_disable_netrw = 1
g.nvim_tree_hijack_netrw = 1
g.nvim_tree_follow = 1
g.nvim_tree_tab_open = 0
g.nvim_tree_lint_lsp = 1
g.nvim_tree_side = 'right'
g.nvim_tree_git_hl = 1
g.nvim_tree_gitignore = 0
g.nvim_tree_show_icons = {
  git = 0,
  folders = 1,
  files = 1,
  folder_arrows = 0,
}
g.nvim_tree_quit_on_open = 1
g.nvim_tree_group_empty = 0
g.nvim_tree_disable_window_picker = 0
g.nvim_tree_lsp_diagnostics = 1
g.nvim_tree_special_files = {}

-- Barbar
g.bufferline = {
  animation = true,
  auto_hide = false,
  tabpages = true,
  closable = false,
  clickable = true,
  icons = true,
  icon_custom_colors = false,
  icon_separator_active = '▎',
  icon_separator_inactive = '▎',
  maximum_padding = 4,
  maximum_length = 30,
  semantic_letters = true,
  letters = 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP',
  no_name_title = nil,
}

g.yankstack_yank_keys = { 'y', 'd', 'c' }

-- Rooter
g.rooter_patterns = { '.git' }

-- Markdown preview
g.mkdp_refresh_slow = true
g.mkdp_auto_close = false

g.vim_markdown_fenced_languages = { 'rust', 'lua', 'python', 'sh', 'bash' }

-- Nord
g.nord_cursor_line_number_background = 0
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
