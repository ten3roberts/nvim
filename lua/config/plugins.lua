local fn = vim.fn

local paq_dir = fn.stdpath('data') .. '/site/pack/paqs/start/'
local paq_path = paq_dir .. '/paq-nvim'

if fn.empty(fn.glob(paq_path)) > 0 then
  print 'Downloading paq-nvim'
    fn.system({'git', 'clone', 'https://github.com/savq/paq-nvim', paq_path})
end

local function localpaq(path)
  local name = fn.fnamemodify(path, ':t')
  fn.system({'ln', '-s', fn.fnamemodify(path, ':p'), paq_dir .. name})
end

localpaq('~/dev/nvim/qf.nvim')
localpaq('~/dev/nvim/darken.nvim')
localpaq('~/dev/nvim/toggle.nvim')

local paq = require 'paq-nvim' {
  'savq/paq-nvim', -- Let Paq manage itself

  -- My plugins
  'ten3roberts/toggle.nvim',
  'ten3roberts/qf.nvim',
  'ten3roberts/darken.nvim',

  -- Colorschemes
  'rakr/vim-one',
  'arcticicestudio/nord-vim',
  'romgrk/doom-one.vim',
  'sainnhe/sonokai',

  'AndrewRadev/sideways.vim', -- Move arguments and elements in list around
  -- 'AndrewRadev/splitjoin.vim', -- Join and breakup statements
  'LunarWatcher/auto-pairs', -- Automatic brackets
  'airblade/vim-rooter', -- Change cwd to the git root
  'dkarter/bullets.vim', -- Markdown bullet management
  'hrsh7th/nvim-compe', -- Smart autocompletion
  'hrsh7th/vim-vsnip', -- Snippets
  'hrsh7th/vim-vsnip-integ',-- Snippet integrations
  { 'iamcco/markdown-preview.nvim', run = function() vim.fn['mkdp#util#install']() end }, -- Markdown previewing
  'junegunn/vim-easy-align', -- Align text blocks
  'justinmk/vim-sneak', -- Quickly jump in file by 2 chars
  'kabouzeid/nvim-lspinstall', -- Automatically install lsp servers
  'kyazdani42/nvim-tree.lua', -- File tree
  'kyazdani42/nvim-web-devicons', -- File icons for barbar, nvim-tree and statusline
  'lewis6991/gitsigns.nvim', -- Show changed lines
  'maxbrunsfeld/vim-yankstack', -- Easily use the registers
  'neovim/nvim-lspconfig', -- LSP configurations
  'norcalli/nvim-colorizer.lua', -- Highlight colorcodes
  'nvim-lua/plenary.nvim', -- Lua utils library
  'nvim-treesitter/nvim-treesitter', -- Better syntax highlighting using treesitter parsing
  'qxxxb/vim-searchhi', -- Highlight current search match
  'rafamadriz/friendly-snippets', -- Preconfigured snippets
  'ray-x/lsp_signature.nvim', -- Show function signature help
  'romgrk/barbar.nvim', -- Show open buffers in tabline
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
  'wesQ3/vim-windowswap', -- Swap windows

  -- Telescope
  'nvim-telescope/telescope.nvim', -- Finder UI
  'nvim-lua/popup.nvim', -- Neovim popup library
  'nvim-telescope/telescope-fzy-native.nvim', -- Fuzzy finder

  'rmagatti/auto-session', -- Remember last session for cwd
  'rmagatti/session-lens', -- Telescope session finder
}

paq:install()
paq:update()
