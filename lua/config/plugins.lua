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
    vim.notify(path .. ' -> ' .. local_dir)
  end
end

localpaq('~/dev/nvim/qf.nvim')
localpaq('~/dev/nvim/lir.nvim')
localpaq('~/dev/nvim/wgsl.vim')
localpaq('~/dev/nvim/recipe.nvim')
localpaq('~/dev/nvim/darken.nvim')
localpaq('~/dev/nvim/toggle.nvim')
localpaq('~/dev/nvim/window-picker.nvim')

local paq = require 'paq' {
  'savq/paq-nvim', -- Let Paq manage itself

  -- My plugins
  -- 'ten3roberts/toggle.nvim',
  -- 'ten3roberts/qf.nvim',
  -- 'ten3roberts/darken.nvim',
  -- 'ten3roberts/window-picker.nvim',
  -- 'ten3roberts/recipe.nvim',

  -- Colorschemes
  'arcticicestudio/nord-vim',
{ url = 'https://github.com/catppuccin/nvim', as = "catppuccin" },
-- { url = 'https://github.com/shaunsingh/nord.nvim', as = "nord-nvim"},
  -- "norcalli/nvim-base16.lua",
  -- 'romgrk/doom-one.vim',
  'rose-pine/neovim',
  'sainnhe/sonokai',
{ url = 'https://gitlab.com/yorickpeterse/nvim-grey' },

  'AndrewRadev/sideways.vim', -- Move arguments and elements in list around
  'McAuleyPenney/Tidy.nvim',
  'ThePrimeagen/harpoon',
  'haya14busa/vim-asterisk',
  'airblade/vim-rooter',
  'andymass/vim-matchup',
  'TimUntersberger/neogit',
  'sindrets/diffview.nvim',
  'bfredl/nvim-miniyank',
  'dkarter/bullets.vim', -- Markdown bullet management
  'folke/zen-mode.nvim',
  'ggandor/leap.nvim',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-vsnip',
  'hrsh7th/nvim-cmp', -- Autocompletion plugin
  'hrsh7th/vim-vsnip',
  'hrsh7th/vim-vsnip-integ',
  'junegunn/vim-easy-align', -- Align text blocks
  'kabouzeid/nvim-lspinstall',
  'karb94/neoscroll.nvim',
  'kyazdani42/nvim-web-devicons', -- File icons for barbar, nvim-tree and statusline
  'lervag/vimtex',
  'lewis6991/gitsigns.nvim', -- Show changed lines
  'mbbill/undotree',
  'mfussenegger/nvim-dap',
  'monaqa/dial.nvim',
  'neovim/nvim-lspconfig', -- LSP configurations
  'norcalli/nvim-colorizer.lua', -- Highlight colorcodes
  'nvim-lua/plenary.nvim',
  'nvim-lua/popup.nvim',
  'nvim-telescope/telescope-dap.nvim',
  'nvim-telescope/telescope-fzy-native.nvim',
  'nvim-telescope/telescope-project.nvim',
  'nvim-telescope/telescope.nvim',
  'nvim-treesitter/nvim-treesitter',
  'phaazon/hop.nvim', -- Jump around in current buffer
  'qxxxb/vim-searchhi', -- Highlight current search match
  'rafamadriz/friendly-snippets', -- Preconfigured snippets
  'ray-x/lsp_signature.nvim', -- Show function signature help
  'rcarriga/nvim-dap-ui',
  'rcarriga/nvim-notify',
  'rhysd/conflict-marker.vim',
  'simrat39/rust-tools.nvim',
  'folke/persistence.nvim',
  'stevearc/aerial.nvim', -- Symbol tree
  'stevearc/dressing.nvim',
  'tamago324/lir-git-status.nvim',
  'tikhomirov/vim-glsl', -- GLSL runtime files
  'tpope/vim-abolish', -- Change casing styles and provide smart search and replace
  'tpope/vim-commentary', -- Toggle comments
  'tpope/vim-eunuch',
  'tpope/vim-fugitive', -- Git management
  'tpope/vim-repeat', -- Repeat plugin commands with .
  'tpope/vim-rsi', -- Readline mappings in insert mode
  'tpope/vim-sleuth',
  'tpope/vim-surround', -- ( surround text )
  'wellle/targets.vim', -- Better handling and seeking for textobjects
  'williamboman/nvim-lsp-installer',
  'windwp/nvim-autopairs',
  'windwp/nvim-ts-autotag',
  -- 'nvim-telescope/telescope-file-browser.nvim',
  'stevearc/stickybuf.nvim',
}


paq:sync()
