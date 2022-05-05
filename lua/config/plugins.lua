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

  use '~/dev/nvim/qf.nvim'
  use {
    '~/dev/nvim/graphene.nvim', opt = false, config = function()
      local graphene = require "graphene"
      graphene.setup {}

      vim.keymap.set("n", "<leader>f", graphene.init, {})
      vim.keymap.set("n", "<leader>pe", function() graphene.init(".") end, {})
    end
  }
  use { '~/dev/nvim/wgsl.vim', opt = false }
  use '~/dev/nvim/recipe.nvim'
  use '~/dev/nvim/darken.nvim'
  use '~/dev/nvim/toggle.nvim'
  use '~/dev/nvim/window-picker.nvim'

  -- Colorschemes
  use 'arcticicestudio/nord-vim'
  use 'rakr/vim-one'
  use 'sainnhe/sonokai'

  -- Move arguments and elements in list around
  use 'AndrewRadev/sideways.vim'
  use 'ThePrimeagen/harpoon'
  use {
    'TimUntersberger/neogit',
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require "neogit".setup {
        sections = {
          untracked = {
            folded = false
          },
          unstaged = {
            folded = false
          },
          staged = {
            folded = false
          },
          stashes = {
            folded = true
          },
          unpulled = {
            folded = true
          },
          unmerged = {
            folded = false
          },
          recent = {
            folded = false
          },
        },
      }
    end
  }

  use 'airblade/vim-rooter'

  use {
    'akinsho/git-conflict.nvim',
    config = function()
      require('git-conflict').setup {}
    end
  }

  use { 'andymass/vim-matchup' }
  -- Markdown bullet management
  use 'dkarter/bullets.vim'
  use 'echasnovski/mini.nvim'
  use {
    'folke/zen-mode.nvim',
    config = function()
      require "zen-mode".setup {}
    end
  }

  use {
    'gbprod/yanky.nvim',
    config = function()
      require "yanky".setup {
        ring = {
          history_length = 16,
          storage = "shada",
          sync_with_numbered_registers = true,
        },
        system_clipboard = {
          sync_with_ring = true,
        },
        highlight = {
          on_put = true,
          on_yank = true,
          timer = 200,
        },
        preserve_cursor_position = {
          enabled = true,
        },
      }
    end
  }

  use {
    'ggandor/leap.nvim',
    config = function() require "leap".set_default_keymaps() end
  }

  use 'haya14busa/vim-asterisk'

  -- Autocompletion plugin
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-buffer',
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
  use {
    'karb94/neoscroll.nvim',
    config = function()
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
  use 'kyazdani42/nvim-web-devicons' -- File icons
  use 'lervag/vimtex'
  -- Show changed lines
  use {
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require 'gitsigns'.setup({
        current_line_blame = false,

        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", { expr = true })
          map('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", { expr = true })

          -- Actions
          map({ 'n', 'v' }, '<leader>hs', gs.stage_hunk)
          map({ 'n', 'v' }, '<leader>hr', gs.reset_hunk)
          map('n', '<leader>hS', gs.stage_buffer)
          map('n', '<leader>hu', gs.undo_stage_hunk)
          map('n', '<leader>hR', gs.reset_buffer)
          map('n', '<leader>hp', gs.preview_hunk)
          map('n', '<leader>hb', function() gs.blame_line { full = true } end)
          map('n', '<leader>tb', gs.toggle_current_line_blame)
          map('n', '<leader>hd', gs.diffthis)
          map('n', '<leader>hD', function() gs.diffthis('~') end)
          map('n', '<leader>td', gs.toggle_deleted)

          -- Text object
          map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end
      })
    end
  }

  use 'mbbill/undotree'

  use {
    'mfussenegger/nvim-dap',
    requires = { "rcarriga/nvim-dap-ui" },
    config = function()
      require "config.dbg"
    end
  }

  use {
    'monaqa/dial.nvim',
    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group {
        default = {
          augend.integer.alias.decimal_int,
          augend.hexcolor.new {
            case = "upper",
          },
          augend.hexcolor.new {
            case = "lower",
          },
          augend.integer.alias.hex,
          augend.constant.alias.bool,
          augend.semver.alias.semver,
          augend.date.alias["%Y/%m/%d"],
          augend.date.alias["%Y-%m-%d"],
          augend.date.alias["%m/%d"],
          augend.date.alias["%H:%M"],
          augend.constant.alias.ja_weekday_full,
        },
      }
    end
  }

  -- LSP configurations
  use {
    'neovim/nvim-lspconfig',
    requires = { "williamboman/nvim-lsp-installer", "hrsh7th/nvim-cmp" },
    config = function()
      require "config.lsp"
    end
  }

  -- Highlight colorcodes
  use {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require 'colorizer'.setup(
        { '*' },
        {
        RGB      = true, -- #RGB hex codes
        RRGGBB   = true, -- #RRGGBB hex codes
        names    = true, -- "Name" codes like Blue
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        rgb_fn   = false, -- CSS rgb() and rgba() functions
        hsl_fn   = false, -- CSS hsl() and hsla() functions
        css      = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn   = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
        -- Available mod,s: foreground, background
        mode     = 'foreground', -- Set the display mode.
      })
    end
  }

  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

  use {
    'nvim-telescope/telescope.nvim',
    requires = { 'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-dap.nvim',
      'nvim-telescope/telescope-fzf-native.nvim',
    },
    config = function()
      require "config.telescope"
    end
  }

  -- use {
  --   "nvim-telescope/telescope-frecency.nvim",
  --   config = function()
  --     require "telescope".load_extension("frecency")
  --   end,
  --   requires = { "tami5/sqlite.lua" }
  -- }

  use {
    'nvim-treesitter/nvim-treesitter',
    requires = {
      'RRethy/nvim-treesitter-textsubjects',
      'nvim-treesitter/nvim-treesitter-refactor'
    },
    config = function()
      require 'config.treesitter'
    end
  }

  use {
    'olimorris/persisted.nvim',
    config = function()
      require("persisted").setup({
        save_dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/"), -- directory where session files are saved
        command = "VimLeavePre", -- the autocommand for which the session is saved
        use_git_branch = true, -- create session files based on the branch of the git enabled repository
        autosave = true, -- automatically save session files when exiting Neovim
        autoload = false, -- automatically load the session for the cwd on Neovim startup
      })

    end }

  use 'onsails/lspkind-nvim'
  use 'qxxxb/vim-searchhi' -- Highlight current search match
  use 'rafamadriz/friendly-snippets' -- Preconfigured snippets
  use 'ray-x/lsp_signature.nvim' -- Show function signature help
  use 'rcarriga/nvim-dap-ui'
  use {
    'rcarriga/nvim-notify',
    config = function()
      require "notify".setup {
        timeout = 2000,
        render = "minimal",
        max_width = 80,
      }

      vim.notify = require("notify")
    end
  }

  use { 'simrat39/rust-tools.nvim', config = function() require "config.rust" end }
  use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }
  use { 'stevearc/aerial.nvim', config = function() require "config.aerial" end } -- Symbol tree
  use {
    'stevearc/dressing.nvim',
    requires = { "telescope.nvim" },
    config = function()
      require "dressing".setup {
        select = {
          telescope = require "telescope.themes".get_dropdown {
            border = false,
          }
        }
      }
    end
  }


  use 'stevearc/stickybuf.nvim'
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
  use {
    'windwp/nvim-autopairs',
    requires = 'windwp/nvim-ts-autotag',
    config = function()
      require "config.pairs"
    end
  }
end)
