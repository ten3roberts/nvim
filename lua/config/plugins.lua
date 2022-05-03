local fn = vim.fn

local paq_dir = fn.stdpath('data') .. '/site/pack/packer/start/'
local packer_path = paq_dir .. 'packer.nvim'

if fn.empty(fn.glob(packer_path)) > 0 then
  print 'Downloading packer'
  fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', packer_path })
end

vim.cmd [[packadd packer.nvim]]
require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'


  use('~/dev/nvim/qf.nvim')
  use('~/dev/nvim/lir.nvim')
  -- use ('~/dev/nvim/graphene.nvim')
  -- use ('~/dev/nvim/wgsl.vim')
  use('~/dev/nvim/recipe.nvim')
  use('~/dev/nvim/darken.nvim')
  use('~/dev/nvim/toggle.nvim')
  use('~/dev/nvim/window-picker.nvim')
  -- Colorschemes
  use 'arcticicestudio/nord-vim'
  use 'rakr/vim-one'
  use 'sainnhe/sonokai'

  -- Move arguments and elements in list around
  use 'AndrewRadev/sideways.vim'
  use 'ThePrimeagen/harpoon'
  use 'TimUntersberger/neogit'
  use 'airblade/vim-rooter'

  use { 'akinsho/git-conflict.nvim', config = function()
    require('git-conflict').setup {}
  end
  }

  use { 'andymass/vim-matchup' }
  -- Markdown bullet management
  use 'dkarter/bullets.vim'
  use 'echasnovski/mini.nvim'
  use { 'folke/zen-mode.nvim', config = function()
    require "zen-mode".setup {}
  end }
  use 'gbprod/yanky.nvim'
  use 'ggandor/leap.nvim'
  use 'haya14busa/vim-asterisk'
  -- Autocompletion plugin
  use { 'hrsh7th/nvim-cmp',
    requires = { 'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/vim-vsnip',
      'hrsh7th/vim-vsnip-integ',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-vsnip',
      'ray-x/cmp-treesitter'
    },
    config = function()
      require "config.completion"
    end
  }
  use 'junegunn/vim-easy-align' -- Align text blocks
  use { 'karb94/neoscroll.nvim', config = function()
    local t    = {}
    t["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "100", "quadratic" } }
    t["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "100", "quadratic" } }
    t["<C-b>"] = { "scroll", { "-vim.api.nvim_win_get_height(0)", "true", "250" } }
    t["<C-f>"] = { "scroll", { "vim.api.nvim_win_get_height(0)", "true", "250" } }
    t["<C-y>"] = { "scroll", { "-0.10", "false", "100" } }
    t["<C-e>"] = { "scroll", { "0.10", "false", "100" } }
    t["zt"]    = { "zt", { "250" } }
    t["zz"]    = { "zz", { "250" } }
    t["zb"]    = { "zb", { "250" } }

    require "neoscroll".setup {}
    require "neoscroll.config".set_mappings(t)
  end
  }
  use 'kyazdani42/nvim-web-devicons' -- File icons for barbar, nvim-tree and statusline
  use 'lervag/vimtex'
  -- Show changed lines
  use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } }
  use 'mbbill/undotree'

  use { 'mfussenegger/nvim-dap', requires = { "rcarriga/nvim-dap-ui" }, config = function()
    require "config.dbg"
  end }

  use 'monaqa/dial.nvim'

  -- LSP configurations
  use { 'neovim/nvim-lspconfig', requires = "williamboman/nvim-lsp-installer", config = function()
    require "config.lsp"
  end }

  use 'norcalli/nvim-colorizer.lua' -- Highlight colorcodes

  use { 'nvim-telescope/telescope.nvim',
    requires = { 'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-dap.nvim',
      'nvim-telescope/telescope-fzy-native.nvim'
    },
    config = function()
      require "config.telescope"
    end
  }

  use { 'nvim-treesitter/nvim-treesitter',
    requires = { 'RRethy/nvim-treesitter-textsubjects' },
    config = function()
      require 'config.treesitter'
    end
  }

  use { 'olimorris/persisted.nvim', config = function()
    require("persisted").setup({
      save_dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/"), -- directory where session files are saved
      command = "VimLeavePre", -- the autocommand for which the session is saved
      use_git_branch = true, -- create session files based on the branch of the git enabled repository
      autosave = true, -- automatically save session files when exiting Neovim
      autoload = false, -- automatically load the session for the cwd on Neovim startup
    })

  end }
  use { 'onsails/lspkind-nvim' }
  use 'qxxxb/vim-searchhi' -- Highlight current search match
  use 'rafamadriz/friendly-snippets' -- Preconfigured snippets
  use 'ray-x/lsp_signature.nvim' -- Show function signature help
  use 'rcarriga/nvim-dap-ui'
  use 'rcarriga/nvim-notify'
  use { 'simrat39/rust-tools.nvim', config = function() require "config.rust" end }
  use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }
  use { 'stevearc/aerial.nvim', config = function() require "config.aerial" end } -- Symbol tree
  use { 'stevearc/dressing.nvim', requires = { "telescope.nvim" }, config = function()
    require "dressing".setup {
      select = {
        telescope = require "telescope.themes".get_dropdown {
          border = false,
        }
      }
    }
  end }
  -- use 'stevearc/stickybuf.nvim'
  use 'tikhomirov/vim-glsl' -- GLSL runtime files

  use 'tpope/vim-abolish' -- Change casing styles and provide smart search and replace
  use 'tpope/vim-commentary' -- Toggle comments
  use 'tpope/vim-eunuch'
  use 'tpope/vim-fugitive' -- Git management
  use 'tpope/vim-repeat' -- Repeat plugin commands with .
  use 'tpope/vim-rsi' -- Readline mappings in insert mode
  use 'tpope/vim-sleuth'
  use 'tpope/vim-surround' -- ( surround text )
  use 'tpope/vim-unimpaired'

  use 'wellle/targets.vim' -- Better handling and seeking for textobjects
  use { 'windwp/nvim-autopairs', requires = 'windwp/nvim-ts-autotag', config = function()
    require "config.pairs"
  end }
end)
