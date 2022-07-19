local M = {}
local cmd = vim.cmd
local fn = vim.fn

function M.highlight(name, opts)
  local t = { "hi!", name }
  for k, v in pairs(opts) do
    t[#t + 1] = string.format("%s=%s", k, v)
  end

  cmd(table.concat(t, " "))
end

M.signs = {
  E = { name = "Error", hl = "DiagnosticSignError", sign = "" },
  W = { name = "Warn", hl = "DiagnosticSignWarn", sign = "" },
  I = { name = "Info", hl = "DiagnosticSignInfo", sign = "" },
  H = { name = "Warn", hl = "DiagnosticSignHint", sign = "" },
  T = { name = "Text", hl = "DiagnosticSignHint", sign = "" },
}
M.signs.N = M.signs.H

local palettes = {
  sonokai = function()
    local p = vim.fn["sonokai#get_palette"](vim.g.sonokai_style, { a = 1 })
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
  ["doom-one"] = function()
    return {
      black = "#1b2229",
      blue = "#51afef",
      cyan = "#46d9ff",
      dark_blue = "#2257a0",
      dark_cyan = "#5699af",
      green = "#98be65",
      grey = "#3f444a",
      purple = "#c678dd",
      orange = "#da8548",
      red = "#ff6c6b",
      teal = "#4db5bd",
      violet = "#a9a1e1",
      white = "#efefef",
      yellow = "#ecbe7b",
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
  cmd("hi! link " .. dst .. " " .. src)
end

function M.get_hl(name)
  local id = fn.synIDtrans(fn.hlID(name))

  local fg = fn.synIDattr(id, "fg#")
  local bg = fn.synIDattr(id, "bg#")
  local gui = fn.synIDattr(id, "gui#")

  return { fg = fg, bg = bg, gui = gui }
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
  local normal_bg = normal.bg

  local statusline_bg = M.get_hl("StatusLine").bg
  local comment_fg = M.get_hl("Comment").fg
  local tabline_fill_bg = M.get_hl("TabLineFill").bg

  highlight("Black", { guifg = p.black })
  highlight("Blue", { guifg = p.blue })
  highlight("Green", { guifg = p.green })
  highlight("Grey", { guifg = p.grey })
  highlight("Orange", { guifg = p.orange })
  highlight("Purple", { guifg = p.purple })
  highlight("Red", { guifg = p.red })
  highlight("Yellow", { guifg = p.yellow })

  -- highlight('SL_Black',  p.black)
  -- highlight('SL_Blue',   p.blue)
  -- highlight('SL_Green',  p.green)
  -- highlight('SL_Grey',   p.grey)
  -- highlight('SL_Orange', p.orange)
  -- highlight('SL_Purple', p.purple)
  -- highlight('SL_Red',    p.red)
  -- highlight('SL_Yellow', p.yellow)

  highlight("GreenBold", { guifg = p.green, gui = "bold" })
  highlight("OrangeBold", { guifg = p.orange, gui = "bold" })
  highlight("PurpleBold", { guifg = p.purple, gui = "bold" })
  highlight("RedBold", { guifg = p.red, gui = "bold" })
  highlight("YellowBold", { guifg = p.yellow, gui = "bold" })

  highlight("DiagnosticSignError", { guifg = p.red })
  highlight("DiagnosticSignWarn", { guifg = p.orange })
  highlight("DiagnosticSignInformation", { guifg = p.purple })
  highlight("DiagnosticSignHint", { guifg = p.green })

  -- highlight('LspDiagnosticsUnderlineError',       nil, nil, 'undercurl', p.red)
  -- highlight('LspDiagnosticsUnderlineWarning',     nil, nil, 'undercurl', p.orange)
  -- highlight('LspDiagnosticsUnderlineInformation', nil, nil, 'undercurl', p.blue)
  -- highlight('LspDiagnosticsUnderlineHint',        nil, nil, 'undercurl', p.green)

  highlight("BlackInv", { guifg = normal_bg, guibg = p.black, gui = "bold" })
  highlight("BlueInv", { guifg = normal_bg, guibg = p.blue, gui = "bold" })
  highlight("GreenInv", { guifg = normal_bg, guibg = p.green, gui = "bold" })
  highlight("GreyInv", { guifg = normal_bg, guibg = p.grey, gui = "bold" })
  highlight("OrangeInv", { guifg = normal_bg, guibg = p.orange, gui = "bold" })
  highlight("PurpleInv", { guifg = normal_bg, guibg = p.purple, gui = "bold" })
  highlight("RedInv", { guifg = normal_bg, guibg = p.red, gui = "bold" })
  highlight("YellowInv", { guifg = normal_bg, guibg = p.yellow, gui = "bold" })

  link("TelescopeNormal", "DarkenedBg")
  link("TelescopePromptNormal", "Normal")
  link("TelescopePreviewNormal", "Normal")

  link("STError", "Red")
  link("InlayHint", "Grey")
  link("STWarning", "Orange")
  link("STInfo", "Blue")
  link("STHint", "Green")
  link("GitSignsCurrentLineBlame", "Comment")
  link("FocusedSymbol", "GreenInv")

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
  -- link("Folded", "Comment")

  -- highlight('debugPC', normal_bg, p.green)
  -- highlight('debugBreakpoint', p.red, normal_bg)

  for _, icon in pairs(M.signs) do
    local name = "DiagnosticSign" .. icon.name
    fn.sign_define(icon.hl, { text = icon.sign, texthl = icon.hl, numhl = icon.hl })
    name = "DiagnosticVirtualText" .. icon.name
    fn.sign_define(name, { text = icon.sign, texthl = name, numhl = name })
  end

  -- fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticSignError" })
  -- fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn" })
  -- fn.sign_define("DiagnosticSignInformation", { text = "", texthl = "DiagnosticSignInformation" })
  -- fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

  -- fn.sign_define("DiagnosticVirtualTextError", { text = "", texthl = "DiagnosticSignError" })
  -- fn.sign_define("DiagnosticVirtualTextWarn", { text = "", texthl = "DiagnosticSignWarn" })
  -- fn.sign_define("DiagnosticVirtualTextInformation", { text = "", texthl = "DiagnosticSignInformation" })
  -- fn.sign_define("DiagnosticVirtualTextHint", { text = "", texthl = "DiagnosticSignHint" })

  highlight("DapBreakpoint", { gui = "bold" })
  highlight("DapStopped", { guibg = p.green, guifg = normal.bg })

  fn.sign_define("DapBreakpoint", { text = "●", texthl = "Red", linehl = "", numhl = "" })
  fn.sign_define("DapStopped", { text = "⯈", texthl = "Green", linehl = "DapStopped", numhl = "" })
end

return M
