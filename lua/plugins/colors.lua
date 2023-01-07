local g = vim.g
local colorschemes = {
  sonokai = {
    "sainnhe/sonokai",
    lazy = false,
    config = function()
      g.sonokai_enable_italic = 1
      g.sonokai_style = "andromeda"
      vim.cmd "colorscheme sonokai"
    end,
  },
  nvim_nord = {
    "shaunsingh/nord.nvim",
    lazy = false,
    config = function()
      g.nord_bold = false
      g.nord_borders = true
      vim.cmd "colorscheme nord"
    end,
  },
  onenord = {
    "rmehri01/onenord.nvim",
    lazy = false,
    config = function()
      vim.cmd "colorscheme onenord"
    end,
  },

  nord = {
    "arcticicestudio/nord-vim",
    lazy = false,
    config = function()
      vim.cmd "colorscheme nord"
    end,
  },
}

local current_colorscheme = "sonokai"

return colorschemes[current_colorscheme] or {}
