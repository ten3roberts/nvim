local M = {}
local cmd = vim.cmd
local fn = vim.fn

function M.highlight(name, fg, bg, gui, guisp)

  cmd('hi! ' .. name .. ' ' ..
    (fg    and 'guifg=' .. fg    or '') .. ' ' ..
    (bg    and 'guibg=' .. bg    or '') .. ' ' ..
    (gui   and 'gui='   .. gui   or '') .. ' ' ..
    (guisp and 'guisp=' .. guisp or '')
  )
end

function M.link(dst, src)
  cmd ('hi! link ' .. dst .. ' ' .. src)
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
function M.generate_palette()
  M.palette = palettes[vim.g.colors_name]() or palettes['sonokai']
  return M.palette
end


-- Creates highlights for:
-- - Color names
-- Diagnostics
-- Statusline
function M.setup()
  local highlight = M.highlight
  local link = M.link

  local p = M.generate_palette()

  local normal = M.get_hl('Normal')
  local signcolumn_bg = M.get_hl('SignColumn').bg

  local normal_bg = normal.bg


  highlight('Black',  p.black)
  highlight('Blue',   p.blue)
  highlight('Green',  p.green)
  highlight('Grey',   p.grey)
  highlight('Orange', p.orange)
  highlight('Purple', p.purple)
  highlight('Red',    p.red)
  highlight('Yellow', p.yellow)


  highlight('GreenBold',  p.green,  nil, 'bold')
  highlight('OrangeBold', p.orange, nil, 'bold')
  highlight('PurpleBold', p.purple, nil, 'bold')
  highlight('RedBold',    p.red,    nil, 'bold')
  highlight('YellowBold', p.yellow, nil, 'bold')

  highlight('LspDiagnosticsSignError',   p.red, signcolumn_bg)
  highlight('LspDiagnosticsSignWarning', p.orange, signcolumn_bg)
  highlight('LspDiagnosticsSignInfo',    p.purple, signcolumn_bg)
  highlight('LspDiagnosticsSignHint',    p.green, signcolumn_bg)

  highlight('LspDiagnosticsUnderlineWarning', nil, nil, 'undercurl', p.orange)

  highlight('BlackInv',  normal_bg, p.black,  'bold')
  highlight('BlueInv',   normal_bg, p.blue,   'bold')
  highlight('GreenInv',  normal_bg, p.green,  'bold')
  highlight('GreyInv',   normal_bg, p.grey,   'bold')
  highlight('OrangeInv', normal_bg, p.orange, 'bold')
  highlight('PurpleInv', normal_bg, p.purple, 'bold')
  highlight('RedInv',    normal_bg, p.red,    'bold')
  highlight('YellowInv', normal_bg, p.yellow, 'bold')

  link('STError',                  'Red')
  link('STWarning',                'Orange')
  link('STInfo',                   'Blue')
  link('STHint',                   'Green')
  link('GitSignsCurrentLineBlame', 'Comment')
  link('FocusedSymbol',            'GreenInv')
end

return M
