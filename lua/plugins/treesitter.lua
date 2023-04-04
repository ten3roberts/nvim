return {
  {
    "mizlan/iswap.nvim",
    config = function()
      require("iswap").setup {}
    end,
  },
  -- "p00f/nvim-ts-rainbow",
  "nvim-treesitter/playground",
  "nvim-treesitter/nvim-treesitter-textobjects",
  "nvim-treesitter/nvim-treesitter-refactor",
  {
    "nvim-treesitter/nvim-treesitter-context",
    config = function()
      require("treesitter-context").setup {
        enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
        trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
        -- mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
      }

      vim.cmd.hi("TreesitterContextBottom", "gui=underline", "guisp=Grey")
    end,
  },
  "RRethy/nvim-treesitter-textsubjects",
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      vim.filetype.add { extension = { wgsl = "wgsl" } }

      -- local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      -- parser_config.wgsl = {
      --   install_info = {
      --     url = "https://github.com/szebniok/tree-sitter-wgsl",
      --     files = { "src/parser.c" },
      --   },
      -- }

      require("nvim-treesitter.configs").setup {
        ensure_installed = "all",
        autopairs = { enable = true },
        autotag = {
          enable = true,
        },
        playground = { enable = true },
        matchup = { enable = true },
        highlight = {
          enable = true,
          disable = function(_, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<CR>",
            node_incremental = "<CR>",
            scope_incremental = "<S-CR>",
            node_decremental = "<BS>",
          },
        },
        refactor = {
          disable = function(_, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,
          highlight_definitions = {
            enable = true,
            -- Set to false if you have an `updatetime` of ~100.
            -- clear_on_cursor_move = true,
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
              -- goto_next_usage = ")",
              -- goto_previous_usage = "(",
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
              -- ["iA"] = "@parameter.inner",
              -- ["aA"] = "@parameter.outer",
              ["i;"] = "@call.inner",
              ["a;"] = "@call.outer",
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
            enable = true,
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
          -- prev_selection = ",", -- (Optional) keymap to select the previous selection
          keymaps = {
            ["."] = "textsubjects-smart",
            ["ac"] = "textsubjects-container-outer",
            ["ic"] = "textsubjects-container-inner",
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
    end,
  },
}
