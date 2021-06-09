local M = {}
local cmd = vim.cmd
local fn = vim.fn

function M.highlight(name, fg, bg, gui)
  if gui then
    cmd(string.format('hi! %s guifg=%s guibg=%s gui=%s', name, fg, bg, gui))
  else
    cmd(string.format('hi! %s guifg=%s guibg=%s ', name, fg, bg))
  end
end

function M.get_hl(name)
  local id = fn.synIDtrans(fn.hlID(name))

  local fg = fn.synIDattr(id, 'fg#')
  local bg = fn.synIDattr(id, 'bg#')
  local gui = fn.synIDattr(id, 'gui#')

  return {fg=fg, bg=bg, gui=gui}
end

local palettes = {
  sonokai = function()
    local p = vim.fn['sonokai#get_palette'](vim.g.sonokai_style)
    return {
      black  = p.black[1],
      blue   = p.blue[1],
      green  = p.green[1],
      grey   = p.grey[1],
      orange = p.orange[1],
      purple = p.purple[1],
      red    = p.red[1],
      yellow = p.yellow[1],
    }
  end,
  one = function()
    return {
      black  = '#2e3440',
      blue   = '#61afef',
      green  = '#98c379',
      grey   = '#4b5263',
      orange = '#d19a66',
      purple = '#c678dd',
      red    = '#be5046',
      yellow = '#e5c07b',
    }
  end,
  nord = function()
    return {
      black  = '#2e3440',
      blue   = '#5e81ac',
      green  = '#a3be8c',
      grey   = '#4c566a',
      orange = '#d08770',
      purple = '#b48ead',
      red    = '#bf616a',
      yellow = '#ebcb8b',
    }
  end
}

-- Returns a dictionary of current common colors
function M.get_palette()
  return palettes[vim.g.colors_name]() or palettes['sonokai']
end


-- Creates highlights for:
-- - Color names
-- Diagnostics
-- Statusline
function M.create_highlights()
  local highlight = M.highlight
  local p = M.get_palette()

  local normal = M.get_hl('Normal')
  local signcolumn = M.get_hl('SignColumn')

  local normal_bg = normal.bg
  local normal_fg = normal.fg

  local signcolumn_bg = signcolumn.bg

  highlight('Black',  p.black,  normal_bg)
  highlight('Blue',   p.blue,   normal_bg)
  highlight('Green',  p.green,  normal_bg)
  highlight('Grey',   p.grey,   normal_bg)
  highlight('Orange', p.orange, normal_bg)
  highlight('Purple', p.purple, normal_bg)
  highlight('Red',    p.red,    normal_bg)
  highlight('Yellow', p.yellow, normal_bg)

  highlight('LspDiagnosticsSignError',   p.red, signcolumn_bg)
  highlight('LspDiagnosticsSignWarning', p.orange, signcolumn_bg)
  highlight('LspDiagnosticsSignInfo',    p.purple, signcolumn_bg)
  highlight('LspDiagnosticsSignHint',    p.green, signcolumn_bg)

  cmd 'hi! link STError   Red'
  cmd 'hi! link STWarning Orange'
  cmd 'hi! link STInfo    Blue'
  cmd 'hi! link STHint    Green'

  highlight('BlackSpecial',  normal_bg, p.black,  'bold')
  highlight('BlueSpecial',   normal_bg, p.blue,   'bold')
  highlight('GreenSpecial',  normal_bg, p.green,  'bold')
  highlight('GreySpecial',   normal_bg, p.grey,   'bold')
  highlight('OrangeSpecial', normal_bg, p.orange, 'bold')
  highlight('PurpleSpecial', normal_bg, p.purple, 'bold')
  highlight('RedSpecial',    normal_bg, p.red,    'bold')
  highlight('YellowSpecial', normal_bg, p.yellow, 'bold')
end

return M
