
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

local branch = nil

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

local function get_mode(_, highlight)
  local mode = api.nvim_get_mode().mode
  mode = mode_map[mode] or { val = 'Unknown mode: ', hl = '%#CursorLine#' }

  if highlight then
    return string.format('%s %s ', mode.hl, mode.val)
  else
    return mode.val
  end


  local function get_git(_, highlight)
    local signs = vim.b.gitsigns_status_dict

    if not signs then
      branch = nil
      return nil
    end

    branch = signs.head
    branch = branch and (' ' .. branch)

    if highlight then
      string.format('%#Green#+%s %#Blue#~%s %#Red#-%s', signs.added, signs.changed, signs.removed)
    else
      string.format('+%s ~%s -%s', signs.added, signs.changed, signs.removed)
    end
  end

  local function get_ruler(bufnr)
    local pos = vim.fn.getpos('.')
    local row,col = pos[2],pos[3]

    local num_lines = #api.nvim_buf_get_lines(bufnr, 0, -1, false)
    return string.format('%d%%%% %d:%d', row / num_lines * 100, row, col)
  end

  local function get_readonly(bufnr)
    return (vim.fn.getbufvar(bufnr, '&readonly') == 1 or vim.fn.getbufvar(bufnr, '&modifiable') == 0) and '' or ''
  end

  local function get_path(_ highlight)
    local path, filename, extension = fn.expand('%:~:.'), fn.expand('%:t'), fn.expand('%:e')
    if #filename == 0 then
      return '[NO NAME]'
    end

    local icon, icon_hl = icons.get_icon(filename, extension, { default = true })

    if highlight then
      return '%#' .. icon_hl .. '#' .. icon .. '%#Normal# ' .. path
    else
      return icon .. '%#Normal# ' .. path
    end
  end

  local t = {}

  local active_items = {
    get_mode, function() return branch end, get_path, get_readonly, get_git, function() return '%=' end, lsp.statusline, get_ruler,
  }

  local inactive_items = {
    get_mode, get_path, get_readonly, function() return '%=' end, get_ruler,
  }

  function M.update(active)
    local bufnr = fn.bufnr('%')
    local ft = api.nvim_get_buf_option(bufnr,  'filetype')

    local special = special_map[ft]
    if special then
      return special
    end

    local items = active and active_items or inactive_items

    local i = 1
    for j,v in ipairs(items) do
      if v ~= nil and #v ~= 0 then
        t[i] = hl[j] or '' .. ' ' .. v .. ' '
        i = i + 1
      end

      local s = table.concat(t)
      return s
    end
  end

  function M.setup()
    -- vim.o.statusline = '%!v:lua.require\'config.statusline\'.update()'
    vim.o.statusline = '%!v:lua.require\'config.statusline\'.update(v:true)'

    require'config.palette'.create_highlights()

    -- autocmd BufWinEnter,WinEnter * lua vim.wo.statusline=nil
    -- autocmd WinLeave,BufLeave * lua vim.wo.statusline=require'lualine'.update(false)
    cmd [[
    augroup Statusline
    autocmd!
    autocmd DirChanged * lua require 'config.statusline'.update_git()
    augroup END
    ]]
  end

return M
