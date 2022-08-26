-- require 'nvim-treesitter'.define_modules {
--   auto_folding = {
--     attach = function(_, _)
--       -- Do cool stuff here
--       vim.notify("Enabling treesitter folding")
--     end,
--     detach = function(_)
--       vim.bo.foldmethod = "indent"
--     end,
--     is_supported = function(lang)
--       -- local supported = {
--       --   rust = true,
--       --   lua = true
--       -- }

--       return true
--     end
--   }
-- }

require("nvim-treesitter.configs").setup {
  ensure_installed = "all",
  autopairs = { enable = true },
  playground = { enable = true },
  matchup = { enable = true },
  highlight = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "+",
      scope_incremental = "grc",
      node_decremental = "-",
    },
  },
  refactor = {
    highlight_definitions = {
      enable = true,
      -- Set to false if you have an `updatetime` of ~100.
      clear_on_cursor_move = false,
    },
    highlight_current_scope = { enable = false },
    smart_rename = {
      enable = true,
      keymaps = {
        smart_rename = "grr",
      },
    },
    navigation = {
      enable = true,
      keymaps = {
        goto_definition = "gnd",
        list_definitions = "gnD",
        list_definitions_toc = "gO",
        goto_next_usage = ")",
        goto_previous_usage = "(",
      },
    },
  },

  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        -- ["af"] = "@function.outer",
        -- ["if"] = "@function.inner",
        -- ["ac"] = "@class.outer",
        -- ["ic"] = "@class.inner",
        -- ["ia"] = "@parameter.inner",
        -- ["aa"] = "@parameter.outer",
        -- ["i;"] = "@call.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
    swap = {
      enable = false,
      swap_next = {
        ["<A-l>"] = "@parameter.inner",
      },
      swap_previous = {
        ["<A-h>"] = "@parameter.inner",
      },
    },
  },
  textsubjects = {
    enable = true,
    prev_selection = ",", -- (Optional) keymap to select the previous selection
    keymaps = {
      ["."] = "textsubjects-smart",
      [";"] = "textsubjects-container-outer",
      ["i;"] = "textsubjects-container-inner",
    },
  },
  -- rainbow = {
  --   enable = true,
  --   -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
  --   extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
  --   max_file_lines = 2000, -- Do not enable for files with more than n lines, int
  --   colors = {
  --     "#5e81ac",
  --     "#ebcb8b",
  --     "#a3be8c",
  --     "#bf6a6a",
  --     "#b48ead",
  --     "#d08770",
  --   }, -- table of hex strings
  --   -- termcolors = {} -- table of colour name strings
  -- },
  indent = { enable = true },
}

require("treesitter-context").setup {
  enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
  max_lines = 2, -- How many lines the window should span. Values <= 0 mean no limit.
  trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
  patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
    -- For all filetypes
    -- Note that setting an entry here replaces all other patterns for this entry.
    -- By setting the 'default' entry below, you can control which nodes you want to
    -- appear in the context window.
    default = {
      "class",
      "function",
      "method",
      -- 'for', -- These won't appear in the context
      -- 'while',
      -- 'if',
      "switch",
      -- 'case',
    },
    -- Example for a specific filetype.
    -- If a pattern is missing, *open a PR* so everyone can benefit.
    --   rust = {
    --       'impl_item',
    --   },
  },
  exact_patterns = {
    -- Example for a specific filetype with Lua patterns
    -- Treat patterns.rust as a Lua pattern (i.e "^impl_item$" will
    -- exactly match "impl_item" only)
    -- rust = true,
  },

  -- [!] The options below are exposed but shouldn't require your attention,
  --     you can safely ignore them.

  zindex = 20, -- The Z-index of the context window
  mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
}
