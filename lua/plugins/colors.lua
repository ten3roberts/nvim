local current_colorscheme = "catppuccin"
local g = vim.g
local colorschemes = {
  sonokai = {
    "sainnhe/sonokai",
    config = function()
      g.sonokai_enable_italic = 1
      g.sonokai_show_eob = 0
      -- g.sonokai_style = "andromeda"
      g.sonokai_style = "maia"
      vim.cmd.colorscheme "sonokai"
    end,
  },
  -- nord = {
  --   "shaunsingh/nord.nvim",
  --   config = function()
  --     g.nord_bold = false
  --     g.nord_borders = true
  --     vim.cmd "colorscheme nord"
  --   end,
  -- },
  -- onenord = {
  -- "rmehri01/onenord.nvim",
  -- config = function()
  --   vim.cmd.colorscheme "onenord"
  -- end,
  -- },
  catppuccin = {
    "catppuccin/nvim",
    name = "catppuccin",
    config = function()
      vim.cmd.colorscheme "catppuccin"
    end,
  },
  tokyonight = {
    "folke/tokyonight.nvim",
    config = function()
      vim.cmd.colorscheme "tokyonight"
    end,
  },

  onedark = {
    "navarasu/onedark.nvim",
    config = function()
      vim.cmd.colorscheme "onedark"
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
