-- Auto install packer.nvim if not exists
if vim.fn.empty(vim.fn.glob('~/.local/share/nvim/site/pack/packer/start/packer.nvim')) > 0 then
  print 'Downloading packer'
  vim.api.nvim_exec('!git clone https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim', false)
end

vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
  use 'wbthomason/packer.nvim' -- Manage plugins

  -- My plugins
  use { '~/dev/nvim/toggle.nvim', config = function()
    require'toggle'.setup{}
  end
  }

  use { '~/dev/nvim/qf.nvim', config = function()
    require'qf'.setup{
      -- Location list configuration
      ['l'] = { 
        auto_close = true, -- Automatically close location/quickfix list if empty
        auto_follow = 'prev', -- Follow current entry, possible values: prev,next,nearest
        follow_slow = true, -- Only follow on CursorHold
        auto_open = true, -- Automatically open location list on QuickFixCmdPost
        auto_resize = true, -- Auto resize and shrink location list if less than `max_height`
        max_height = 5, -- Maximum height of location/quickfix list
        min_height = 5, -- Minumum height of location/quickfix list
      },
      -- Quickfix list configuration
      ['c'] = { 
        auto_close = true, -- Automatically close location/quickfix list if empty
        auto_follow = 'prev', -- Follow current entry, possible values: prev,next,nearest
        follow_slow = true, -- Only follow on CursorHold
        auto_open = true, -- Automatically open location list on QuickFixCmdPost
        auto_resize = true, -- Auto resize and shrink location list if less than `max_height`
        max_height = 8, -- Maximum height of location/quickfix list
        min_height = 5, -- Minumum height of location/quickfix list
      }
    }
  end
  }

  -- Colorschemes
  use 'arcticicestudio/nord-vim'
  use 'morhetz/gruvbox'
  use 'rakr/vim-one'
  use 'sainnhe/sonokai'

  use  { 'maxbrunsfeld/vim-yankstack', setup = function() vim.g.yankstack_yank_keys = { 'y', 'd', 'c' } end }
  use 'junegunn/vim-easy-align' -- Align text blocks
  use 'qxxxb/vim-searchhi' -- Highlight current search match
  use 'tpope/vim-commentary' -- Toggle comments
  use 'tpope/vim-unimpaired' -- Handy bracket mappings
  use 'tpope/vim-repeat' -- Repeat plugin commands with .
  use 'dkarter/bullets.vim' -- Markdown bullet management
  use 'tpope/vim-surround' -- ( surround text )
  use 'tpope/vim-fugitive' -- Git management

  use { 'justinmk/vim-sneak', config = function() vim.g[ 'sneak#label' ] = 1 vim.g[ 'sneak#s_next' ] = 1 end } -- Quickly jump in file by 2 chars

  -- Autoclose brackets
  use {'jiangmiao/auto-pairs', config = function()
    vim.g.AutoPairsCenterLine = 0
    vim.g.AutoPairsShortcutToggle = ''
    vim.g.AutoPairs = {
      [ '(' ]=')',
      ['[']=']',
      ['{']='}',
      -- ['<']='>',
      ["'"]="'",
      ['"']='"',
      ["`"]="`",
      ['```']='```',
      ['"""']='"""',
      ["'''"]="'''"
    }
  end
  }

  use { 'iamcco/markdown-preview.nvim', run = function() vim.fn['mkdp#util#install']() end, ft = {'markdown'} }

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
      vim.g.nvim_tree_show_icons = { git = 0, folders = 1, files = 1 }
      vim.g.nvim_tree_group_empty = 1
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

  use {
    'simrat39/symbols-outline.nvim',
    config = function()
      vim.g.symbols_outline = {
        highlight_hovered_item = true,
        show_guides = true,
        auto_preview = false,
        position = 'right',
        keymaps = {
          close = "<C-c>",
          goto_location = "<Cr>",
          focus_location = "o",
          hover_symbol = "<C-space>",
          rename_symbol = "r",
          code_actions = "a",
        },
        lsp_blacklist = {},
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
        enable = true,
      }
    } end
  }

  -- Show function signature help
  use 'ray-x/lsp_signature.nvim'

  -- Automatically install lsp servers
  use 'kabouzeid/nvim-lspinstall'

  -- LSP configurations
  use { 'neovim/nvim-lspconfig', config = function() require 'config.lsp'.setup() end }

  -- Smart autocompletion
  use { 'hrsh7th/nvim-compe', config = function() require 'config.completion' end }
  use 'hrsh7th/vim-vsnip'
  use 'hrsh7th/vim-vsnip-integ'
  use 'rafamadriz/friendly-snippets'

  -- Fuzzy finder
  use {"nvim-telescope/telescope.nvim", requires = { 'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim' }, config = function() require 'config.telescope' end}
  use { "nvim-telescope/telescope-fzy-native.nvim" }
  use { "nvim-telescope/telescope-project.nvim" }
end
)
