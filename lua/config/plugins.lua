local fn = vim.fn

local paq_dir = fn.stdpath('data') .. '/site/pack/paqs/start/'
local paq_path = paq_dir .. 'paq-nvim'

if fn.empty(fn.glob(paq_path)) > 0 then
  print 'Downloading paq-nvim'
  fn.system({'git', 'clone', 'https://github.com/savq/paq-nvim', paq_path})
end

local function localpaq(path)
  local name = fn.fnamemodify(path, ':t')
    path = fn.fnamemodify(path, ':p'):sub(1,-2)

  if fn.empty(fn.glob(path)) == 0 then
    fn.system({'ln', '-s', path, paq_dir .. name})
  end
end

localpaq('~/dev/nvim/qf.nvim')
localpaq('~/dev/nvim/darken.nvim')
localpaq('~/dev/nvim/toggle.nvim')
localpaq('~/dev/nvim/window-picker.nvim')
localpaq('~/dev/nvim/aerial.nvim')

local paq = require 'paq-nvim' {
  'savq/paq-nvim', -- Let Paq manage itself

  -- My plugins
  'ten3roberts/toggle.nvim',
  'ten3roberts/qf.nvim',
  'ten3roberts/darken.nvim',
  'ten3roberts/window-picker.nvim',

  -- Colorschemes
  'rakr/vim-one',
  'arcticicestudio/nord-vim',
  'romgrk/doom-one.vim',
  'sainnhe/sonokai',

  'AndrewRadev/sideways.vim', -- Move arguments and elements in list around
  'LunarWatcher/auto-pairs', -- Automatic brackets
  'airblade/vim-rooter', -- Change cwd to the git root
  'dkarter/bullets.vim', -- Markdown bullet management
  'hrsh7th/nvim-compe', -- Smart autocompletion
  'hrsh7th/vim-vsnip', -- Snippets
  'hrsh7th/vim-vsnip-integ',-- Snippet integrations
  'junegunn/vim-easy-align', -- Align text blocks
  'kabouzeid/nvim-lspinstall', -- Automatically install lsp servers
  'kyazdani42/nvim-tree.lua', -- File tree
  'kyazdani42/nvim-web-devicons', -- File icons for barbar, nvim-tree and statusline
  'lewis6991/gitsigns.nvim', -- Show changed lines
  'maxbrunsfeld/vim-yankstack', -- Easily use the registers
  'neovim/nvim-lspconfig', -- LSP configurations
  'norcalli/nvim-colorizer.lua', -- Highlight colorcodes
  'nvim-lua/plenary.nvim', -- Lua utils library
  'phaazon/hop.nvim',
  'qxxxb/vim-searchhi', -- Highlight current search match
  'rafamadriz/friendly-snippets', -- Preconfigured snippets
  'ray-x/lsp_signature.nvim', -- Show function signature help
  'stevearc/aerial.nvim', -- Symbol tree
  'tikhomirov/vim-glsl', -- GLSL runtime files
  'tpope/vim-abolish', -- Change casing styles and provide smart search and replace
  'tpope/vim-commentary', -- Toggle comments
  'tpope/vim-dispatch', -- Async build and command dispatch
  'tpope/vim-fugitive', -- Git management
  'tpope/vim-repeat', -- Repeat plugin commands with .
  'tpope/vim-surround', -- ( surround text )
  'tpope/vim-unimpaired', -- Handy bracket mappings
  'wellle/targets.vim', -- Better handling and seeking for textobjects
  -- 'AndrewRadev/splitjoin.vim', -- Join and breakup statements
  -- 'romgrk/barbar.nvim', -- Show open buffers in tabline
  { 'iamcco/markdown-preview.nvim', run = function() vim.fn['mkdp#util#install']() end }, -- Markdown previewing
  {'nvim-treesitter/nvim-treesitter', run = function() vim.fn.TSInstall('maintained') end }, -- Better syntax highlighting using treesitter parsing
  -- 'akinsho/nvim-bufferline.lua',

  -- Telescope
  'nvim-telescope/telescope.nvim', -- Finder UI
  'nvim-lua/popup.nvim', -- Neovim popup library
  'nvim-telescope/telescope-fzy-native.nvim', -- Fuzzy finder

  'rmagatti/auto-session', -- Remember last session for cwd
  'rmagatti/session-lens', -- Telescope session finder
}

paq:install()
paq:clean()
paq:update()
