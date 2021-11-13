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

autocommands( "CONFIG", {
  { events = 'VimEnter,DirChanged', cmd = 'lua require"config.dispatch".load_config(".dispatch.json", false)' },
  { events = 'BufWrite', pat = '.dispatch.json', cmd = 'lua require"config.dispatch".load_config(".dispatch.json", false)' },

  { events = 'FileType', cmd = 'lua require"config.dispatch".on_ft()' },

  { events = 'BufNew,FileType,BufWinEnter', cmd = 'setlocal foldmethod=expr | setlocal foldexpr=nvim_treesitter#foldexpr()' },

  -- autocmd('BufWinEnter,TabEnter', '*', 'SaveSession')

  -- Auto format on save using LSP
  { events = 'BufWritePre', cmd = 'lua vim.lsp.buf.formatting_sync()' },

  -- autocmd('FileType', 'dap-repl', 'lua require(:dap.ext.autocompl").attach()');

  { events = 'StdinReadPre', cmd = 'let g:std_in=1' },
  -- { events = 'VimEnter', cmd = 'if getcwd() == $HOME && argc() == 0 && !exists("g:std_in") | execute("Telescope project") | endif' },

  { events = 'OptionSet', pat = 'errorformat', cmd = 'setlocal errorformat+=%f:%l:\\ %t%*[^:]:%m' },

  -- Automatically create missing directories
  { events = 'BufWritePre', cmd = 'if (&buftype == "") | call mkdir(expand("<afile>:p:h"), "p") | endif' },

  { events = 'ColorScheme', cmd = 'lua require "config.palette".setup()' },

  -- Restart language server when modifying Cargo.toml
  -- { events = 'BufWritePost', pat = '*/Cargo.toml', cmd = 'echom "Restarting LSP" | LspRestart' },

  -- Make Esc work in terminal mode (I know, some programs make use of Esc, but that's rare for my use case)
  { events = 'TermEnter', cmd = 'if &filetype != "fzf" | tnoremap <buffer> <Esc> <C-\\><C-n> | endif' },
  { events = 'TermOpen,TermEnter', cmd = 'lua require"darken".force_darken()' },
  { events = 'TermOpen', cmd = 'setlocal nonumber norelativenumber' },
  { events = 'TermOpen', cmd = ':startinsert'},

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

  -- Save before grep,make etc
  { events = 'QuickFixCmdPre', cmd = ':wa' },

  { events = 'WinEnter', cmd = 'lua if vim.o.buftype == "" and vim.fn.win_gettype(0) == "" then require"config.lsp".set_loc() end' },

  { events = 'FileType', pat = 'TelescopePrompt', cmd = 'let b:autopairs_enabled = 0' },
})

