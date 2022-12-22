local a = vim.api
local fn = vim.fn

local group = a.nvim_create_augroup("CONFIG", { clear = true })
local function au(event, opts)
  opts.group = group
  a.nvim_create_autocmd(event, opts)
end

local lsp = require "config.lsp"

local function format(opts)
  local bufnr = opts.bufnr
  local clients = vim.lsp.buf_get_clients(bufnr)
  clients = vim.tbl_filter(function(client)
    return client.supports_method "textDocument/formatting"
  end, clients)

  if #clients == 0 then
    return
  end

  vim.lsp.buf.format { bufnr = bufnr }
end

au({ "BufWinEnter", "FileType", "BufEnter" }, {
  callback = function(o)
    -- local ft = vim.api.nvim_buf_get_option(o.buf, "filetype")
    if vim.api.nvim_buf_get_option(o.buf, "buftype") == "" then
      vim.opt.spell = true
    else
      vim.opt.spell = false
    end
  end,
})
au({ "VimResized" }, {
  callback = function()
    vim.cmd "wincmd ="
  end,
})
au({ "ColorScheme" }, { callback = require("config.palette").setup })
au({ "BufRead", "BufNewFile" }, {
  callback = function()
    vim.o.ft = "json"
  end,
  pattern = ".gltf",
})
au({ "BufWritePre" }, { callback = format })
au({ "BufWritePre" }, {
  callback = function()
    if vim.o.buftype == "" then
      fn.mkdir(fn.expand "<afile>:p:h", "p")
    end
  end,
})
au({ "TermEnter" }, {
  callback = function()
    vim.keymap.set("t", "<esc>", "<C-\\><C-n>", { buffer = true })
  end,
})

au({ "BufReadPost" }, {
  callback = function()
    local l = fn.line [['"]]
    if l > 1 and l < fn.line "$" then
      vim.cmd [[ normal! g`" ]]
    end
  end,
})

au({ "BufUnload", "BufDelete" }, {
  callback = function()
    lsp.clear_buffer_cache(fn.expand "<abuf>")
  end,
})

au({ "BufWritePost" }, {
  callback = function(opts)
    vim.notify("Compiling " .. opts.file)
    vim.cmd("source " .. opts.file)
    require("packer").compile()
  end,
  pattern = "*/plugins.lua",
})
