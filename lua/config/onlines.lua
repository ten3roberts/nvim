local fn = vim.fn

local function onlines()
  local exp = vim.fn.input("Normal: ")
  local start,stop = fn.line('v'), vim.fn.line('\'>')

  print(start .. ', ' .. stop .. '; ' .. exp)
  stop = stop or start

  local prev_pat = fn.getreg('/')

  if exp == '' then
    return
  end

  fn.execute(string.format(':%d,%dg/\\S/norm %s', start, stop, exp))

  fn.execute('noh')
  fn.setreg('/', prev_pat)
end

return onlines
