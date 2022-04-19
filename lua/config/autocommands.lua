local a = vim.api
local fn = vim.fn

local group = a.nvim_create_augroup("CONFIG", { clear = true });
local function au(event, opts)
  opts.group = group
  a.nvim_create_autocmd(event, opts)
end

local lsp = require "config.lsp"

au({ "BufEnter" }, { callback = lsp.deferred_loc })
au({ "VimResized" }, { callback = function() vim.cmd "wincmd =" end })
au({ "ColorScheme" }, { callback = require "config.palette".setup })
au({ "BufRead", "BufNewFile" }, { callback = function() vim.o.ft = "json" end, pattern = ".gltf" })
au({ "BufWritePre" }, { callback = vim.lsp.buf.formatting_sync })
au({ "BufWritePre" }, { callback = function() if vim.o.buftype == "" then fn.mkdir(fn.expand("<afile>:p:h"), "p") end end })
au({ "TermEnter" }, { callback = function() vim.keymap.set("t", "<esc>", "<C-\\><C-n>", { buffer = true }) end })
au({ "FileType" }, { callback = function() vim.keymap.set("n", "<tab>", "=", { buffer = 0, remap = true }) end, pattern = "fugitive" })
au({ "BufReadPost" }, { callback = function() local l = fn.line [['"]] if l > 1 and l < fn.line("$") then vim.cmd "normal! g'\"" end end })
au({ "BufUnload", "BufDelete" }, { callback = function() lsp.clear_buffer_cache(fn.expand("<abuf>")) end })
