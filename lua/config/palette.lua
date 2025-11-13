local M = {}
local cmd = vim.cmd
local fn = vim.fn

function M.highlight(name, opt)
  -- local t = { "hi!", name }
  -- for k, v in pairs(opts) do
  --   t[#t + 1] = string.format("%s=%s", k, v)
  -- end
  vim.api.nvim_set_hl(0, name, opt)
end

---@diagnostic disable-next-line: unused-local
local codicons = {
  E = { name = "Error", sign = "" },
  W = { name = "Warn", sign = "" },
  I = { name = "Info", sign = "" },
  H = { name = "Hint", sign = "" },
  T = { name = "Text", sign = "" },
}

M.signs = codicons

M.signs.N = M.signs.H

local palettes = {
  sonokai = function()
    local p = vim.fn["sonokai#get_palette"](vim.g.sonokai_style or "default", { a = 1 })
    return {
      black = p.black[1],
      blue = p.blue[1],
      green = p.green[1],
      grey = p.grey[1],
      orange = p.orange[1],
      purple = p.purple[1],
      red = p.red[1],
      yellow = p.yellow[1],
    }
  end,
  one = function()
    return {
      black = "#2e3440",
      blue = "#61afef",
      green = "#98c379",
      grey = "#4b5263",
      orange = "#d19a66",
      purple = "#c678dd",
      red = "#be5046",
      yellow = "#e5c07b",
    }
  end,
  nord = function()
    return {
      black = "#2e3440",
      blue = "#5e81ac",
      green = "#a3be8c",
      grey = "#4c566a",
      orange = "#d08770",
      purple = "#b48ead",
      red = "#bf616a",
      yellow = "#ebcb8b",
    }
  end,
  everforest = function()
    return {
      black = "#2d353b",
      blue = "#7fbbb3",
      green = "#a7c080",
      grey = "#859289",
      orange = "#e3986d",
      purple = "#d699b6",
      red = "#e67e80",
      yellow = "#dbbc7f",
    }
  end,
}

-- Returns a dictionary of current common colors
function M.generate_palette()
  M.palette = palettes[vim.g.colors_name] or palettes["nord"]
  return M.palette()
end

function M.link(dst, src)
  vim.api.nvim_set_hl(0, dst, { link = src })
end

function M.get_hl(name)
  return vim.api.nvim_get_hl(0, { name = name })
end

-- Creates highlights for:
-- - Color names
-- Diagnostics
-- Statusline
function M.setup()
  local highlight = M.highlight
  local link = M.link

  local p = M.generate_palette()

  local normal = M.get_hl "Normal"
  local dark = require("darken").get_bg_color()

  highlight("Black", { fg = p.black })
  highlight("Blue", { fg = p.blue })
  highlight("Green", { fg = p.green })
  highlight("Grey", { fg = p.grey })
  highlight("Orange", { fg = p.orange })
  highlight("Purple", { fg = p.purple })
  highlight("Red", { fg = p.red })
  highlight("Yellow", { fg = p.yellow })

  highlight("GreenBold", { fg = p.green, bold = true })
  highlight("OrangeBold", { fg = p.orange, bold = true })
  highlight("PurpleBold", { fg = p.purple, bold = true })
  highlight("RedBold", { fg = p.red, bold = true })
  highlight("YellowBold", { fg = p.yellow, bold = true })

  link("TablineSel", "Normal")
  link("HarpoonWindow", "Darkened")
  link("HarpoonBorder", "Darkened")

  link("TelescopeNormal", "Darkened")

  highlight("TelescopeBorder", { fg = dark, bg = dark })
  highlight("TelescopePromptTitle", { bg = p.red, fg = "bg" })
  highlight("TelescopePreviewTitle", { bg = p.green, fg = "bg" })
  highlight("TelescopeResultsTitle", { bg = dark, fg = dark })

  highlight("TelescopePromptBorder", { fg = "bg", bg = "bg" })

  link("TelescopeResultsBorder", "TelescopeBorder")
  link("TelescopePreviewBorder", "TelescopeBorder")

  link("TelescopePromptNormal", "Normal")
  link("TelescopePreviewNormal", "Darkened")

  link("STError", "Red")
  link("InlayHint", "Grey")
  link("STWarning", "Orange")
  link("STInfo", "Blue")
  link("STHint", "Green")

  link("AerialLine", "QuickFixLine")
  -- link("GitSignsCurrentLineBlame", "Comment")
  -- link("FocusedSymbol", "GreenInv")

  -- Less obtrusive folds

  -- highlight('debugPC', "bg", p.green)
  -- highlight('debugBreakpoint', p.red, "bg")

  for _, icon in pairs(M.signs) do
    local name = "DiagnosticSign" .. icon.name
    fn.sign_define(name, { text = icon.sign, texthl = name, numhl = name })
  end

  link("DiagnosticSignError", "Red")
  link("DiagnosticSignWarn", "Orange")
  link("DiagnosticSignInfo", "Blue")
  link("DiagnosticSignHint", "Green")
  link("DiagnosticSignText", "Grey")

  vim.diagnostic.config {
    virtual_text = {
      prefix = function(diagnostic)
        local signs = require("config.palette").signs
        local severity_names = { "E", "W", "I", "H" }
        local severity_name = severity_names[diagnostic.severity]
        return signs[severity_name] and signs[severity_name].sign or ""
      end,
    },
  }

  highlight("DapBreakpoint", { bold = true })
  -- highlight("DapStopped", { fg = "NONE", bg = p.green, guisp = "NONE" })
  link("DapStopped", "CursorLine")

  fn.sign_define("DapBreakpoint", { text = "󰧞", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
  fn.sign_define("DapBreakpointCondition", { text = "", texthl = "Blue", linehl = "DapStopped", numhl = "" })
  fn.sign_define("DapBreakpointRejected", { text = "", texthl = "Red", linehl = "DapStopped", numhl = "" })
  fn.sign_define("DapLogPoint", { text = "", texthl = "Red", linehl = "DapStopped", numhl = "" })
  fn.sign_define("DapStopped", { text = "󰐊", texthl = "Green", linehl = "DapStopped", numhl = "" })

  link("LeapBackdrop", "Comment")

  if vim.g.statusline_provider == "heirline" then
    require("config.heirline").setup()
  end
end

return M
