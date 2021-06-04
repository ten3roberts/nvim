local toggle_bool = {}

toggle_bool.pairs = {
  ['TRUE'] = 'FALSE',
  ['FALSE'] = 'TRUE',
  ['True'] = 'False',
  ['False'] = 'True',
  ['true'] = 'false',
  ['false'] = 'true',

  ['ON'] = 'OFF',
  ['OFF'] = 'ON',
  ['On'] = 'Off',
  ['Of'] = 'On',
  ['on'] = 'off',
  ['off'] = 'on',
}

function toggle_bool.toggle()
  -- Save cursor position
  local pos = vim.fn.getpos('.')

  vim.cmd 'normal! b'

  local search_string = {}

  -- Concat a search string
  for k,_ in pairs(toggle_bool.pairs) do
    search_string[#search_string+1] = k
  end

  search_string = table.concat(search_string, '\\|')

  -- Search for the closest in pair
  vim.fn.search('\\<\\(' .. search_string .. '\\)\\>', 'c', vim.fn.line('.') + 1)

  local word = vim.fn.expand('<cword>')

  local other = toggle_bool.pairs[word]

  -- No match found, restore cursor position
  if not other then
    vim.fn.setpos('.', pos)
    return
  end

  vim.cmd ('normal! "_ciw' .. other)
  vim.cmd ('normal! b')
end

return toggle_bool
