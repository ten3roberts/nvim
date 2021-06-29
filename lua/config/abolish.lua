local cmd = vim.cmd

local function abolish(abbr, rep, opts)
  cmd(string.format(':Abolish %s %s %s', abbr, rep, opts or ' '))
end

abolish('dispath', 'dispatch')
abolish('edn', 'end')
abolish('requirment{,s}', 'requirement{,s}')
abolish('rqeuire', 'require')
abolish('somethign', 'something')
abolish('unsage', 'unsafe')
abolish('widht', 'width')
abolish('wiht{,out}', 'with{,out}')
