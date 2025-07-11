return {
  {
    "ten3roberts/graphene.nvim",
    config = function()
      local graphene = require "graphene"
      graphene.setup {
        show_hidden = true,
      }
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
    "andymass/vim-matchup",
    enabled = false,
    config = function()
      vim.g.matchup_matchparen_deferred = 1
    end,
  },
  {
    -- File icons
    "kyazdani42/nvim-web-devicons",
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
        max_parallel_requests = 16,
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
    keys = {
      {
        "<C-a>",
        mode = "n",
      },
      {
        "<C-x>",
        mode = "n",
      },
      {
        "g<C-a>",
        mode = "n",
      },
      {
        "g<C-x>",
        mode = "n",
      },
      {
        "<C-a>",
        mode = "v",
      },
      {
        "<C-x>",
        mode = "v",
      },
      {
        "g<C-a>",
        mode = "v",
      },
      {
        "g<C-x>",
        mode = "v",
      },
    },
    config = function()
      local augend = require "dial.augend"
      require("dial.config").augends:register_group {
        default = {
          augend.decimal_fraction.new {
            signed = true,
            point_char = ".",
          },
          augend.integer.alias.decimal_int, -- nonnegative decimal number (0, 1, 2, 3, ...)
          augend.constant.alias.bool,
          augend.integer.alias.hex, -- nonnegative hex number  (0x01, 0x1a1f, etc.)
          augend.semver.alias.semver, -- nonnegative hex number  (0x01, 0x1a1f, etc.)
          augend.date.alias["%Y/%m/%d"], -- date (2022/02/19, etc.)
          augend.date.alias["%Y-%m-%d"], -- date (2022-02-19, etc.)
        },
      }

      vim.keymap.set("n", "<C-a>", require("dial.map").inc_normal(), { noremap = true })
      vim.keymap.set("n", "<C-x>", require("dial.map").dec_normal(), { noremap = true })
      vim.keymap.set("n", "g<C-a>", require("dial.map").inc_gnormal(), { noremap = true })
      vim.keymap.set("n", "g<C-x>", require("dial.map").dec_gnormal(), { noremap = true })
      vim.keymap.set("v", "<C-a>", require("dial.map").inc_visual(), { noremap = true })
      vim.keymap.set("v", "<C-x>", require("dial.map").dec_visual(), { noremap = true })
      vim.keymap.set("v", "g<C-a>", require("dial.map").inc_gvisual(), { noremap = true })
      vim.keymap.set("v", "g<C-x>", require("dial.map").dec_gvisual(), { noremap = true })
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
    lazy = true,
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
        ring = {},
        system_clipboard = {
          sync_with_ring = false,
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
    end,
  },

  "ten3roberts/wgsl.vim",
  "tpope/vim-abolish",
  "tpope/vim-rsi",
  "tpope/vim-sleuth",
  "tpope/vim-repeat",
  "mg979/vim-visual-multi",
  "lervag/vimtex",
}
