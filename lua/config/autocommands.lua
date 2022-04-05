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
local a = vim.api
local fn = vim.fn

local group = a.nvim_create_augroup("CONFIG", { clear = true });
local function au(event, opts)
  opts.group = group
  a.nvim_create_autocmd(event, opts)
end
local lsp = require "config.lsp"

au({ "BufEnter"                }, { callback = lsp.deferred_loc })
au({ "OptionSet"               }, { callback = require "config.palette".setup, pattern = "ColorScheme" })
au({ "BufRead", "BufNewFile"   }, { callback = function() vim.o.ft = "json" end, pattern = ".gltf" })
au({ "BufWritePre"             }, { callback = vim.lsp.buf.formatting_sync })
au({ "BufWritePre"             }, { callback = function() if vim.o.buftype == "" then fn.mkdir(fn.expand("<afile>:p:h"), "p") end end })
au({ "TermEnter, TermOpen"     }, { callback = require "darken".force_darken })
au({ "TermEnter"               }, { callback = function() vim.keymap.set("t", "<esc>", "<C-\\><C-n>", { buffer = true }) end})
au({ "FileType"                }, { callback = function() vim.keymap.set("n", "<tab>", "=", { buffer = 0 }) end, pattern = "fugitive" } )
au({ "BufReadPost"             }, { callback = function() local l = fn.line [['"]] if l > 1 and l < fn.line("$") then vim.cmd "normal! g'\"" end end } )
au ({ "BufUnload", "BufDelete" }, { callback = function() lsp.clear_buffer_cache(fn.expand("<abuf>")) end})

-- autocommands( "CONFIG", {

   -- { events = 'BufEnter', cmd = 'lua require"config.lsp".deferred_loc()' },

  -- { events = "OptionSet", pat = "scrolloff", cmd = "call v:lua.__debug_scrolloff()"},
  -- { events = 'BufRead,BufNewFile', pat = '*.gltf', cmd = 'set filetype=json' },


  -- Auto format on save using LSP
  -- { events = 'BufWritePre', cmd = 'lua vim.lsp.buf.formatting_sync()' },

  -- { events = 'StdinReadPre', cmd = 'let g:std_in=1' },

  -- { events = 'OptionSet', pat = 'errorformat', cmd = 'setlocal errorformat+=%f:%l:\\ %t%*[^:]:%m' },

  -- Automatically create missing directories
  -- { events = 'BufWritePre', cmd = 'if (&buftype == "") | call mkdir(expand("<afile>:p:h"), "p") | endif' },

  -- { events = 'ColorScheme', cmd = 'lua require "config.palette".setup()' },

  -- Make Esc work in terminal mode (I know, some programs make use of Esc, but that's rare for my use case)
  -- { events = 'TermEnter', cmd = 'if &filetype != "fzf" | tnoremap <buffer> <Esc> <C-\\><C-n> | endif' },
  -- { events = 'TermOpen,TermEnter', cmd = 'lua require"darken".force_darken()' },
  -- { events = 'TermOpen', cmd = 'setlocal nonumber norelativenumber | startinsert' },

  -- { events = 'FileType', pat = 'fzf', cmd = 'tnoremap <A-q> <A-a><CR> | tmap  <C-q> <A-q>' },

  -- Make <Tab> expand diffs in Fugitive mode
  -- { events = 'FileType', pat = 'fugitive', cmd = 'map <buffer> <Tab> =' },

  -- { events = 'FileType', cmd = 'setlocal formatoptions-=o' },

  -- Restore last position when opening file
  -- { events = 'BufReadPost', cmd = [[ if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif ]] },

  -- Make windows equal sized when resizing OS window
  -- { events = 'VimResized', cmd = 'wincmd =' },

  -- Clear cached statuslines and errors from deleted buffers
  -- { events = 'BufUnload,BufDelete',  pat = '*', cmd = 'lua require"config.lsp".clear_buffer_cache(vim.fn.expand("<abuf>"))' },

  -- -- Save before grep,make etc
  -- { events = 'QuickFixCmdPre', cmd = ':wa' },

  -- { events = 'WinEnter', cmd = 'lua if vim.o.buftype == "" and vim.fn.win_gettype(0) == "" then require"config.lsp".set_loc() end' },

  -- { events = 'FileType', pat = 'TelescopePrompt', cmd = 'let b:autopairs_enabled = 0' },

  -- { events = "BufEnter", cmd = "lua require'config.lsp'.set_loc()"},
-- })
