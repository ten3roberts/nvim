local fn = vim.fn

local paq_dir = fn.stdpath('data') .. '/site/pack/paqs/start/'
local local_dir = fn.stdpath('data') .. '/site/pack/local/start/'
local paq_path = paq_dir .. 'paq-nvim'

if fn.empty(fn.glob(paq_path)) > 0 then
  print 'Downloading paq-nvim'
  fn.system({'git', 'clone', 'https://github.com/savq/paq-nvim', paq_path})
end

local function localpaq(path)
  fn.mkdir(local_dir, 'p')
  path = fn.fnamemodify(path, ':p'):sub(1,-2)

  if fn.empty(fn.glob(path)) == 0 then
    fn.system({'ln', '-sf', path, local_dir})
    print(path, '->', local_dir)
  end
end

localpaq('~/dev/nvim/qf.nvim')
localpaq('~/dev/nvim/darken.nvim')
localpaq('~/dev/nvim/toggle.nvim')
localpaq('~/dev/nvim/window-picker.nvim')
localpaq('~/dev/nvim/session.nvim')
-- localpaq('~/dev/nvim/aerial.nvim')

local paq = require 'paq' {
  'savq/paq-nvim', -- Let Paq manage itself

  -- My plugins
  -- 'ten3roberts/toggle.nvim',
  -- 'ten3roberts/qf.nvim',
  -- 'ten3roberts/darken.nvim',
  -- 'ten3roberts/window-picker.nvim',

  -- Colorschemes
  'arcticicestudio/nord-vim',
  'gruvbox-community/gruvbox',
  'kdheepak/monochrome.nvim',
  'rakr/vim-one',
  'romgrk/doom-one.vim',
  'rose-pine/neovim',
  'sainnhe/sonokai',
  { url = 'https://gitlab.com/yorickpeterse/nvim-grey' },

  'AndrewRadev/sideways.vim', -- Move arguments and elements in list around
  'David-Kunz/treesitter-unit',
  'McAuleyPenney/Tidy.nvim',
  'RRethy/nvim-base16',
  'ThePrimeagen/harpoon',
  'ahmedkhalf/project.nvim',
  'andymass/vim-matchup',
  'cocopon/vaffle.vim',
  'dkarter/bullets.vim', -- Markdown bullet management
  'gfanto/fzf-lsp.nvim',
  'ggandor/lightspeed.nvim',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-vsnip',
  'hrsh7th/nvim-cmp', -- Autocompletion plugin
  'hrsh7th/vim-vsnip',
  'hrsh7th/vim-vsnip-integ',
  'junegunn/fzf.vim',
  'junegunn/vim-easy-align', -- Align text blocks
  'kabouzeid/nvim-lspinstall',
  'kyazdani42/nvim-web-devicons', -- File icons for barbar, nvim-tree and statusline
  'lewis6991/gitsigns.nvim', -- Show changed lines
  'maxbrunsfeld/vim-yankstack', -- Easily use the registers
  'mbbill/undotree',
  'mfussenegger/nvim-dap',
  'neovim/nvim-lspconfig', -- LSP configurations
  'norcalli/nvim-colorizer.lua', -- Highlight colorcodes
  'nvim-lua/plenary.nvim',
  'nvim-lua/popup.nvim',
  'nvim-telescope/telescope-dap.nvim',
  -- 'nvim-telescope/telescope-frecency.nvim',
  'nvim-telescope/telescope-fzy-native.nvim',
  'nvim-telescope/telescope.nvim',
  'nvim-treesitter/nvim-treesitter',
  'nvim-treesitter/playground',
  'phaazon/hop.nvim', -- Jump around in current buffer
  'qxxxb/vim-searchhi', -- Highlight current search match
  'rafamadriz/friendly-snippets', -- Preconfigured snippets
  'ray-x/lsp_signature.nvim', -- Show function signature help
  'rcarriga/nvim-dap-ui',
  'saadparwaiz1/cmp_luasnip',
  'simrat39/rust-tools.nvim',
  'steelsojka/pears.nvim',
  'stevearc/aerial.nvim', -- Symbol tree
  'stevearc/stickybuf.nvim',
  -- 'tami5/sqlite.lua',
  'tikhomirov/vim-glsl', -- GLSL runtime files
  'tpope/vim-abolish', -- Change casing styles and provide smart search and replace
  'tpope/vim-commentary', -- Toggle comments
  'tpope/vim-dispatch', -- Async build and command dispatch
  'tpope/vim-eunuch',
  'tpope/vim-fugitive', -- Git management
  'tpope/vim-repeat', -- Repeat plugin commands with .
  'tpope/vim-rsi', -- Readline mappings in insert mode
  'tpope/vim-sleuth',
  'tpope/vim-surround', -- ( surround text )
  'tpope/vim-unimpaired', -- Handy bracket mappings
  'wellle/targets.vim', -- Better handling and seeking for textobjects
  'windwp/nvim-autopairs',
  'windwp/nvim-ts-autotag',
  -- { url = 'https://gitlab.com/yorickpeterse/nvim-dd' },
  { 'iamcco/markdown-preview.nvim', run = function() vim.fn['mkdp#util#install']() end }, -- Markdown previewing
  { url = 'https://gitlab.com/yorickpeterse/nvim-pqf' },
  {'junegunn/fzf', run = function() vim.fn['fzf#install']() end},
  'nvim-telescope/telescope-file-browser.nvim',
}
paq:sync()
