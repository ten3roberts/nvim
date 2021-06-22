-- Auto install packer.nvim if not exists
if vim.fn.empty(vim.fn.glob('~/.local/share/nvim/site/pack/packer/start/packer.nvim')) > 0 then
  print 'Downloading packer'
  vim.api.nvim_exec('!git clone https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim', false)
end

vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim' -- Manage plugins

  -- My plugins
  use { '~/dev/nvim/toggle.nvim', config = function()
    require'toggle'.setup{
      sets = {
        { 'true', 'false' },
        { 'on', 'off' },
        { 'yes', 'no' },
        { 'manual', 'auto' },
        { 'always', 'never' },
      },
      variants = true,
    }
  end
  }

  use { '~/dev/nvim/qf.nvim', config = function()
    require'qf'.setup{
      -- Location list configuration
      ['l'] = {
        auto_close = false, -- Automatically close location/quickfix list if empty
        auto_follow = 'prev', -- Follow current entry, possible values: prev,next,nearest
        follow_slow = true, -- Only follow on CursorHold
        auto_open = true, -- Automatically open location list on QuickFixCmdPost
        auto_resize = true, -- Auto resize and shrink location list if less than `max_height`
        max_height = 5, -- Maximum height of location/quickfix list
        min_height = 5, -- Minumum height of location/quickfix list
        wide = false,
      },
      -- Quickfix list configuration
      ['c'] = {
        auto_close = true, -- Automatically close location/quickfix list if empty
        auto_follow = false, -- Follow current entry, possible values: prev,next,nearest
        follow_slow = true, -- Only follow on CursorHold
        auto_open = true, -- Automatically open list on QuickFixCmdPost
        auto_resize = true, -- Auto resize and shrink location list if less than `max_height`
        max_height = 8, -- Maximum height of location/quickfix list
        min_height = 5, -- Minumum height of location/quickfix list
        wide = true
      },
      qf_close_loc = true,
    }
  end
  }

  use {
    '~/dev/nvim/darken.nvim',
    config = function()
      require'darken'.setup{
        amount = 0.7,
        filetypes = { 'NvimTree', 'qf', 'help', 'aerial' }
      }
    end
  }

  -- Colorschemes
  use  { 'maxbrunsfeld/vim-yankstack', setup = function() vim.g.yankstack_yank_keys = { 'y', 'd', 'c' } end } -- Easily use the registers
  use 'AndrewRadev/sideways.vim' -- Move arguments and elements in list around
  use 'AndrewRadev/splitjoin.vim' -- Join and breakup statements
  use 'airblade/vim-rooter' -- Change cwd to the git root
  use 'arcticicestudio/nord-vim'
  use 'arecarn/vim-clean-fold'
  use 'dkarter/bullets.vim' -- Markdown bullet management
  use 'junegunn/vim-easy-align' -- Align text blocks
  use 'qxxxb/vim-searchhi' -- Highlight current search match
  use 'rakr/vim-one'
  use 'romgrk/doom-one.vim'
  use 'sainnhe/sonokai'
  use 'tpope/vim-abolish' -- Change casing styles and provide smart search and replce
  use 'tpope/vim-commentary' -- Toggle comments
  use 'tpope/vim-fugitive' -- Git management
  use 'tpope/vim-repeat' -- Repeat plugin commands with .
  use 'tpope/vim-surround' -- ( surround text )
  use 'tpope/vim-unimpaired' -- Handy bracket mappings
  use 'wellle/targets.vim' -- Better handling and seeking for textobjects
  use 'wesQ3/vim-windowswap'

  -- Quickly jump in file by 2 chars
  use { 'justinmk/vim-sneak', config = function()
    vim.g[ 'sneak#label' ] = 1
    vim.g[ 'sneak#s_next' ] = 0
    vim.g[ 'sneak#absolute_dir' ] = 1
    vim.g[ 'sneak#use_ic_scs' ] = 1
  end }

  use { 'iamcco/markdown-preview.nvim', run = function() vim.fn['mkdp#util#install']() end, ft = {'markdown'} }

  use 'LunarWatcher/auto-pairs'

  use {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require'colorizer'.setup(
        { '*' },
        {
          RGB      = true,         -- #RGB hex codes
          RRGGBB   = true,         -- #RRGGBB hex codes
          names    = true,         -- "Name" codes like Blue
          RRGGBBAA = true,        -- #RRGGBBAA hex codes
          rgb_fn   = true,        -- CSS rgb() and rgba() functions
          hsl_fn   = true,        -- CSS hsl() and hsla() functions
          css      = false,        -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
          css_fn   = false,        -- Enable all CSS *functions*: rgb_fn, hsl_fn
          -- Available mod,s: foreground, background
          mode     = 'foreground', -- Set the display mode.
        }
      )
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
      vim.g.nvim_tree_gitignore = 0
      vim.g.nvim_tree_show_icons = {
        git = 0,
        folders = 1,
        files = 1,
        folder_arrows = 0,
      }
      vim.g.nvim_tree_group_empty = 0
      vim.g.nvim_tree_disable_window_picker = 1
      vim.g.nvim_tree_lsp_diagnostics = 1
      vim.g.nvim_tree_special_files = {}
    end
  }

  -- Show open buffers in tabline
  use { 'romgrk/barbar.nvim', requires = 'kyazdani42/nvim-web-devicons', setup = function()
    vim.g.bufferline = {
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
  end
  }

  use 'stevearc/aerial.nvim' -- Symbol tree

  -- Show changed lines
  use {
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('gitsigns').setup({
        current_line_blame = false,
        current_line_blame_delay = 1000,
      })
    end,
  }

  -- Better syntax highlighting using treesitter parsing
  use {
    'nvim-treesitter/nvim-treesitter',
    -- run = function() vim.fn('TSUpdate') end,
    config = function() require'config.treesitter' end
  }

  use 'ray-x/lsp_signature.nvim' -- Show function signature help
  use 'kabouzeid/nvim-lspinstall' -- Automatically install lsp servers

  -- LSP configurations
  use { 'neovim/nvim-lspconfig', config = function() require 'config.lsp'.setup() end }

  -- Smart autocompletion
  use {
    'hrsh7th/nvim-compe',
    config = function()
      require 'config.completion'
    end,
  }

  use 'hrsh7th/vim-vsnip' -- Snippets
  use 'hrsh7th/vim-vsnip-integ' -- Snippet integrations
  use 'rafamadriz/friendly-snippets' -- Preconfigured snippets

  -- Telescope
  use {
    'nvim-telescope/telescope.nvim',
    requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}},
    config = function()
      require 'config.telescope'
    end
  }
  use 'nvim-telescope/telescope-fzy-native.nvim'

  use 'rmagatti/auto-session'
  use {
    'rmagatti/session-lens',
    config = function()
      require'session-lens'.setup {
        shorten_path=false
      }
    end
  }
end
)
