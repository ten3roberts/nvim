local cmd = vim.cmd
local fn = vim.fn
local g = vim.g

local M = {}

local ripgrep = 'rg --files'

-- Makes files closer to the current file favored.
function _G.fzf_proximity()
  local filename = fn.expand('%')
  if filename == '' or vim.o.buftype ~= '' then
    -- Retry with alternate file
    return fzf_proximity_alternate()
  end

  return ripgrep .. ' | proximity-sort ' .. filename
end

-- Makes files closer to the alternate file favored.
function _G.fzf_proximity_alternate()
  local bufnr = fn.bufnr('#')
  local filename = fn.expand('#')
  if filename == '' or vim.api.nvim_buf_get_option(bufnr, 'buftype') ~= '' then
    return ripgrep
  end

  return ripgrep .. ' | proximity-sort ' .. filename
end

function M.setup()

  -- g.fzf_layout = { down = 20 }
  g.fzf_tall = { width = 60, height = 20 }
  g.fzf_wide = { width = 0.8, height = 0.6 }
  g.fzf_square = { width = 0.8, height = 0.6 }

  g.fzf_layout = { window = g.fzf_square }

  g.fzf_action = {
    -- [ 'enter' ] = 'drop',
    ['ctrl-t'] = 'tab split',
    ['ctrl-s'] = 'tab split',
    ['ctrl-h'] = 'split',
    ['ctrl-v'] = 'vsplit',
    ['ctrl-d'] = 'drop',

  }

  g.fzf_buffers_jump = 1

  -- g.fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

  g.fzf_colors = {
    fg      = {'fg', 'Normal'},
    bg      = {'bg', 'Normal'},
    gutter  = {'bg', 'Normal'},
    hl      = {'fg', 'Comment'},
    ['fg+'] = {'fg', 'CursorLine', 'CursorColumn', 'Normal'},
    ['bg+'] = {'bg', 'CursorLine', 'CursorColumn'},
    ['hl+'] = {'fg', 'Statement'},
    info    = {'fg', 'PreProc'},
    border  = {'fg', 'Ignore'},
    prompt  = {'fg', 'Conditional'},
    pointer = {'fg', 'Exception'},
    marker  = {'fg', 'Keyword'},
    spinner = {'fg', 'Label'},
    header  = {'fg', 'Comment'}
  }

  g.fzf_opts = {
    files = function () return { source = M.fzf_proximity(), options= '--tiebreak=index', window = g.fzf_tall } end,
    buffers = { window = g.fzf_tall },
  }

  cmd [[
  command! -bang -nargs=? -complete=dir Buffers call fzf#vim#buffers(<q-args>, { 'window': g:fzf_tall }, <bang>0)
  command! -bang -nargs=? -complete=dir Files call fzf#vim#files(<q-args>, { 'source': v:lua.fzf_proximity(), 'options': '--tiebreak=index', 'window': g:fzf_tall }, <bang>0)
  command! -bang -nargs=? Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case -- ".shellescape(<q-args>), 1, fzf#vim#with_preview({ 'window': g:fzf_wide, 'options': '--delimiter : --nth 4..'}), <bang>0)
  ]]
end

return M
