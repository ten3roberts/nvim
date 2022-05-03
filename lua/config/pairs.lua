local npairs  = require 'nvim-autopairs'
local Rule    = require 'nvim-autopairs.rule'
local endwise = require('nvim-autopairs.ts-rule').endwise
local cond    = require('nvim-autopairs.conds')

npairs.setup {
  check_ts = false,
  autotag = {
    enable = true,
  },
  -- ts_config = { lua = { "string" }}, -- it will not add pair on that treesitter node
  -- rust = { "type_parameters" },
  enable_check_bracket_line = true,
  fast_wrap = {
    end_key = 'L',
    map = '<M-e>',
    chars = { '{', '[', '(', '"', "'", "<", "{ ", "[ ", " ( ", "$" },
    pattern = '[' .. table.concat { ' ', '%.', '%)', '%]', '%}', '%,', '%"', ';', '>', '|', '$' } .. ']',
    offset = -1,
    keys = 'qwertyuiopzxcvbnmasdfghjkl',
    check_comma = false,
  },
}

local opt = npairs.config

local basic = function(...)
  local move_func = opt.enable_moveright and cond.move_right or cond.none
  local rule = Rule(...)
      :with_move(function(opts) return opts.next_char == opts.char end)
      :with_pair(cond.not_add_quote_inside_quote())

  if #opt.ignored_next_char > 1 then
    rule:with_pair(cond.not_after_regex(opt.ignored_next_char))
  end
  rule:use_undo(true)
  return rule
end

local bracket = function(...)
  if opt.enable_check_bracket_line == true then
    return basic(...)
        :with_pair(cond.is_bracket_line())
  end
  return basic(...)
end

-- '.%f[^' .. table.concat { '%)', '%]', '}', ',', ';', '>' } .. ']'

npairs.add_rules(require('nvim-autopairs.rules.endwise-lua'))

require('nvim-ts-autotag').setup()

npairs.add_rules {
  basic("|", "|", { "rust" }),
  basic("*", "*", { "markdown" }),
  basic("$", "$", { "tex", "latex" }),
  Rule("|", "|", { "rust" }),
  Rule(' ', ' ')
      :with_pair(function(opts)
        local pair = opts.line:sub(opts.col - 1, opts.col)
        return vim.tbl_contains({ '()', '[]', '{}' }, pair)
      end),

  Rule('<', '>')
      :with_pair(function() return false end)
      :with_move(function(opts)
        return opts.prev_char:match('.%)') ~= nil
      end)
      :use_key('>'),
  -- Rule('{ ', ' }')
  --   :with_pair(function() return false end)
  --   :with_move(function(opts)
  --     return opts.prev_char:match('.%}') ~= nil
  --   end)
  --   :use_key('}'),
  -- Rule('[ ', ' ]')
  --   :with_pair(function() return false end)
  --   :with_move(function(opts)
  --     return opts.prev_char:match('.%]') ~= nil
  --   end)
  --   :use_key(']'),

  -- Disable aphostrophes in rust
  -- Rule("'", "'")
  --   :with_pair(function() return true end),

  -- 'then$' is a lua regex
  -- 'end' is a match pair
  -- 'lua' is a filetype
  -- 'if_statement' is a treesitter name. set it = nil to skip check with treesitter
  endwise('then$', 'end', 'lua'),
  endwise('do$', 'end', 'lua'),
  endwise('do$', 'end', 'lua'),
}

function _G.pairs_enter()
  if vim.fn.pumvisible() ~= 0 then
    return npairs.esc("<CR>")
  else
    return npairs.autopairs_cr()
  end
end

vim.api.nvim_set_keymap('i', '<CR>', 'v:lua.pairs_enter()', { expr = true, noremap = true })
