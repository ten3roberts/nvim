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

local md_icons = {
  E = { name = "Error", hl = "DiagnosticSignError", sign = "󰅙" },
  W = { name = "Warn", hl = "DiagnosticSignWarn", sign = "󰀦" },
  I = { name = "Info", hl = "DiagnosticSignInfo", sign = "󰋼" },
  H = { name = "Warn", hl = "DiagnosticSignHint", sign = "󰌵" },
  T = { name = "Text", hl = "DiagnosticSignHint", sign = "󰌪 " },
}

---@diagnostic disable-next-line: unused-local
local cod_icons = {
  E = { name = "Error", hl = "DiagnosticSignError", sign = "" },
  W = { name = "Warn", hl = "DiagnosticSignWarn", sign = "" },
  I = { name = "Info", hl = "DiagnosticSignInfo", sign = "" },
  H = { name = "Warn", hl = "DiagnosticSignHint", sign = "" },
  T = { name = "Text", hl = "DiagnosticSignHint", sign = "" },
}

M.signs = md_icons

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

  -- highlight('SL_Black',  p.black)
  -- highlight('SL_Blue',   p.blue)
  -- highlight('SL_Green',  p.green)
  -- highlight('SL_Grey',   p.grey)
  -- highlight('SL_Orange', p.orange)
  -- highlight('SL_Purple', p.purple)
  -- highlight('SL_Red',    p.red)
  -- highlight('SL_Yellow', p.yellow)

  highlight("GreenBold", { fg = p.green, bold = true })
  highlight("OrangeBold", { fg = p.orange, bold = true })
  highlight("PurpleBold", { fg = p.purple, bold = true })
  highlight("RedBold", { fg = p.red, bold = true })
  highlight("YellowBold", { fg = p.yellow, bold = true })

  -- highlight("DiagnosticSignError", { fg = p.red })
  -- highlight("DiagnosticSignWarn", { fg = p.orange })
  -- highlight("DiagnosticSignInformation", { fg = p.purple })
  -- highlight("DiagnosticSignHint", { fg = p.green })

  -- highlight('LspDiagnosticsUnderlineError',       nil, nil, 'undercurl', p.red)
  -- highlight('LspDiagnosticsUnderlineWarning',     nil, nil, 'undercurl', p.orange)
  -- highlight('LspDiagnosticsUnderlineInformation', nil, nil, 'undercurl', p.blue)
  -- highlight('LspDiagnosticsUnderlineHint',        nil, nil, 'undercurl', p.green)

  link("HarpoonWindow", "DarkenedBg")
  link("HarpoonBorder", "DarkenedBg")

  link("TelescopeNormal", "DarkenedBg")

  highlight("TelescopeBorder", { fg = dark, bg = dark })
  highlight("TelescopePromptTitle", { bg = p.red, fg = "bg" })
  highlight("TelescopePreviewTitle", { bg = p.green, fg = "bg" })
  highlight("TelescopeResultsTitle", { bg = dark, fg = dark })

  highlight("TelescopePromptBorder", { fg = "bg", bg = "bg" })

  link("TelescopeResultsBorder", "TelescopeBorder")
  link("TelescopePreviewBorder", "TelescopeBorder")

  link("TelescopePromptNormal", "Normal")
  link("TelescopePreviewNormal", "DarkenedBg")

  link("STError", "Red")
  link("InlayHint", "Grey")
  link("STWarning", "Orange")
  link("STInfo", "Blue")
  link("STHint", "Green")

  link("AerialLine", "QuickFixLine")
  -- link("GitSignsCurrentLineBlame", "Comment")
  -- link("FocusedSymbol", "GreenInv")

  -- link('DiagnosticError', 'Red')
  -- link('DiagnosticWarning', 'Orange')
  -- link('DiagnosticInformation', 'Blue')
  -- link('DiagnosticHint', 'Green')

  -- highlight('DiagnosticUnderlineError', nil, nil, "undercurl", p.red)
  -- highlight('DiagnosticUnderlineWarn', nil, nil, "undercurl", p.orange)
  -- highlight('DiagnosticUnderlineInformation', nil, nil, "undercurl", p.blue)
  -- highlight('DiagnosticUnderlineHint', nil, nil, "undercurl", p.green)

  -- link('TSError',   'DiagnosticUnderlineError')
  -- link('TSWarning', 'DiagnosticUnderlineWarning')

  -- Less obtrusive folds

  -- highlight('debugPC', "bg", p.green)
  -- highlight('debugBreakpoint', p.red, "bg")

  for _, icon in pairs(M.signs) do
    local name = "DiagnosticSign" .. icon.name
    fn.sign_define(icon.hl, { text = icon.sign, texthl = icon.hl, numhl = icon.hl })
    name = "DiagnosticVirtualText" .. icon.name
    fn.sign_define(name, { text = icon.sign, texthl = name, numhl = name })
  end

  highlight("DapBreakpoint", { bold = true })
  -- highlight("DapStopped", { fg = "NONE", bg = p.green, guisp = "NONE" })
  link("DapStopped", "CursorLine")

  fn.sign_define("DapBreakpoint", { text = "󰧞", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
  fn.sign_define("DapBreakpointCondition", { text = "", texthl = "Blue", linehl = "DapStopped", numhl = "" })
  fn.sign_define("DapBreakpointRejected", { text = "", texthl = "Red", linehl = "DapStopped", numhl = "" })
  fn.sign_define("DapLogPoint", { text = "", texthl = "Red", linehl = "DapStopped", numhl = "" })
  fn.sign_define("DapStopped", { text = "󰐊", texthl = "Green", linehl = "DapStopped", numhl = "" })

  link("LeapBackdrop", "Comment")

  require("config.heirline").setup()
end

return M
