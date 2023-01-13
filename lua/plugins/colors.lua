local current_colorscheme = "sonokai"
local g = vim.g
local colorschemes = {
  {
    "sainnhe/sonokai",
    lazy = false,
    config = function()
      g.sonokai_enable_italic = 1
      g.sonokai_style = "andromeda"
      vim.cmd "colorscheme sonokai"
    end,
  },
  {
    "shaunsingh/nord.nvim",
    lazy = true,
    config = function()
      g.nord_bold = false
      g.nord_borders = true
      -- vim.cmd "colorscheme nord"
    end,
  },
  {
    "rmehri01/onenord.nvim",
    lazy = true,
    config = function()
      -- vim.cmd "colorscheme onenord"
    end,
  },

  -- nord = {
  --   "arcticicestudio/nord-vim",
  --   lazy = false,
  --   config = function()
  --     vim.cmd "colorscheme nord"
  --   end,
  -- },
}

return colorschemes
