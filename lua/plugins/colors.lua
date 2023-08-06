local current_colorscheme = "onedark"
local g = vim.g
local colorschemes = {
  sonokai = {
    "sainnhe/sonokai",
    config = function()
      g.sonokai_enable_italic = 1
      g.sonokai_show_eob = 0
      g.sonokai_style = "andromeda"
      -- g.sonokai_style = "maia"
      vim.cmd.colorscheme "sonokai"
    end,
  },
  onedark = {
    "navarasu/onedark.nvim",
    config = function()
      require("onedark").load()
    end,
  },
}

local t = colorschemes[current_colorscheme]

t.lazy = false
t.priority = 1000

return t
