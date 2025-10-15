return {
  {
    "ten3roberts/darken.nvim",
    config = function()
      require("darken").setup {
        filetypes = { "qf", "help", "dap.*", "aerial" },
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
    "cshuaimin/ssr.nvim",
    -- init is always executed during startup, but doesn't load the plugin yet.
    init = function()
      local keybinds = require("config.keybind_definitions")
      vim.keymap.set({ "n", "x" }, keybinds.getKeybind("ssr-open"), function()
        -- this require will automatically load the plugin
        require("ssr").open()
      end, { desc = keybinds.getDesc("ssr-open") })
    end,
  },
  {
    "johmsalas/text-case.nvim",
    config = function()
      require("textcase").setup {}
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

  "ten3roberts/wgsl.vim",
  "tpope/vim-abolish",
  "tpope/vim-rsi",
  "tpope/vim-sleuth",
  "tpope/vim-repeat",
  "mg979/vim-visual-multi",
  "lervag/vimtex",
}
