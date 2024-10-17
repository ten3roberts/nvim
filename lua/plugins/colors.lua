local colorschemes = {
  sonokai = {
    "sainnhe/sonokai",
    config = function()
      vim.g.sonokai_enable_italic = 1
      vim.g.sonokai_float_style = "dim"
      vim.g.sonokai_show_eob = 0
      vim.g.sonokai_style = "andromeda"
      -- vim.g.sonokai_style = "maia"
      vim.cmd.colorscheme "sonokai"
    end,
  },
  nord = {
    "gbprod/nord.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("nord").setup {}
      vim.cmd.colorscheme "nord"
    end,
  },
  nordic = {
    "AlexvZyl/nordic.nvim",
    config = function()
      require("nordic").load()
    end,
  },
  install = {
    colorscheme = { "nord" },
  },
  -- onedark = {
  --   "navarasu/onedark.nvim",
  --   config = function()
  --     require("onedark").load()
  --   end,
  -- },
  onedarkpro = {
    "olimorris/onedarkpro.nvim",
    opts = {
      -- colors = Colors,
      -- highlights = require "config.ui.highlights",
      styles = {
        comments = "italic",
        methods = "bold",
        functions = "bold",
      },
      -- options = {
      --   transparency = false, -- Use a transparent background?
      --   terminal_colors = true, -- Use the colorscheme's colors for Neovim's :terminal?
      --   highlight_inactive_windows = true, -- When the window is out of focus, change the normal background?
      -- },
    },
    config = function(_, opts)
      require("onedarkpro").setup(opts)
      vim.cmd.colorscheme "onedark"
    end,
  },
}

local current_colorscheme = "sonokai"

local t = colorschemes[current_colorscheme]

t.lazy = false
t.priority = 1000

return t
