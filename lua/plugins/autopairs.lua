return {
  {
    "windwp/nvim-autopairs",
    dependencies = "windwp/nvim-ts-autotag",
    config = function()
      local npairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local endwise = require("nvim-autopairs.ts-rule").endwise
      local cond = require "nvim-autopairs.conds"
      local ts_conds = require "nvim-autopairs.ts-conds"

      npairs.setup {
        check_ts = true,
        autotag = {
          enable = true,
        },
        enable_check_bracket_line = true,
        -- fast_wrap = {
        --   end_key = "L",
        --   map = "<M-e>",
        --   chars = { "{", "[", "(", '"', "'", "<", "{ ", "[ ", " ( ", "$" },
        --   pattern = "[" .. table.concat { " ", "%.", "%)", "%]", "%}", "%,", '%"', ";", ">", "|", "$" } .. "]",
        --   offset = -1,
        --   keys = "qwertyuiopzxcvbnmasdfghjkl",
        --   check_comma = false,
        -- },
      }

      local opt = npairs.config

      npairs.add_rules(require "nvim-autopairs.rules.endwise-lua")

      local function move()
        return function(opts)
          return opts.char == opts.rule.end_pair
        end
      end

      local function md_pair(open, close)
        return Rule(open, close, { "markdown" })
          :with_pair(ts_conds.is_not_ts_node "fenced_code_block")
          :with_move(move())
      end

      npairs.add_rules {
        Rule("|", "|", { "rust", "lua" }):with_pair(cond.none()):with_move(move()),
        Rule("<", ">", { "rust" }):with_pair(cond.none()):with_move(move()),
        Rule("$", "$", { "latex" }):with_pair(cond.none()):with_move(move()),
        -- md_pair("**", "**"),

        md_pair("*", "*"),
        md_pair("~", "~"),
        -- basic("|", "|", { "rust" }),
        -- basic("*", "*", { "markdown" }),
        -- basic("$", "$", { "tex", "latex" }),
        -- Rule("|", "|", { "rust" }),
        Rule(" ", " "):with_pair(function(opts)
          local pair = opts.line:sub(opts.col - 1, opts.col)
          return vim.tbl_contains({ "()", "[]", "{}" }, pair)
        end),

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
        endwise("then$", "end", "lua"),
        endwise("do$", "end", "lua"),
        endwise("do$", "end", "lua"),
      }

      function _G.pairs_enter()
        return npairs.autopairs_cr()
      end

      vim.api.nvim_set_keymap("i", "<CR>", "v:lua.pairs_enter()", { expr = true, noremap = true })
    end,
  },
}
