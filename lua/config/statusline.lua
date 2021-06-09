
local api = vim.api
local fn = vim.fn
local cmd = vim.cmd

local lsp = require'config.lsp'
local icons = require'nvim-web-devicons'

local M = {}

local special_map = {
  NvimTree = 'Files',
  Outline = 'Outline'
}

local branch = ''

local mode_map = {
  ['n']   = { hl = '%#BlueSpecial#',   val = 'N'  },
  ['no']  = { hl = '%#BlueSpecial#',   val = 'NO' },

  ['v']   = { hl = '%#PurpleSpecial#', val = 'V'  },
  ['V']   = { hl = '%#PurpleSpecial#', val = 'VL' },
  ['\22'] = { hl = '%#PurpleSpecial#', val = 'VB' },

  ['i']   = { hl = '%#GreenSpecial#',  val = 'I'  },
  ['ic']  = { hl = '%#GreenSpecial#',  val = 'I'  },
  ['ix']  = { hl = '%#GreenSpecial#',  val = 'I'  },

  ['R']   = { hl = '%#RedSpecial#',    val = 'R'  },
  ['Rv']  = { hl = '%#RedSpecial#',    val = 'VR' },

  ['t']   = { hl = '%#OrangeSpecial#', val = 'T'  },

  ['s']   = { hl = '%#YellowSpecial#', val = 'S'  },
  ['S']   = { hl = '%#YellowSpecial#', val = 'SL' },
  ['^S']  = { hl = '%#YellowSpecial#', val = 'SB' },
  ['c']   = { hl = '%#YellowSpecial#', val = 'C'  },
  ['cv']  = { hl = '%#YellowSpecial#', val = 'E'  },
  ['ce']  = { hl = '%#YellowSpecial#', val = 'E'  },
  ['r']   = { hl = '%#YellowSpecial#', val = 'P'  },
  ['rm']  = { hl = '%#YellowSpecial#', val = 'M'  },
  ['r?']  = { hl = '%#YellowSpecial#', val = 'C'  },
  ['!']   = { hl = '%#YellowSpecial#', val = 'SH' },
}

local function get_mode()
  local mode = api.nvim_get_mode().mode
  return mode_map[mode] or { val = '', hl = '%#Normal#' }
end

local function get_git(highlight)
  local signs = vim.b.gitsigns_status_dict

  if not signs then
    branch = ''
    return ''
  end

  branch = signs.head
  branch = branch and (' ' .. branch)

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
  local path, filename, extension = fn.expand('%:~:.'), fn.expand('%:t'), fn.expand('%:e')
  if #filename == 0 then
    return '[NO NAME]'
  end

  local icon, icon_hl = icons.get_icon(filename, extension, { default = true })

  if highlight then
    return string.format('%%#%s#%s %%#Normal#%s', icon_hl, icon ,path)
  else
    return string.format('%s %s', icon ,path)
  end
end

local t = {}

function M.update()
  local bufnr = fn.bufnr('%')
  local ft, readonly, row, col, percent = get_infos(bufnr)

  local special = special_map[ft]
  if special then
    return special
  end

  local mode = get_mode()
  local path = get_path(true)
  local git = get_git(true)
  local diag = lsp.statusline(bufnr, true)

  local items = {
    mode.val, branch, path, git, readonly and '' or '',
    '%=',
    diag, percent, row .. ':' .. col
  }

  local hl = {
    mode.hl, '%#Orange#', '%#Purple#', '', '%#Red#',
    '%#Normal#',
    '%#Normal#', '%#Orange#', mode.hl
  }


  local i = 1
  for j,v in ipairs(items) do
    if #v ~= 0 then
      t[i] = string.format('%s %s ', hl[j], v)
      i = i + 1
    end
  end
  t[i] = nil

  local s = table.concat(t)
  return s
end

local u = {}
function M.update_inactive()
  local bufnr = fn.bufnr('%')
  local ft, readonly, row, col, percent = get_infos(bufnr)

  local special = special_map[ft]
  if special then
    return special
  end

  local mode = get_mode()
  local path = get_path(false)

  local items = {
    mode.val, branch, path, readonly and '' or '',
    '%=',
    percent, row .. ':' .. col
  }

  local i = 1
  for j,v in ipairs(items) do
    if #v ~= 0 then
      u[i] = string.format(' %s ', v)
      i = i + 1
    end
  end
  u[i] = nil

  local s = table.concat(u)
  return s
end

vim.o.statusline = '%!v:lua.require\'config.statusline\'.update()'

require'config.palette'.create_highlights()
cmd [[
augroup Statusline
autocmd!
autocmd DirChanged * lua require 'config.statusline'.update_git()
autocmd BufWinEnter,WinEnter,BufEnter * lua vim.wo.statusline=nil
autocmd WinLeave,BufLeave * lua vim.wo.statusline=require'config.statusline'.update_inactive()
augroup END
]]

return M
