
local api = vim.api
local fn = vim.fn
local cmd = vim.cmd

local lsp = require'config.lsp'
local icons = require'nvim-web-devicons'

local M = {}

local special_map = {
  NvimTree = { '%#Yellow#  Files', '  Files'},
  Outline = { '%#Purple#  Outline', '  Outline'  }
}

local branch = ''

local mode_map = {
  ['n']   = { hl = '%#BlueInv#',   val = 'N'  },
  ['no']  = { hl = '%#BlueInv#',   val = 'NO' },
  ['niI'] = { hl = '%#BlueInv#',   val = 'NI' },

  ['v']   = { hl = '%#PurpleInv#', val = 'V'  },
  ['V']   = { hl = '%#PurpleInv#', val = 'VL' },
  ['niV'] = { hl = '%#PurpleInv#', val = 'VL' },
  ['\22'] = { hl = '%#PurpleInv#', val = 'VB' },

  ['i']   = { hl = '%#GreenInv#',  val = 'I'  },
  ['ic']  = { hl = '%#GreenInv#',  val = 'I'  },
  ['ix']  = { hl = '%#GreenInv#',  val = 'I'  },

  ['R']   = { hl = '%#RedInv#',    val = 'R'  },
  ['Rv']  = { hl = '%#RedInv#',    val = 'VR' },
  ['niR']  = { hl = '%#RedInv#',    val = 'VR' },

  ['t']   = { hl = '%#OrangeInv#', val = 'T'  },

  ['s']   = { hl = '%#YellowInv#', val = 'S'  },
  ['S']   = { hl = '%#YellowInv#', val = 'SL' },
  ['^S']  = { hl = '%#YellowInv#', val = 'SB' },
  ['c']   = { hl = '%#YellowInv#', val = 'C'  },
  ['cv']  = { hl = '%#YellowInv#', val = 'E'  },
  ['ce']  = { hl = '%#YellowInv#', val = 'E'  },
  ['r']   = { hl = '%#YellowInv#', val = 'P'  },
  ['rm']  = { hl = '%#YellowInv#', val = 'M'  },
  ['r?']  = { hl = '%#YellowInv#', val = 'C'  },
  ['!']   = { hl = '%#YellowInv#', val = 'SH' },
}

local function get_mode()
  local mode = api.nvim_get_mode().mode
  return mode_map[mode] or mode_map[mode:sub(1,1)] or { val = mode, hl = '%#Red#' }
end

local function get_git(highlight)
  local signs = vim.b.gitsigns_status_dict

  if not signs then
    branch = ''
    return ''
  end

  branch = signs.head
  branch = branch and (' ' .. branch)

  local added,changed,removed = signs.added or 0, signs.changed or 0, signs.removed or 0

  if highlight then
    return
      (added > 0 and ('%#Green#+' .. added) or '') ..
      (changed > 0 and (' %#Blue#~' .. changed) or '') ..
      (removed > 0 and (' %#Red#-' .. removed) or '')
  else
    return
      (added > 0 and '+' .. added or '') ..
      (changed > 0 and ' ~' .. changed or '') ..
      (removed > 0 and ' ~' .. removed or '')
  end
end

local function get_infos(bufnr)
  local ft = api.nvim_buf_get_option(bufnr, 'ft')
  local readonly = vim.fn.getbufvar(bufnr, '&readonly') == 1 or vim.fn.getbufvar(bufnr, '&modifiable') == 0

  local _, row, col = unpack(vim.fn.getpos('.'))
  local num_lines = #api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local percent = string.format('%d', row / num_lines * 100) .. '%%'

  return ft, readonly, row, col, percent
end

local function get_path(highlight)
  if vim.o.buftype == 'quickfix' then
    local info = fn.getwininfo(vim.g.statusline_winid or fn.win_getid(fn.winnr()))
    if #info ~= 1 or info[1].quickfix ~= 1 then
      return ''
   end
    return info[1].variables.quickfix_title or 'Quickfix'
  end

  local path, filename, extension = fn.expand('%:~:.'), fn.expand('%:t'), fn.expand('%:e')
  if #filename == 0 then
    return '[NO NAME]'
  end

  local icon, icon_hl = icons.get_icon(filename, extension)

  if highlight then
    return string.format('%%#%s#%s %%#Normal#%s', icon_hl or '', icon or '', path)
  else
    return string.format('%s %s', icon ,path)
  end
end

function M.update()
  local bufnr = fn.bufnr('%')
  local ft, readonly, row, col, percent = get_infos(bufnr)

  local special = special_map[ft]
  if special then
    return special[1]
  end

  local mode = get_mode()
  local path = get_path(true)
  local git = get_git(true)
  local diag = lsp.statusline(bufnr, true)

  local items = {
    mode.val, branch, path, diag, readonly and '' or '',
    '%=',
    git, percent, row .. ':' .. col
  }

  local hl = {
    mode.hl, '%#Orange#', '%#Purple#', '', '%#Red#',
    '%#Normal#',
    '%#Normal#', '%#Orange#', mode.hl
  }


  local t = {}
  for j,v in ipairs(items) do
    if v ~= nil and #v ~= 0 then
      t[#t+1] = string.format('%s %s ', hl[j] or '', v)
    end
  end

  local s = table.concat(t)
  return s
end

function M.update_inactive()
  local bufnr = fn.bufnr('%')
  local ft, readonly, row, col, percent = get_infos(bufnr)

  local special = special_map[ft]
  if special then
    return special[2]
  end

  local mode = get_mode()
  local path = get_path(false)

  local items = {
    mode.val, branch, path, readonly and '' or '',
    '%=',
    percent, row .. ':' .. col
  }

  local t = {}
  for _,v in ipairs(items) do
    if #v ~= 0 then
      t[#t+1] = string.format(' %s ', v)
    end
  end

  local s = table.concat(t)
  return s
end

function M.setup()
  vim.o.statusline = '%!v:lua.require\'config.statusline\'.update()'

  cmd [[
  augroup Statusline
  autocmd!
  autocmd BufWinEnter,WinEnter,BufEnter * lua vim.wo.statusline='%!v:lua.require\'config.statusline\'.update()'
  autocmd WinLeave,BufLeave * lua vim.wo.statusline=require'config.statusline'.update_inactive()
  autocmd ColorScheme * lua require 'config.palette'.setup()
  augroup END
  ]]
end

return M
