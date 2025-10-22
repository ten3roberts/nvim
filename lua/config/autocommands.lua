local a = vim.api
local fn = vim.fn
local keybinds = require "config.keybind_definitions"

local group = a.nvim_create_augroup("CONFIG", { clear = true })
local function au(event, opts)
  opts.group = group
  a.nvim_create_autocmd(event, opts)
end

local function setup_spell(o)
  local buftype = vim.bo[o.buf].buftype
  local filetype = vim.bo[o.buf].filetype

  local filetypes = {
    rust = true,
    lua = true,
    c = true,
    cpp = true,
    markdown = true,
    tex = true,
    latex = false,
    json = true,
    yaml = true,
    toml = true,
    typescript = true,
    javascript = true,
  }

  if buftype == "" and filetypes[filetype] then
    vim.wo.spell = true
  elseif vim.wo.spell == true and (filetype ~= "" or buftype == "terminal") then
    vim.wo.spell = false
  end
end

local autocmds = {
  { {"BufNew", "BufWinEnter", "FileType", "TermOpen"}, { callback = setup_spell } },
  { {"ColorScheme"}, { callback = require("config.palette").setup } },
  { {"BufRead", "BufNewFile"}, {
    callback = function() vim.o.ft = "json" end,
    pattern = ".gltf",
  } },
  { {"BufWritePre"}, {
    callback = function()
      if vim.o.buftype == "" then
        fn.mkdir(fn.expand "<afile>:p:h", "p")
      end
    end,
  } },
  { {"BufWritePre"}, {
    pattern = "*.rs",
    callback = function()
      vim.lsp.buf.code_action({
        context = { only = { "source.organizeImports" } },
        apply = true,
      })
    end,
  } },
  { {"TermEnter"}, {
    callback = function()
      vim.keymap.set("t", keybinds.getKeybind "terminal-exit", "<C-\\><C-n>", { buffer = true })
    end,
  } },
  { {"BufReadPost"}, {
    callback = function()
      local current_line = fn.line "."
      if current_line == 1 then
        local l = fn.line [['"]]
        if l > 1 and l < fn.line "$" then
          vim.cmd [[ normal! g`" ]]
        end
      end
    end,
  } },
  { {"VimEnter"}, {
    callback = function()
      vim.defer_fn(function()
        local tips = require "config.tips"
        local tip = tips[math.random(#tips)]
        require("snacks").notifier.notify(tip, { title = "Tip", timeout = 30000 })
      end, 5000)
    end,
  } },
}

for _, cmd in ipairs(autocmds) do
  au(cmd[1], cmd[2])
end