local fn = vim.fn

local paq_dir = fn.stdpath('data') .. '/site/pack/paqs/start/'
local paq_path = paq_dir .. 'paq-nvim'

if fn.empty(fn.glob(paq_path)) > 0 then
  print 'Downloading paq-nvim'
  fn.system({'git', 'clone', 'https://github.com/savq/paq-nvim', paq_path})
end

local function localpaq(path)
  path = fn.fnamemodify(path, ':p'):sub(1,-2)

  if fn.empty(fn.glob(path)) == 0 then
    fn.system({'ln', '-s', path, paq_dir})
    -- print('ln', '-s', path, paq_dir)
  end
end

vim.cmd 'packadd termdebug'

localpaq('~/dev/nvim/qf.nvim')
localpaq('~/dev/nvim/darken.nvim')
localpaq('~/dev/nvim/toggle.nvim')
localpaq('~/dev/nvim/window-picker.nvim')
-- localpaq('~/dev/nvim/aerial.nvim')

local paq = require 'paq-nvim' {
  'savq/paq-nvim', -- Let Paq manage itself

  -- My plugins
  'ten3roberts/toggle.nvim',
  'ten3roberts/qf.nvim',
  'ten3roberts/darken.nvim',
  'ten3roberts/window-picker.nvim',

  -- Colorschemes
  'arcticicestudio/nord-vim',
  'chriskempson/base16-vim',
  'rakr/vim-one',
  'romgrk/doom-one.vim',
  'sainnhe/sonokai',

  'AndrewRadev/sideways.vim', -- Move arguments and elements in list around
  'David-Kunz/treesitter-unit',
  'airblade/vim-rooter', -- Change cwd to the git root
  'dkarter/bullets.vim', -- Markdown bullet management
  'folke/zen-mode.nvim',
  'gfanto/fzf-lsp.nvim',
  'hrsh7th/nvim-compe', -- Smart autocompletion
  'hrsh7th/vim-vsnip', -- Snippets
  'hrsh7th/vim-vsnip-integ',-- Snippet integrations
  'junegunn/fzf.vim',
  'junegunn/vim-easy-align', -- Align text blocks
  'kabouzeid/nvim-lspinstall', -- Automatically install lsp servers
  'kyazdani42/nvim-tree.lua', -- File tree
  'kyazdani42/nvim-web-devicons', -- File icons for barbar, nvim-tree and statusline
  'lewis6991/gitsigns.nvim', -- Show changed lines
  'maxbrunsfeld/vim-yankstack', -- Easily use the registers
  'mbbill/undotree',
  'neovim/nvim-lspconfig', -- LSP configurations
  'norcalli/nvim-colorizer.lua', -- Highlight colorcodes
  'nvim-lua/plenary.nvim', -- Lua utils library
  'nvim-treesitter/playground',
  'phaazon/hop.nvim', -- Jump around in current buffer
  'qxxxb/vim-searchhi', -- Highlight current search match
  'rafamadriz/friendly-snippets', -- Preconfigured snippets
  'ray-x/lsp_signature.nvim', -- Show function signature help
  'stevearc/aerial.nvim', -- Symbol tree
  'tikhomirov/vim-glsl', -- GLSL runtime files
  'tpope/vim-abolish', -- Change casing styles and provide smart search and replace
  'tpope/vim-commentary', -- Toggle comments
  'tpope/vim-dispatch', -- Async build and command dispatch
  'tpope/vim-eunuch',
  'tpope/vim-fugitive', -- Git management
  'tpope/vim-repeat', -- Repeat plugin commands with .
  'tpope/vim-surround', -- ( surround text )
  'tpope/vim-unimpaired', -- Handy bracket mappings
  'wellle/targets.vim', -- Better handling and seeking for textobjects
  'windwp/nvim-autopairs',
  'windwp/nvim-ts-autotag',
  -- 'AndrewRadev/splitjoin.vim', -- Join and breakup statements
  -- 'LunarWatcher/auto-pairs', -- Automatic brackets
  { 'iamcco/markdown-preview.nvim', run = function() vim.fn['mkdp#util#install']() end }, -- Markdown previewing
  { 'junegunn/fzf', run = function() vim.fn['fzf#install()']() end },
  {'nvim-treesitter/nvim-treesitter', run = function() vim.fn.TSInstall('maintained') end }, -- Better syntax highlighting using treesitter parsing

  'rmagatti/auto-session', -- Remember last session for cwd
}
paq:install()
paq:clean()
paq:update()
