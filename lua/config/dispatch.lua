local api = vim.api
local b = vim.b
local cmd = vim.cmd
local fn = vim.fn
local o = vim.o

local current_dispatch;

local filetypes = {
  rust = {
    build = 'cargo build',
    check = 'cargo check --examples',
    clean = 'clean',
    lint = 'cargo clean && cargo clippy',
    run = 'cargo run',
    test = 'cargo test',
  },
  glsl = {
    check = 'glslangValidator -V %'
  },
  html = {
    build = 'live-server %',
    check = 'live-server %',
    run = 'live-server %',
  },
  lua = {
    build = 'luac %',
    check = 'luac %',
    clean = 'rm luac.out',
    lint = 'luac %',
    run = 'lua %',
  },
  __index = function()
    return {}
  end
}

setmetatable(filetypes, filetypes)

local M = {}

local current_commands = {};

function M.load_config(path, verbose)
  local file = io.open(path, 'r')

  if not file then
    if verbose == nil or verbose then
      api.nvim_err_writeln(string.format("Config file %q does not exist", path))
    end
    return
  end

  local lines = {}

  for line in file:lines() do
    lines[#lines+1] = line
  end

  local cont = table.concat(lines, '\n')
  M.set_commands(fn.json_decode(cont))
end

function M.on_ft()
  if vim.o.buftype ~= '' then
    return
  end

  current_dispatch = M.get_command('check', true) or M.get_command('build', true) or current_dispatch
  b.dispatch = current_dispatch
end

function M.set_commands(commands)
  current_commands = commands
  M.on_ft()
end

function M.get_command(name, silent)
  local command = current_commands[name] or filetypes[o.filetype][name]

  if command == nil and not silent then
    api.nvim_err_writeln(string.format("Unknown dispatch command '%s'", name))
    return
  end

  return command
end

function M.start(name)
  M.dispatch(name, function(command) cmd("Start polytype[min.indices[0]].a]" .. command) end)
end

function M.dispatch(name, with)
  cmd("wa");
  with = with or function(command)  cmd('Dispatch ' .. command) end

  local command = M.get_command(name)

  if not command then return end

  require'qf'.close'l'

  with(command)
end

return M
