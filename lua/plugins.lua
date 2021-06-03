local fn = vim.fn

-- Auto install packer.nvim if not exists
if fn.empty(fn.glob('~/.local/share/nvim/site/pack/packer/start/packer.nvim')) > 0 then
  print 'Downloading packer'
  vim.api.nvim_exec('!git clone https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim', false)
end

vim.cmd [[packadd packer.nvim]]


return require('packer').startup(function()
  use 'wbthomason/packer.nvim'
  use 'tpope/vim-commentary'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-surround'

  -- Colorschemes
  use 'rakr/vim-one'
  use 'arcticicestudio/nord-vim'

  use {
    'kyazdani42/nvim-tree.lua',
    requires = 'kyazdani42/nvim-web-devicons',
    setup = function()
      vim.g.nvim_tree_ignore = { '.git' }
      vim.g.nvim_tree_width = 28
      vim.g.nvim_tree_auto_open = 1
      vim.g.nvim_tree_auto_close = 1
      vim.g.nvim_tree_disable_netrw = 1
      vim.g.nvim_tree_hijack_netrw = 1
      vim.g.nvim_tree_follow = 1
      vim.g.nvim_tree_tab_open = 1
      vim.g.nvim_tree_lint_lsp = 1
      vim.g.nvim_tree_git_hl = 1
      vim.g.nvim_tree_gitignore = 1
      vim.g.nvim_tree_show_icons = { git = 0, folders = 1, files = 1 }
      vim.g.nvim_tree_group_empty = 1
      vim.g.nvim_tree_lsp_diagnostics = 0
      vim.g.nvim_tree_special_files = {}
    end
  }

  use {
    'romgrk/barbar.nvim',
    requires = 'kyazdani42/nvim-web-devicons',
  }

  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    },
    config = function()
      require('gitsigns').setup()
    end
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    -- run = function() vim.fn('TSUpdate') end,
    config = function() require'nvim-treesitter.configs'.setup {
      ensure_installed = "maintained",
      highlight = {
        enable = true,
      },
      indent = {
        enable = true
      }
    } end
  }

  use 'ray-x/lsp_signature.nvim'
  use 'kabouzeid/nvim-lspinstall'
  use {
    'neovim/nvim-lspconfig', 
    config = function() require 'lsp'.setup() end
  }

  use {
    'hrsh7th/nvim-compe',
    config = function() require 'completion'.setup() end
  }

  use {
    'steelsojka/pears.nvim',
    config = function() require 'pears'.setup() end
  }
end
)
