local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "sainnhe/sonokai",
    config = function()
      vim.cmd "colorscheme sonokai"
    end,
  },
  { "rmehri01/onenord.nvim" },

  {
    "ten3roberts/qf.nvim",
    config = function()
      require("qf").setup {
        -- Location list configuration
        ["l"] = {
          auto_close = false, -- Automatically close location/quickfix list if empty
          auto_follow = "prev", -- Follow current entry, possible values: prev,next,nearest
          follow_slow = true, -- Only follow on CursorHold
          auto_open = true, -- Automatically open location list on QuickFixCmdPost
          auto_resize = true, -- Auto resize and shrink location list if less than `max_height`
          max_height = 5, -- Maximum height of location/quickfix list
          min_height = 5, -- Minimum height of location/quickfix list
          wide = false,
          focus_open = false,
        },
        -- Quickfix list configuration
        ["c"] = {
          auto_close = false, -- Automatically close location/quickfix list if empty
          auto_follow = "prev", -- Follow current entry, possible values: prev,next,nearest
          follow_slow = true, -- Only follow on CursorHold
          auto_open = true, -- Automatically open list on QuickFixCmdPost
          auto_resize = true, -- Auto resize and shrink location list if less than `max_height`
          max_height = 8, -- Maximum height of location/quickfix list
          min_height = 5, -- Minumum height of location/quickfix list
          wide = true,
          focus_open = false,
        },
        -- signs = signs,
      }
    end,
  },
  {
    "ten3roberts/graphene.nvim",
    config = function()
      local graphene = require "graphene"
      graphene.setup {}
    end,
  },
  {
    "ten3roberts/darken.nvim",
    config = function()
      require("darken").setup {
        filetypes = { "qf", "aerial" },
      }
    end,
  },
  {
    "ten3roberts/recipe.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },

    config = function()
      require("recipe").setup {
        term = {
          auto_close = false,
        },
        custom_recipes = {},
      }
    end,
  },
  {
    "ten3roberts/window-picker.nvim",

    keys = {
      {
        "<leader>w",
        function()
          require("window-picker").pick()
        end,
      },
      {
        "<leader>W",
        function()
          require("window-picker").swap(false)
        end,
      },
    },
    config = function()
      print "Loading window picker"
      require("window-picker").setup {
        keys = "aorisetngm",
      }
    end,
  },

  {
    "rcarriga/nvim-notify",
    lazy = false,

    keys = { { "<leader>pn", "<cmd>Telescope notify notify<CR>" } },
    config = function()
      require("notify").setup {
        timeout = 1000,
        render = "minimal",
        top_down = false,
        max_width = 120,

        on_open = function(win)
          if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_set_config(win, { border = "single" })
          end
        end,
      }

      vim.notify = require "notify"
    end,
  },
  {
    "TimUntersberger/neogit",
    dev = true,
    dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
    config = function()
      require "config.neogit"
    end,
  },
  {

    "lewis6991/gitsigns.nvim",

    config = function()
      require("gitsigns").setup {

        -- current_line_blame = false,

        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map("n", "]c", gs.next_hunk)
          map("n", "[c", gs.prev_hunk)

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
  },
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("diffview").setup {
        enhanced_diff_hl = true, -- See ':h diffview-config-enhanced_diff_hl'
        view = {

          merge_tool = {
            -- Config for conflicted files in diff views during a merge or rebase.
            -- layout = "diff3_mixed",
            disable_diagnostics = false, -- Temporarily disable diagnostics for conflict buffers while in the view.
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
  },

  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      require "config.dap"
    end,
  },

  -- {
  --   "https://github.com/ahmedkhalf/project.nvim",
  --   config = function()
  --     require("project_nvim").setup {
  --       detection_methods = { "pattern", "lsp" },
  --     }
  --   end,
  -- },

  { "andymass/vim-matchup" },
  {
    "declancm/cinnamon.nvim",
    config = function()
      require("cinnamon").setup {
        extra_keymaps = false,
        default_delay = 3,
      }
    end,
  },

  {
    -- File icons
    "kyazdani42/nvim-web-devicons",
  },
  {
    "ggandor/leap.nvim",
    config = function()
      require("leap").set_default_keymaps()
    end,
  },
  {
    "cbochs/portal.nvim",
    dependencies = {
      "cbochs/grapple.nvim", -- Optional: provides the "grapple" query item
    },
    keys = {
      {
        "<leader>i",
        function()
          require("portal").jump_forward()
        end,
      },
      {

        "<leader>o",
        function()
          require("portal").jump_backward()
        end,
      },
    },
    config = function()
      require("portal").setup {
        -- query = { "grapple", "modified", "different", "valid" },
      }
    end,
  },

  {
    "cbochs/grapple.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
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
  },

  {
    "rmagatti/auto-session",
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
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "petertriho/cmp-git",

      "onsails/lspkind-nvim",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "jose-elias-alvarez/null-ls.nvim",
      "Saecki/crates.nvim",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-path",
      -- "hrsh7th/cmp-nvim-lsp-document-symbol",
      "hrsh7th/cmp-cmdline",
      "ray-x/cmp-treesitter",
    },
    config = function()
      require "config.cmp"
    end,
  },
  { "simrat39/rust-tools.nvim" },
  {
    "Saecki/crates.nvim",
    dependencies = {
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
  },

  -- LSP configurations
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mfussenegger/nvim-dap",
      "hrsh7th/nvim-cmp",
      "tjdevries/nlua.nvim",
      "simrat39/rust-tools.nvim",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "jose-elias-alvarez/null-ls.nvim",
    },
    config = function()
      require "config.null"
      require "config.lsp"
    end,
  },
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup {
        automatic_installation = true,
      }

      require("config.auto_install").ensure_installed {
        "prettier",
        "stylua",
        -- "yamllint",
      }
    end,
  },

  -- Treesitter

  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    config = function()
      require "config.telescope"
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      -- "p00f/nvim-ts-rainbow",
      "nvim-treesitter/playground",
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/nvim-treesitter-refactor",
      "nvim-treesitter/nvim-treesitter-context",
      "RRethy/nvim-treesitter-textsubjects",
    },
    config = function()
      require "config.treesitter"
    end,
  },
  {
    "cshuaimin/ssr.nvim",
    -- init is always executed during startup, but doesn't load the plugin yet.
    init = function()
      vim.keymap.set({ "n", "x" }, "<leader>cR", function()
        -- this require will automatically load the plugin
        require("ssr").open()
      end, { desc = "Structural Replace" })
    end,
  },
  {
    "monaqa/dial.nvim",
    -- lazy-load on keys
    -- mode is `n` by default. For more advanced options, check the section on key mappings
    keys = { "<C-a>", { "<C-x>", mode = "n" } },
    config = function()
      local augend = require "dial.augend"
      require("dial.config").augends:register_group {
        default = {
          augend.constant.alias.bool,
        },
      }
    end,
  },

  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      require "config.snippets"
    end,
  },
  -- Symbol tree
  {
    "stevearc/aerial.nvim",
    config = function()
      require "config.aerial"
    end,
  },
  {
    "stevearc/dressing.nvim",
    dependencies = { "telescope.nvim" },
    config = function()
      require("dressing").setup {
        select = {
          telescope = require("telescope.themes").get_dropdown {
            border = false,
          },
        },
      }
    end,
  },

  {
    "kylechui/nvim-surround",
    config = function()
      require("nvim-surround").setup {
        -- Configuration here, or leave empty to use defaults
      }
    end,
  },
  {
    "windwp/nvim-autopairs",
    dependencies = "windwp/nvim-ts-autotag",
    config = function()
      require "config.pairs"
    end,
  },

  {
    "gbprod/yanky.nvim",
    keys = {
      { "y", "<Plug>(YankyYank)", mode = { "n", "x" } },
      { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" } },
      { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" } },
      { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" } },
      { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" } },
    },
    config = function()
      require("yanky").setup {
        -- ring = {},
        -- system_clipboard = {
        --   sync_with_ring = true,
        -- },
        -- highlight = {
        --   on_put = true,
        --   on_yank = true,
        --   timer = 200,
        -- },
        -- preserve_cursor_position = {
        --   enabled = true,
        -- },
      }

      local telescope = require "telescope"
      telescope.load_extension "yank_history"
      -- vim.keymap.set("n", "<leader>pp", function()
      --   telescope.extensions.yank_history.yank_history {}
      -- end)
    end,
  },

  { "haya14busa/vim-asterisk" },
  { "tpope/vim-commentary" },
  { "tpope/vim-rsi" },
  { "tpope/vim-repeat" },
  { "mg979/vim-visual-multi" },
}, {
  dev = {
    path = "~/dev/nvim",
    ---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
    patterns = { "ten3roberts" }, -- For example {"folke"}
  },
})
