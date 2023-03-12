local current_colorscheme = "sonokai"
local g = vim.g
local colorschemes = {
  sonokai = {
    "sainnhe/sonokai",
    config = function()
      g.sonokai_enable_italic = 1
      g.sonokai_style = "andromeda"
      vim.cmd.colorscheme "sonokai"
    end,
  },
  nord = {
    "shaunsingh/nord.nvim",
    config = function()
      g.nord_bold = false
      g.nord_borders = true
      vim.cmd "colorscheme nord"
    end,
  },
  onenord = {
    "rmehri01/onenord.nvim",
    config = function()
      vim.cmd.colorscheme "onenord"
    end,
  },
  catppuccin = {
    "catppuccin/nvim",
    name = "catppuccin",
    config = function()
      vim.cmd.colorscheme "catppuccin"
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

local t = {}

for k, v in pairs(colorschemes) do
  if k == current_colorscheme then
    v.lazy = false
    v.priority = 1000
  else
    v.lazy = true
  end

  table.insert(t, v)
end

return t