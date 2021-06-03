local fn = vim.fn

-- Auto install packer.nvim if not exists
if fn.empty(fn.glob('~/.local/share/nvim/site/pack/packer/start/packer.nvim')) > 0 then
  print 'Downloading packer'
  vim.api.nvim_exec('!git clone https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim', false)
end

vim.cmd [[packadd packer.nvim]]


return require('packer').startup(function()
  use 'wbthomason/packer.nvim' -- Manage plugins

  -- Colorschemes
  use 'rakr/vim-one'
  use 'arcticicestudio/nord-vim'

  use 'junegunn/vim-easy-align' -- Align text blocks
  use { 'svermeulen/vim-easyclip', setup = function() vim.g.EasyClipUseSubstituteDefaults = 0 end } -- More intuitive clipboard
  use 'tpope/vim-commentary' -- Toggle comments
  use 'tpope/vim-fugitive' -- Git management
  use 'tpope/vim-repeat'
  use 'tpope/vim-surround' -- ( surround text )
  use 'tpope/vim-unimpaired' -- Handy bracket mappings

  use { 'justinmk/vim-sneak', config = function() vim.g[ 'sneak#label' ] = 1 end } -- Quickly jump in file by 2 chars

  -- Autoclose brackets
  use {'jiangmiao/auto-pairs', config = function()
    vim.g.AutoPairsCenterLine = 0
    vim.g.AutoPairs = {
      [ '(' ]=')',
      ['[']=']',
      ['{']='}',
      ['<']='>',
      ["'"]="'",
      ['"']='"',
      ["`"]="`",
      ['```']='```',
      ['"""']='"""',
      ["'''"]="'''"
    }
  end
  }


  -- File tree
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
      vim.g.nvim_tree_disable_window_picker = 1
      vim.g.nvim_tree_lsp_diagnostics = 0
      vim.g.nvim_tree_special_files = {}
    end
  }

  -- Show open buffers in tabline
  use { 'romgrk/barbar.nvim', requires = 'kyazdani42/nvim-web-devicons', setup = function()
    vim.g.bufferline = {
      animation = true,
      auto_hide = true,
      tabpages = true,
      closable = false,
      clickable = true,
      icons = true,
      icon_custom_colors = false,
      icon_separator_active = '▎',
      icon_separator_inactive = '▎',
      icon_close_tab = '',
      icon_close_tab_modified = '●',
      maximum_padding = 4,
      maximum_length = 30,
      semantic_letters = true,
      letters = 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP',
      no_name_title = nil,
    }
  end
  }

  -- Show changed lines
  use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' }, config = function() require('gitsigns').setup() end }

  -- Better syntax highlighting using treesitter parsing
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

  -- Show function signature help
  use 'ray-x/lsp_signature.nvim'

  -- Automatically install lsp servers
  use 'kabouzeid/nvim-lspinstall'

  -- LSP configurations
  use { 'neovim/nvim-lspconfig', config = function() require 'lsp'.setup() end }

  -- Smart autocompletion
  use { 'hrsh7th/nvim-compe', config = function() require 'completion' end }

  -- Fuzzy finder
  use {"nvim-telescope/telescope.nvim", requires = { 'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim' }, config = function() require 'telescope_conf' end}
  use { "nvim-telescope/telescope-fzy-native.nvim" }
  use { "nvim-telescope/telescope-project.nvim" }
end
)
