local cmd = vim.cmd

local function abolish(abbr, rep, opts)
  cmd(string.format(':Abolish %s %s %s', abbr, rep, opts or ' '))
end

abolish('wiht{,out}', 'with{,out}')
abolish('widht', 'width')
abolish('requirment{,s}', 'requirement{,s}')
