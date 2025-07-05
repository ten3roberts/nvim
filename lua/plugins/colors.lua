local colorschemes = {
  sonokai = {
    "sainnhe/sonokai",
    config = function()
      vim.g.sonokai_enable_italic = 1
      vim.g.sonokai_float_style = "dim"
      vim.g.sonokai_show_eob = 0
      vim.g.sonokai_style = "andromeda"
      -- vim.g.sonokai_style = "atlantis"
      vim.cmd.colorscheme "sonokai"
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
  tokyonight = {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      vim.cmd.colorscheme "tokyonight"
    end,
  },
}

local current_colorscheme = "tokyonight"

local t = colorschemes[current_colorscheme]

t.lazy = false
t.priority = 1000

return t
