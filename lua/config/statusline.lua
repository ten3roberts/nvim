
local api = vim.api
local g = vim.g
local fn = vim.fn
local cmd = vim.cmd

local lsp = require'config.lsp'
local icons = require'nvim-web-devicons'

local M = {}

local special_map = {
  NvimTree = { '%#Yellow#  Files ', '  Files '},
  Outline = { '%#Purple#  Outline ', '  Outline '  },
  aerial = { '%#Purple# λ Aerial ', ' λ Aerial '  }
}

local special_tab = {
  NvimTree = '',
  qf = '',
  aerial = '',
}

local mode_map = {
  ['n']   = { hl = '%#BlueInv#',   val = ' N '  },
  ['no']  = { hl = '%#BlueInv#',   val = ' NO ' },
  ['niI'] = { hl = '%#BlueInv#',   val = ' NI ' },

  ['v']   = { hl = '%#PurpleInv#', val = ' V '  },
  ['V']   = { hl = '%#PurpleInv#', val = ' VL ' },
  ['niV'] = { hl = '%#PurpleInv#', val = ' VL ' },
  ['\22'] = { hl = '%#PurpleInv#', val = ' VB ' },

  ['i']   = { hl = '%#GreenInv#',  val = ' I '  },
  ['ic']  = { hl = '%#GreenInv#',  val = ' I '  },
  ['ix']  = { hl = '%#GreenInv#',  val = ' I '  },

  ['R']   = { hl = '%#RedInv#',    val = ' R '  },
  ['Rv']  = { hl = '%#RedInv#',    val = ' VR ' },
  ['niR'] = { hl = '%#RedInv#',    val = ' VR ' },

  ['t']   = { hl = '%#OrangeInv#', val = ' T '  },

  ['s']   = { hl = '%#YellowInv#', val = ' S '  },
  ['S']   = { hl = '%#YellowInv#', val = ' SL ' },
  ['^S']  = { hl = '%#YellowInv#', val = ' SB ' },
  ['c']   = { hl = '%#YellowInv#', val = ' C '  },
  ['cv']  = { hl = '%#YellowInv#', val = ' E '  },
  ['ce']  = { hl = '%#YellowInv#', val = ' E '  },
  ['r']   = { hl = '%#YellowInv#', val = ' P '  },
  ['rm']  = { hl = '%#YellowInv#', val = ' M '  },
  ['r?']  = { hl = '%#YellowInv#', val = ' C '  },
  ['!']   = { hl = '%#YellowInv#', val = ' SH ' },
}

local function get_mode()
  local mode = api.nvim_get_mode().mode
  return mode_map[mode] or mode_map[mode:sub(1,1)] or { val = mode, hl = '%#Red#' }
end

local function get_git(highlight)
  local signs = vim.b.gitsigns_status_dict

  if not signs then
    return '',''
  end

  local branch = signs.head
  branch = branch and (' ' .. branch .. ' ') or ''

  local added,changed,removed = signs.added or 0, signs.changed or 0, signs.removed or 0

  local total = added + changed + removed
  local rel_added, rel_changed, rel_removed =
    math.ceil(added / total * 3), math.ceil(changed / total * 3), math.ceil(removed / total * 3)

  if highlight then
    return '%#Orange#' .. branch,
      (rel_added > 0 and ('%#Green#' .. string.rep('+', rel_added) .. ' ') or '') ..
      (rel_changed > 0 and ('%#Blue#' .. string.rep('~', rel_changed) .. ' ') or '') ..
      (rel_removed > 0 and ('%#Red#' .. string.rep('-', rel_removed) .. ' ') or '')
  else
    return branch,
      (rel_added > 0 and (string.rep('+', rel_added) .. ' ') or '') ..
      (rel_changed > 0 and (string.rep('~', rel_changed) .. ' ') or '') ..
      (rel_removed > 0 and (string.rep('-', rel_removed) .. ' ') or '')
  end

  -- if highlight then
  --   return '%#Orange#' .. branch,
  --     (added > 0 and ('%#Green#+' .. added .. ' ') or '') ..
  --     (changed > 0 and ('%#Blue#~' .. changed .. ' ') or '') ..
  --     (removed > 0 and ('%#Red#-' .. removed .. ' ') or '')
  -- else
  --   return branch,
  --     (added > 0 and ' +' .. added or '') ..
  --     (changed > 0 and ' ~' .. changed or '') ..
  --     (removed > 0 and ' ~' .. removed or '')
  -- end
end

local function get_infos(bufnr)
  local ft = api.nvim_buf_get_option(bufnr, 'ft')
  local readonly = fn.getbufvar(bufnr, '&readonly') == 1 or fn.getbufvar(bufnr, '&modifiable') == 0

  local _, row, col = unpack(fn.getpos('.'))
  local num_lines = #api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local percent = string.format('%d', row / num_lines * 100) .. '%%'

  return ft, readonly, row, col, percent
end

local function get_path(highlight)
  local modified = vim.o.modified

  if vim.o.buftype == 'quickfix' then
    local info = fn.getwininfo(vim.g.statusline_winid or fn.win_getid(fn.winnr()))
    if #info ~= 1 or info[1].quickfix ~= 1 then
      return ''
    end
    return (info[1].variables.quickfix_title or 'Quickfix') .. ' '
  end

  local path, filename, extension = fn.expand('%:~:.'), fn.expand('%:t'), fn.expand('%:e')
  if filename == '' then
    return '[NO NAME] '
  end

  local icon, icon_hl = icons.get_icon(filename, extension)

  if highlight then
    return string.format('%%#%s#%s %s%s%s ', icon_hl or '', icon or '', modified and '%#Red#' or '%#Normal#', path, modified and ' ' or '')
  else
    return string.format('%s %s%s ', icon or '', path, modified and ' ' or '')
  end
end

local function get_filename(bufnr)
  local special = special_tab[api.nvim_buf_get_option(bufnr, 'filetype')]
  if special then
    return special
  end

  local modified = api.nvim_buf_get_option(bufnr, 'modified')

  local filename = fn.fnamemodify(fn.bufname(bufnr), ':t') .. (modified and ' +' or '')

  return filename
end

-- local function get_ft(bufnr, highlight)
--   local ft = api.nvim_buf_get_option(bufnr, 'filetype')

--   local icon, icon_hl = icons.get_icon(fn.expand('%:t'), fn.expand('%:e'))

--   if highlight then
--     return string.format('%%#%s#%s %s ', icon_hl or '', icon or '', ft)
--   else
--     return string.format('%s %s ', icon or '', ft)
--   end
-- end

function M.update()
  local bufnr = fn.bufnr('%')

  local winid = fn.win_getid()
  local actual_curwin = tonumber(g.actual_curwin)

  if winid ~= actual_curwin then
    return M.update_inactive()
  end

  local ft, readonly, row, col, percent = get_infos(bufnr)

  local special = special_map[ft]
  if special then
    return special[1]
  end

  local mode = get_mode()
  local path = get_path(true)
  local branch, git = get_git(true)
  local diag = lsp.statusline(bufnr, true)

  local items = {
    '%#Normal# ', branch, git, path, readonly and ' ' or '',
    '%#StatusLine#%=%#Normal# ',
    diag, '%#Purple#',
    percent, string.format(' %s%4d:%-3d', mode.hl, row, col)
  }

  -- print(vim.inspect(items))
  return table.concat(items)
end

function M.update_inactive()
  local bufnr = fn.bufnr('%')
  local ft, readonly, row, col, percent = get_infos(bufnr)

  local special = special_map[ft]
  if special then
    return special[2]
  end

  local path = get_path(false)

  local items = {
    ' ', path, readonly and '' or '',
    '%=',
    percent, string.format(' %4d:%-3d', row, col)
  }

  return table.concat(items)
end

function M.update_tabline()
  local t = {}
  local tabpagenr = fn.tabpagenr()
  for i=1,fn.tabpagenr('$') do
    -- select the highlighting
    if i == tabpagenr then
      t[#t + 1] = '%#TabLineSel# '
    else
      t[#t + 1] = '%#TabLine# '
    end

    -- set the tab page number (for mouse clicks)
    t[#t + 1] = '%' .. i  .. 'T' .. i .. ' '


    local buflist = fn.tabpagebuflist(i)
    local windows = vim.tbl_filter(function(v) return v ~= '' end, vim.tbl_map(function(bufnr) return get_filename(bufnr) end, buflist))
    local windows_str = table.concat(windows, ' | ')

    if windows_str ~= '' then
      t[#t+1] = windows_str .. ' '
      else
    end

    -- t[#t+1] = ' '
  end

  -- after the last tab fill with TabLineFill and reset tab page nr
  t[#t + 1] = '%#TabLineFill#%T'

  return table.concat(t)
end

function M.setup()
  vim.o.statusline = '%{%v:lua.require\'config.statusline\'.update()%}'
  vim.o.tabline = '%!v:lua.require\'config.statusline\'.update_tabline()'

  cmd [[
  augroup Statusline
  autocmd!
  autocmd BufWinEnter,WinEnter,BufEnter * lua vim.wo.statusline='%{%v:lua.require\'config.statusline\'.update()%}'
  autocmd WinLeave,BufLeave * lua vim.wo.statusline=require'config.statusline'.update_inactive()
  autocmd ColorScheme * lua require 'config.palette'.setup()
  augroup END
  ]]
end

return M
