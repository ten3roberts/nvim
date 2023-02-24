return {

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
        filetypes = { "qf", "help", "dap.*", "aerial" },
      }
    end,
  },
  {
    "ten3roberts/recipe.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },

    keys = {
      { "<leader>e", "<cmd>Telescope recipe pick_recipe<CR>" },
      { "`<CR>", "<cmd>RecipeBake! check<CR>" },
    },
    config = function()
      require("recipe").setup {
        term = {
          auto_close = false,
          kind = "float",
        },
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
        "<leader><A-w>",
        function()
          require("window-picker").zap()
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
        stages = "slide",
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
    "karb94/neoscroll.nvim",
    config = function()
      require("neoscroll").setup {
        -- All these keys will be mapped to their corresponding default scrolling animation
        -- mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
        easing_function = "quadratic",

        -- hide_cursor = true, -- Hide cursor while scrolling
        -- stop_eof = true, -- Stop at <EOF> when scrolling downwards
        -- respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
        -- cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
        -- easing_function = nil, -- Default easing function
        -- pre_hook = nil, -- Function to run before the scrolling animation starts
        -- post_hook = nil, -- Function to run after the scrolling animation ends
        -- performance_mode = false, -- Disable "Performance Mode" on all buffers.
      }
    end,
  },
  -- {
  --   "declancm/cinnamon.nvim",
  --   enabled = true,
  --   config = function()
  --     require("cinnamon").setup {
  --       extra_keymaps = true,
  --       default_delay = 2,
  --     }
  --   end,
  -- },

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
    "ggandor/flit.nvim",
    dependencies = { "ggandor/leap.nvim" },
    config = function()
      require("flit").setup {}
    end,
  },

  {
    "cbochs/grapple.nvim",
    enabled = false,
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
    "Saecki/crates.nvim",
    dependencies = {
      "jose-elias-alvarez/null-ls.nvim",
      "nvim-lua/plenary.nvim",
    },
    filetype = "toml",
    config = function()
      require("crates").setup {
        popup = {
          autofocus = true,
        },
        null_ls = {
          enabled = true,
          name = "Crates",
        },
      }
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

  -- auto-resize windows
  -- {
  --   enabled = true,
  --   "anuvyklack/windows.nvim",
  --   event = { "WinNew", "WinEnter" },
  --   dependencies = {
  --     { "anuvyklack/middleclass" },
  --     { "anuvyklack/animation.nvim", enabled = true },
  --   },
  --   keys = { { "<leader>Z", "<cmd>WindowsMaximize<cr>" } },
  --   config = function()
  --     vim.o.winwidth = 5
  --     vim.o.winminwidth = 5
  --     vim.o.equalalways = false
  --     require("windows").setup {
  --       animation = { enable = false, duration = 150 },
  --     }
  --   end,
  -- },

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
    "johmsalas/text-case.nvim",
    config = function()
      require("textcase").setup {}
    end,
  },
  {
    "monaqa/dial.nvim",
    -- lazy-load on keys
    -- mode is `n` by default. For more advanced options, check the section on key mappings
    keys = {
      { "<C-a>", "<Plug>(dial-increment)", mode = { "n", "v" } },
      { "<C-x>", "<Plug>(dial-decrement)", mode = { "n", "v" } },
      { "g<C-a>", "g<Plug>(dial-increment)", mode = { "v" } },
      { "g<C-x>", "g<Plug>(dial-decrement)", mode = { "v" } },
    },
    config = function()
      local augend = require "dial.augend"
      require("dial.config").augends:register_group {
        default = {
          augend.integer.alias.decimal, -- nonnegative decimal number (0, 1, 2, 3, ...)
          augend.integer.alias.hex, -- nonnegative hex number  (0x01, 0x1a1f, etc.)
          augend.date.alias["%Y/%m/%d"], -- date (2022/02/19, etc.)
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
    "gbprod/yanky.nvim",
    keys = {
      { "y", "<Plug>(YankyYank)", mode = { "n", "x" } },
      { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" } },
      { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" } },
      { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" } },
      { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" } },
      { "<A-n>", "<Plug>(YankyCycleForward)" },
      { "<A-p>", "<Plug>(YankyCycleBackward)" },
      {
        "<C-p>",
        function()
          require("telescope").extensions.yank_history.yank_history {}
        end,
      },
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
    end,
  },

  {
    "mcauley-penney/tidy.nvim",
    event = "BufWritePre",
    config = function()
      require("tidy").setup()
    end,
  },

  { "stevearc/stickybuf.nvim", config = function() end },

  -- "haya14busa/vim-asterisk",
  "tpope/vim-commentary",
  "tpope/vim-abolish",
  "tpope/vim-rsi",
  "tpope/vim-sleuth",
  "tpope/vim-repeat",
  "mg979/vim-visual-multi",
}
