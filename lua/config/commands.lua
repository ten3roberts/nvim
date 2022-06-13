local a = vim.api
vim.cmd "command! Sort norm! vip:'<,'>sort<CR>"
vim.cmd "command! CargoUpdateReadme :Execute cargo readme > README.md"
vim.cmd "command! -nargs=* CargoPublish :ExecuteInteractive cargo workspaces publish <args>"
vim.cmd "command! CargoUpgrade !cargo --color=never upgrade --workspace"

local recipe = require "recipe"
local function cargo(cmd, action)
  recipe.execute {
    cmd = "cargo " .. cmd,
    interactive = true,
    stay = true,
    cwd = vim.fn.expand "%:p:h",
    action = action,
    keep_open = true,
  }
end

a.nvim_create_user_command("Q", ":silent wa | qa", {})
a.nvim_create_user_command("W", ":silent wa", {})

a.nvim_create_user_command("Reload", function(c)
  require("config.dev_utils").reload(c.args)
end, { nargs = 1 })

a.nvim_create_user_command("Dump", function(c)
  require("config.dev_utils").dump_mod(c.args)
end, { nargs = 1 })

a.nvim_create_user_command("Cargo", function(c)
  recipe.execute { cmd = "cargo " .. c.args, interactive = true }
end, { nargs = "*" })

a.nvim_create_user_command("CargoUpgrade", function(c)
  recipe.execute { cmd = "cargo upgrade" .. c.args, interactive = true }
end, { nargs = "*" })

a.nvim_create_user_command("CargoAdd", function(c)
  recipe.execute {
    cmd = "cargo add " .. c.args,
    interactive = true,
    action = {
      function()
        vim.cmd "CargoReload"
      end,
    },
  }
end, { nargs = "*" })

a.nvim_create_user_command("CargoVersion", function(c)
  recipe.execute { cmd = "cargo workspaces version " .. c.args, interactive = true }
end, { nargs = "*" })

a.nvim_create_user_command("CargoTest", function(c)
  recipe.execute { cmd = string.format("cargo test %s -- --nocapture", c.args), interactive = true }
end, { nargs = "*" })

a.nvim_create_user_command("Clip", 'let @+=@"', {})

a.nvim_create_user_command("CargoSyncReadme", function(c)
  recipe.execute { cmd = "cargo sync-readme " .. c.args, interactive = true }
end, {})

vim.cmd [[
function! Redir(cmd, rng, start, end)
	for win in range(1, winnr('$'))
		if getwinvar(win, 'scratch')
			execute win . 'windo close'
		endif
	endfor
	if a:cmd =~ '^!'
		let cmd = a:cmd =~' %' ? matchstr(substitute(a:cmd, ' %', ' ' . expand('%:p'), ''), '^!\zs.*') : matchstr(a:cmd, '^!\zs.*')
		if a:rng == 0
			let output = systemlist(cmd)
		else
			let joined_lines = join(getline(a:start, a:end), '\n')
			let cleaned_lines = substitute(shellescape(joined_lines), "'\\\\''", "\\\\'", 'g')
			let output = systemlist(cmd . " <<< $" . cleaned_lines)
		endif
	else
		redir => output
		execute a:cmd
		redir END
		let output = split(output, "\n")
	endif
	vnew
	let w:scratch = 1
	setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
  ColorizerAttachToBuffer
	call setline(1, output)
endfunction

command! -nargs=1 -complete=command -bar -range Redir silent call Redir(<q-args>, <range>, <line1>, <line2>)
]]

vim.cmd [[
  function! DeleteHiddenBuffers()
  let tpbl=[]
  let closed = 0
  call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
  for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
    if getbufvar(buf, '&mod') == 0
      silent execute 'bwipeout' buf
      let closed += 1
    endif
  endfor
  echo "Closed ".closed." hidden buffers"
endfunction
command! BCloseHidden silent call DeleteHiddenBuffers()
]]

-- command! GrepThis Te
