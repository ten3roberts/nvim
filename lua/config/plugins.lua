local fn = vim.fn

local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
local packer_bootstrap = false
if fn.empty(fn.glob(install_path)) > 0 then
  print "Downloading packer"
  packer_bootstrap = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  vim.o.runtimepath = vim.fn.stdpath "data" .. "/site/pack/*/start/*," .. vim.o.runtimepath
  vim.cmd [[packadd packer.nvim]]
end

require("packer").startup(function(use)
  -- Packer can manage itself
  use "wbthomason/packer.nvim"

  use "~/dev/nvim/qf.nvim"
  use {
    "~/dev/nvim/graphene.nvim",
    opt = false,
    config = function()
      local graphene = require "graphene"
      graphene.setup {}
    end,
  }
  use { "~/dev/nvim/wgsl.vim", opt = false }
  use "~/dev/nvim/recipe.nvim"
  use {
    "~/dev/nvim/darken.nvim",
    config = function()
      require("darken").setup {
        filetypes = { "qf", "Outline", "help", "dap.*", "aerial" },
      }
    end,
  }

  -- use {
  --   "anuvyklack/windows.nvim",
  --   requires = {
  --     "anuvyklack/middleclass",
  --     "anuvyklack/animation.nvim",
  --   },
  --   config = function()
  --     vim.o.winwidth = 10
  --     vim.o.winminwidth = 10
  --     require("windows").setup {
  --       ignore = { --			  |windows.ignore|
  --         buftype = { "quickfix" },
  --         filetype = { "NvimTree", "neo-tree", "undotree", "gundo", "aerial" },
  --       },
  --     }
  --   end,
  -- }

  use "~/dev/nvim/toggle.nvim"
  use {
    "~/dev/nvim/window-picker.nvim",
    config = function()
      require("window-picker").setup {
        keys = "aorisetngm",
      }
    end,
  }

  -- Colorschemes
  use "sainnhe/sonokai"
  use "rmehri01/onenord.nvim"
  use "folke/tokyonight.nvim"
  use { "catppuccin/nvim", as = "catppuccin" }

  -- Move arguments and elements in list around
  use "AndrewRadev/sideways.vim"
  use {
    "~/dev/nvim/neogit",
    requires = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
    config = function()
      require "config.neogit"
    end,
  }

  use {
    "https://github.com/ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup {
        detection_methods = { "pattern", "lsp" },
      }
    end,
  }

  use { "andymass/vim-matchup" }

  use {
    "gaoDean/autolist.nvim",
    config = function()
      require("autolist").setup {}
    end,
  }

  use {
    "gbprod/yanky.nvim",
    config = function()
      require("yanky").setup {
        ring = {},
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

      local telescope = require "telescope"
      telescope.load_extension "yank_history"
      -- vim.keymap.set("n", "<leader>pp", function()
      --   telescope.extensions.yank_history.yank_history {}
      -- end)
    end,
  }

  use {
    "ggandor/leap.nvim",
    config = function()
      require("leap").set_default_keymaps()
    end,
  }

  use {
    "rhysd/clever-f.vim",
  }

  use "haya14busa/vim-asterisk"

  use {
    "L3MON4D3/LuaSnip",
    config = function()
      require "config.snippets"
    end,
  }

  -- Autocompletion plugin
  use {
    "hrsh7th/nvim-cmp",
    requires = {
      "petertriho/cmp-git",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "jose-elias-alvarez/null-ls.nvim",
      "Saecki/crates.nvim",
      "hrsh7th/cmp-buffer",
      "f3fora/cmp-spell",
      "hrsh7th/cmp-nvim-lsp",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp-document-symbol",
      "hrsh7th/cmp-cmdline",
      "ray-x/cmp-treesitter",
    },
    config = function()
      require "config.cmp"
    end,
  }

  use {
    "willthbill/opener.nvim",
    config = function()
      require("opener").setup {
        post_open = {
          function(dir)
            require("graphene").init(dir)
          end,
        },
      }
      require("telescope").load_extension "opener"

      vim.keymap.set("n", "<leader>F", function()
        require("telescope").extensions.opener.opener {}
      end)
    end,
  }

  use {
    "karb94/neoscroll.nvim",
    config = function()
      local t = {}
      t["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "100", "quadratic" } }
      t["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "100", "quadratic" } }
      -- t["<C-b>"] = { "scroll", { "-vim.api.nvim_win_get_height(0)", "true", "250" } }
      -- t["<C-f>"] = { "scroll", { "vim.api.nvim_win_get_height(0)", "true", "250" } }

      -- t["<C-y>"] = { "scroll", { "-0.10", "false", "100" } }
      -- t["<C-e>"] = { "scroll", { "0.10", "false", "100" } }
      -- t["zt"] = { "zt", { "250" } }
      -- t["zz"] = { "zz", { "250" } }
      -- t["zb"] = { "zb", { "250" } }

      require("neoscroll").setup {}
      require("neoscroll.config").set_mappings(t)
    end,
  }

  use "kyazdani42/nvim-web-devicons" -- File icons
  use "lervag/vimtex"
  -- Show changed lines
  use {
    "lewis6991/gitsigns.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("gitsigns").setup {
        current_line_blame = false,

        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map("n", "]c", "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", { expr = true })
          map("n", "[c", "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", { expr = true })

          -- Actions
          map({ "n", "v" }, "<leader>hs", gs.stage_hunk)
          map({ "n", "v" }, "<leader>hr", gs.reset_hunk)
          map("n", "<leader>hS", gs.stage_buffer)
          map("n", "<leader>hu", gs.undo_stage_hunk)
          map("n", "<leader>hR", gs.reset_buffer)
          map("n", "<leader>hp", gs.preview_hunk)
          map("n", "<leader>hb", function()
            gs.blame_line { full = true }
          end)
          map("n", "<leader>tb", gs.toggle_current_line_blame)
          map("n", "<leader>hd", gs.diffthis)
          map("n", "<leader>hD", function()
            gs.diffthis "~"
          end)
          map("n", "<leader>td", gs.toggle_deleted)

          -- Text object
          map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
        end,
      }
    end,
  }

  use "mbbill/undotree"

  use {
    "mfussenegger/nvim-dap",
    requires = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      require "config.dap"
    end,
  }

  use {
    "monaqa/dial.nvim",
    config = function()
      local augend = require "dial.augend"
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
    end,
  }

  -- LSP configurations
  use {
    "neovim/nvim-lspconfig",
    requires = {
      "hrsh7th/nvim-cmp",
      "tjdevries/nlua.nvim",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require "config.lsp"
    end,
  }

  use {
    "williamboman/mason.nvim",
    requires = {
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup {
        automatic_installation = true,
      }

      require("config.auto_install").ensure_installed {
        "prettier",
        "jq",
        "stylua",
        -- "yamllint",
      }
    end,
  }

  use {
    "jose-elias-alvarez/null-ls.nvim",
    after = "nvim-lspconfig",
    config = function()
      require "config.null"
    end,
  }

  -- Highlight colorcodes
  -- use {
  --   "norcalli/nvim-colorizer.lua",
  --   config = function()
  --     require("colorizer").setup({ "*" }, {
  --       RGB = false, -- #RGB hex codes
  --       RRGGBB = true, -- #RRGGBB hex codes
  --       names = true, -- "Name" codes like Blue
  --       RRGGBBAA = true, -- #RRGGBBAA hex codes
  --       rgb_fn = false, -- CSS rgb() and rgba() functions
  --       hsl_fn = false, -- CSS hsl() and hsla() functions
  --       css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
  --       css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
  --       -- Available mod,s: foreground, background
  --       mode = "foreground", -- Set the display mode.
  --     })
  --   end,
  -- }

  use { "nvim-telescope/telescope-fzf-native.nvim", run = "make" }

  use {
    "nvim-telescope/telescope.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-dap.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    config = function()
      require "config.telescope"
    end,
  }

  use {
    "nvim-treesitter/nvim-treesitter",
    requires = {
      -- "p00f/nvim-ts-rainbow",
      "RRethy/nvim-treesitter-textsubjects",
      "nvim-treesitter/playground",
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/nvim-treesitter-refactor",
      "nvim-treesitter/nvim-treesitter-context",
      "RRethy/nvim-treesitter-textsubjects",
    },
    config = function()
      require "config.treesitter"
    end,
  }

  use {
    "lewis6991/spellsitter.nvim",
    requires = { " nvim-treesitter/nvim-treesitter" },
    config = function()
      require("spellsitter").setup {
        enable = true,
      }
    end,
  }

  use {
    "cbochs/grapple.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      local grapple = require "grapple"
      require("config.treebind").register({
        a = { grapple.tag },
        h = { grapple.popup_tags },
        q = {
          function()
            grapple.select { key = 1 }
          end,
        },
        w = {
          function()
            grapple.select { key = 2 }
          end,
        },
        f = {
          function()
            grapple.select { key = 3 }
          end,
        },
        p = {
          function()
            grapple.select { key = 4 }
          end,
        },
      }, { prefix = "<leader>h" })
    end,
  }

  -- use {
  --   "ThePrimeagen/harpoon",
  --   config = function()
  --     local mark = require "harpoon.mark"
  --     local ui = require "harpoon.ui"

  --     require("harpoon").setup {
  --       menu = {
  --         width = 50,
  --         height = 8,
  --         borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
  --       },
  --     }

  --     require("config.treebind").register({
  --       a = { mark.add_file },
  --       h = { ui.toggle_quick_menu },
  --       q = {
  --         function()
  --           ui.nav_file(1)
  --         end,
  --       },
  --       w = {
  --         function()
  --           ui.nav_file(2)
  --         end,
  --       },
  --       f = {
  --         function()
  --           ui.nav_file(3)
  --         end,
  --       },
  --       p = {
  --         function()
  --           ui.nav_file(4)
  --         end,
  --       },
  --       b = {
  --         function()
  --           ui.nav_file(4)
  --         end,
  --       },
  --     }, { prefix = "<leader>h" })

  --     require("telescope").load_extension "harpoon"
  --   end,
  -- }

  use {
    "rmagatti/auto-session",
    requires = { "rmagatti/session-lens" },
    config = function()
      vim.o.sessionoptions = "buffers,help,tabpages"
      require("auto-session").setup {
        -- log_level = "error",
        auto_session_suppress_dirs = { "~/" },
        -- auto_session_enable_last_session = true,
        -- cwd_change_handling = {
        --   restore_upcoming_session = true,
        --   pre_cwd_changed_hook = nil, -- lua function hook. This is called after auto_session code runs for the `DirChangedPre` autocmd
        --   post_cwd_changed_hook = nil, -- lua function hook. This is called after auto_session code runs for the `DirChanged` autocmd
        -- },
      }

      require("session-lens").setup {}
      require("telescope").load_extension "session-lens"
      vim.keymap.set("n", "<leader>ss", ":SearchSession<CR>", { silent = true })
    end,
  }

  use {
    "nvim-neotest/neotest",
    requires = { "rouge8/neotest-rust" },
    config = function()
      require "config.neotest"
    end,
  }

  use "onsails/lspkind-nvim"
  -- use "qxxxb/vim-searchhi" -- Highlight current search match
  use "rafamadriz/friendly-snippets" -- Preconfigured snippets
  -- Show function signature help
  use {
    "ray-x/lsp_signature.nvim",
    config = function()
      require("lsp_signature").setup {}
    end,
  }
  use "rcarriga/nvim-dap-ui"
  use {
    "rcarriga/nvim-notify",
    config = function()
      require("notify").setup {
        -- timeout = 2000,
        render = "minimal",
        -- max_width = 120,

        on_open = function(win)
          if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_set_config(win, { border = "single" })
          end
        end,
      }

      vim.notify = require "notify"
      local telescope = require "telescope"
      telescope.load_extension "notify"
      vim.keymap.set("n", "<leader>pn", function()
        telescope.extensions.notify.notify {}
      end)
    end,
  }

  use { "simrat39/rust-tools.nvim" }
  use {
    "Saecki/crates.nvim",
    requires = {
      "jose-elias-alvarez/null-ls.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("crates").setup {
        popup = {
          autofocus = true,
        },
        null_ls = {
          enabled = false,
          name = "Crates",
        },
      }
    end,
  }

  use {
    "https://github.com/danymat/neogen",
    config = function()
      local neogen = require "neogen"
      neogen.setup { snippet_engine = "luasnip" }
      require("config.treebind").register({
        ["?"] = { neogen.generate },
      }, { prefix = "<leader>" })
    end,
  }

  use {
    "sindrets/diffview.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("diffview").setup {
        enhanced_diff_hl = false, -- See ':h diffview-config-enhanced_diff_hl'
        view = {

          merge_tool = {
            -- Config for conflicted files in diff views during a merge or rebase.
            layout = "diff3_mixed",
            disable_diagnostics = true, -- Temporarily disable diagnostics for conflict buffers while in the view.
          },
        },
        keymaps = {
          view = {
            ["q"] = "<cmd>DiffviewClose<CR>",
          },
          file_history_panel = {
            ["q"] = "<cmd>DiffviewClose<CR>",
          },
          file_panel = {
            ["q"] = "<cmd>DiffviewClose<CR>",
          },
        },
      }
    end,
  }
  use {
    "stevearc/aerial.nvim",
    config = function()
      require "config.aerial"
    end,
  } -- Symbol tree
  use {
    "stevearc/dressing.nvim",
    requires = { "telescope.nvim" },
    config = function()
      require("dressing").setup {
        select = {
          telescope = require("telescope.themes").get_dropdown {
            border = false,
          },
        },
      }
    end,
  }

  use {
    "kylechui/nvim-surround",
    config = function()
      require("nvim-surround").setup {
        -- Configuration here, or leave empty to use defaults
      }
    end,
  }

  use {
    "echasnovski/mini.nvim",
    config = function()
      require "config.mini"
    end,
  }

  use "mg979/vim-visual-multi"
  use "stevearc/stickybuf.nvim"
  use "tikhomirov/vim-glsl" -- GLSL runtime files
  use "junegunn/vim-easy-align" -- Align text blocks
  use "tpope/vim-abolish" -- Change casing styles and provide smart search and replace
  use "tpope/vim-fugitive" -- Git management
  use "tpope/vim-repeat" -- Repeat plugin commands with .
  use "tpope/vim-rsi" -- Readline mappings in insert mode
  -- use "tpope/vim-dotenv"
  use "tpope/vim-sleuth"
  -- use "tpope/vim-surround" -- ( surround text )
  use "tpope/vim-unimpaired"
  use "tpope/vim-commentary"

  use "wellle/targets.vim" -- Better handling and seeking for textobjects
  use {
    "windwp/nvim-autopairs",
    requires = "windwp/nvim-ts-autotag",
    config = function()
      require "config.pairs"
    end,
  }

  use {
    "davidgranstrom/nvim-markdown-preview",
    config = function()
      vim.g.nvim_markdown_preview_format = "gfm"
      vim.g.nvim_markdown_preview_theme = "github"
    end,
  }

  if packer_bootstrap then
    require("packer").sync()
  end
end)
