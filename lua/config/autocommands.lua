local a = vim.api
local fn = vim.fn

local group = a.nvim_create_augroup("CONFIG", { clear = true })
local function au(event, opts)
  opts.group = group
  a.nvim_create_autocmd(event, opts)
end

au({ "BufNew", "BufWinEnter", "FileType" }, {
  callback = function(o)
    local win = a.nvim_get_current_win()
    local buftype = vim.bo[o.buf].buftype
    local filetype = vim.bo[o.buf].filetype
    local bufname = a.nvim_buf_get_name(o.buf)

    local filetypes = {
      rust = true,
      lua = true,
      c = true,
      cpp = true,
      markdown = true,
      tex = true,
      latex = true,
      json = true,
      yaml = true,
      toml = true,
    }

    local info = string.format("%d name: %s ft: %s bt: %s win: %d", o.buf, bufname, filetype, buftype, win)

    if buftype == "" and filetypes[filetype] then
      -- vim.defer_fn(function()
      --   vim.notify("Enable spell " .. info)
      -- end, 1000)
      vim.wo.spell = true
      -- vim.opt_local.spell = true
    elseif vim.wo.spell == true then
      vim.defer_fn(function()
        vim.notify("Disable spell " .. info)
      end, 1000)
      vim.wo.spell = false
      -- vim.opt_local.spell = false
    end
  end,
})

au({ "ColorScheme" }, { callback = require("config.palette").setup })
au({ "BufRead", "BufNewFile" }, {
  callback = function()
    vim.o.ft = "json"
  end,
  pattern = ".gltf",
})

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
