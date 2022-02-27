local api = vim.api
local b = vim.b
local cmd = vim.cmd
local fn = vim.fn
local o = vim.o

local current_dispatch;

local filetypes = {
  rust = {
    build = 'cargo build -q',
    check = 'cargo check -q',
    clippy = 'cargo clippy -q',
    clean = 'clean -q',
    lint = 'cargo clippy',
    run = 'cargo run',
    test = 'cargo test -q',
    doc = 'cargo doc -q --open',
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

local command_methods = {
  run = "term",
}

setmetatable(filetypes, filetypes)

local M = {}

local current_commands = {};

local methods = {
  quickfix = function(val) vim.cmd("Dispatch " .. val) end,
  term = function(val) vim.cmd("Start " .. val) end,
  multi_term = function(val) vim.cmd("Spawn " .. val) end,
}

local cache = {}

function M.clear_cache()
  cache = {}
end

function M.reload(path)
  print("Reloading dispatch")
  M.clear_cache()
  M.load_config(path)
end

function M.load_config(path, verbose)
  path = path or ".dispatch.json"
  path = fn.fnamemodify(path, ":p")
  -- print("Loading config from:", path)
  M.set_commands({})

  if cache[path] ~= nil then
    -- print("Loading from cache:", path);
    M.set_commands(cache[path])
  end

  local file = io.open(path, 'r')

  if not file then
    if verbose == true then
      api.nvim_err_writeln(string.format("Config file %q does not exist", path))
    end

    return
  end

  local lines = {}

  for line in file:lines() do
    lines[#lines+1] = line
  end

  local cont = table.concat(lines, '\n')
  local commands = fn.json_decode(cont);
  cache[path] = commands;
  M.set_commands(commands)
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

function M.dispatch(name)
  cmd "wa"

  local command = M.get_command(name)
  local method = command_methods[name] or "quickfix"

  -- Override command method
  if type(command) == "table" then
    method = command.method or method
    command = command.cmd
  end

  if not command then return end

  -- require'qf'.close'l'
  cmd "lclose"

  if methods[method] == nil then
    api.nvim_err_writeln("Undefined method: ", method)
    return;
  end

  methods[method](command)
end

return M
