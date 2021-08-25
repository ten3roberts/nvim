local npairs  = require'nvim-autopairs'
local Rule    = require'nvim-autopairs.rule'
local endwise = require('nvim-autopairs.ts-rule').endwise
local ts_conds = require "nvim-autopairs.ts-conds"

npairs.setup{
  check_ts = true,
  autotag = {
    enable = true,
  },
  lua = { "string" }, -- it will not add pair on that treesitter node
  -- rust = { "type_parameters" },
  fast_wrap = {
    end_key = 'L',
    highlight = 'HopNextKey',
  },
  enable_check_bracket_line = true,
}

npairs.add_rules {
  -- Rule("%", "%", "lua"):with_pair(ts_conds.is_ts_node { "string", "comment" }),
  -- Rule('<', '>')
  --   -- :with_pair(function() return false end)
  --   :with_move(function(opts)
  --     return opts.prev_char:match('>') ~= nil
  --   end),
  -- :use_key('>'),
  Rule(' ', ' ')
    :with_pair(function (opts)
      local pair = opts.line:sub(opts.col - 1, opts.col)
      return vim.tbl_contains({ '()', '[]', '{}' }, pair)
    end),
  Rule('( ', ' )')
    :with_pair(function() return false end)
    :with_move(function(opts)
      return opts.prev_char:match('.%)') ~= nil
    end)
    :use_key(')'),
  Rule('{ ', ' }')
    :with_pair(function() return false end)
    :with_move(function(opts)
      return opts.prev_char:match('.%}') ~= nil
    end)
    :use_key('}'),
  Rule('[ ', ' ]')
    :with_pair(function() return false end)
    :with_move(function(opts)
      return opts.prev_char:match('.%]') ~= nil
    end)
    :use_key(']'),
  -- 'then$' is a lua regex
  -- 'end' is a match pair
  -- 'lua' is a filetype
  -- 'if_statement' is a treesitter name. set it = nil to skip check with treesitter
  endwise('then$', 'end', 'lua'),
  endwise('do$', 'end', 'lua', 'for_loop'),
  endwise('do', 'end', 'lua', 'while_loop'),
}

npairs.add_rules(require('nvim-autopairs.rules.endwise-lua'))

require('nvim-ts-autotag').setup()

function _G.pairs_enter()
  if vim.fn.pumvisible() ~= 0  then
    return npairs.esc("<cr>")
  else
    return npairs.autopairs_cr()
  end
end

vim.api.nvim_set_keymap('i' , '<CR>','v:lua.pairs_enter()', { expr = true , noremap = true })
