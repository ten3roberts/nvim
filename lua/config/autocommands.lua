local api = vim.api

local function autocommands(group, events)
  local cmds = { "augroup " .. group, "autocmd!" }
  for _,val in ipairs(events) do
    cmds[#cmds + 1] = table.concat ({ "autocmd", val.events, val.pat or "*", val.cmd }, " ")
  end

  cmds[#cmds+1] = "augroup END"

  cmds = table.concat(cmds, "\n")
  api.nvim_exec(cmds, false)
end


local f = io.open(vim.fn.stdpath("config") .. "/scrollback.log", "w")
_G.__debug_scrolloff = function()
  local trace = debug.traceback()

  if trace:find("nvim%-cmp") then
    return
  end

  vim.notify("Set scrolloff")

  f:write(trace)
  f:write("\n==================\n")
  f:flush()
end
autocommands( "CONFIG", {

   { events = 'BufEnter', cmd = 'lua require"config.lsp".deferred_loc()' },

  { events = "OptionSet", pat = "scrolloff", cmd = "call v:lua.__debug_scrolloff()"},
  { events = 'BufRead,BufNewFile', pat = '*.gltf', cmd = 'set filetype=json' },


  -- Auto format on save using LSP
  { events = 'BufWritePre', cmd = 'lua vim.lsp.buf.formatting_sync()' },

  { events = 'StdinReadPre', cmd = 'let g:std_in=1' },

  { events = 'OptionSet', pat = 'errorformat', cmd = 'setlocal errorformat+=%f:%l:\\ %t%*[^:]:%m' },

  -- Automatically create missing directories
  { events = 'BufWritePre', cmd = 'if (&buftype == "") | call mkdir(expand("<afile>:p:h"), "p") | endif' },

  { events = 'ColorScheme', cmd = 'lua require "config.palette".setup()' },

  -- Make Esc work in terminal mode (I know, some programs make use of Esc, but that's rare for my use case)
  { events = 'TermEnter', cmd = 'if &filetype != "fzf" | tnoremap <buffer> <Esc> <C-\\><C-n> | endif' },
  { events = 'TermOpen,TermEnter', cmd = 'lua require"darken".force_darken()' },
  -- { events = 'TermOpen', cmd = 'setlocal nonumber norelativenumber | startinsert' },

  { events = 'FileType', pat = 'fzf', cmd = 'tnoremap <A-q> <A-a><CR> | tmap  <C-q> <A-q>' },

  -- Make <Tab> expand diffs in Fugitive mode
  { events = 'FileType', pat = 'fugitive', cmd = 'map <buffer> <Tab> =' },

  { events = 'FileType', cmd = 'setlocal formatoptions-=o' },

  -- Restore last position when opening file
  { events = 'BufReadPost', cmd = [[ if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif ]] },

  -- Make windows equal sized when resizing OS window
  { events = 'VimResized', cmd = 'wincmd =' },

  -- Clear cached statuslines and errors from deleted buffers
  { events = 'BufUnload,BufDelete',  pat = '*', cmd = 'lua require"config.lsp".clear_buffer_cache(vim.fn.expand("<abuf>"))' },

  -- -- Save before grep,make etc
  -- { events = 'QuickFixCmdPre', cmd = ':wa' },

  -- { events = 'WinEnter', cmd = 'lua if vim.o.buftype == "" and vim.fn.win_gettype(0) == "" then require"config.lsp".set_loc() end' },

  { events = 'FileType', pat = 'TelescopePrompt', cmd = 'let b:autopairs_enabled = 0' },

  -- { events = "BufEnter", cmd = "lua require'config.lsp'.set_loc()"},
})
