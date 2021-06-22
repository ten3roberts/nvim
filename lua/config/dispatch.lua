local api = vim.api
local b = vim.b
local cmd = vim.cmd
local o = vim.o

local filetypes = {
  rust = {
    build = 'cargo build',
    check = 'cargo check',
    clean = 'clean',
    lint = 'cargo clean && cargo clippy',
    run = 'cargo run',
    test = 'cargo test',
  },
  lua = {
    build = 'luac %',
    check = 'luac %',
    clean = 'rm luac.out',
    lint = 'luac %',
    run = 'lua %',
  },
}

local default = {
  build = './scripts/build.sh',
  clean = './scripts/clean.sh',
  list = './scripts/lint.sh',
  run = './scripts/run.sh',
  test = './scripts/test.sh',
}

local M = {}

local current_commands = default;
local current_ft = nil;

function M.on_ft()
  local ft = o.filetype

  local filetype_comands = filetypes[ft]
  if filetype_comands then
    current_commands = filetype_comands
    current_ft = ft
  end

  b.dispatch = M.get_command('build')
end

function M.get_command(name)
  local command = current_commands[name]

  if command == nil then
    api.nvim_err_writeln(string.format("Unknown dispatch command '%s' for '%s'", command, current_ft or 'none'))
    return
  end

  return command
end

function M.dispatch(name)

  local command = M.get_command(name)

  if not command then return end

  cmd('Dispatch ' .. command)
end

return M
