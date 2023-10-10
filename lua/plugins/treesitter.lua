local function human_number(num)
  if num > 1024 * 1024 * 1024 then
    return string.format("%.1fGB", num / 1e6)
  elseif num > 1024 * 1024 then
    return string.format("%.1fMB", num / 1e6)
  elseif num > 1024 then
    return string.format("%.1fKB", num / 1e3)
  end
end
local function disable_large_file(module, max_size)
  return function(_, buf)
    max_size = max_size or (100 * 1024) -- 100 KB
    local fname = vim.api.nvim_buf_get_name(buf)
    local size = vim.fn.getfsize(fname)
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
    if ok and stats and stats.size > max_size then
      vim.notify(
        string.format("Disabled %s\n\nSize: %s", module, vim.api.nvim_buf_get_name(buf), human_number(size)),
        vim.log.levels.WARN
      )
      return true
    end
  end
end

return {
  {
    "nvim-treesitter/nvim-treesitter-context",
    config = function()
      -- require("treesitter-context").setup {
      --   enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
      --   trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
      --   -- mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
      -- }
      vim.keymap.set("n", "[c", function()
        require("treesitter-context").go_to_context()
      end, { silent = true })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      -- "RRethy/nvim-treesitter-textsubjects",
      "nvim-treesitter/playground",
      -- "nvim-treesitter/nvim-treesitter-textobjects",
      -- "nvim-treesitter/nvim-treesitter-refactor",
    },
    config = function()
      -- vim.filetype.add { extension = { wgsl = "wgsl" } }

      -- local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      -- parser_config.wgsl = {
      --   install_info = {
      --     url = "https://github.com/szebniok/tree-sitter-wgsl",
      --     files = { "src/parser.c" },
      --   },
      -- }

      require("nvim-treesitter.configs").setup {
        ensure_installed = "all",
        sync_install = false,
        auto_install = true,
        ignore_install = {},
        modules = {},
        autopairs = { enable = true },
        autotag = {
          enable = { "html", "xml", "lua" },
        },
        playground = { enable = true },
        -- matchup = { enable = true, disable = disable_large_file "matchup" },
        highlight = {
          enable = true,
          disable = disable_large_file("highlight", 1000 * 1024),
        },
        -- incremental_selection = {
        --   enable = true,
        --   keymaps = {
        --     init_selection = "<CR>",
        --     node_incremental = "<CR>",
        --     scope_incremental = "<S-CR>",
        --     node_decremental = "<BS>",
        --   },
        -- },
        -- refactor = {
        --   disable = disable_large_file "refactor",
        --   highlight_definitions = {
        --     enable = true,
        --     disable = disable_large_file "highlight",
        --     -- Set to false if you have an `updatetime` of ~100.
        --     clear_on_cursor_move = false,
        --   },
        --   highlight_current_scope = { enable = false },
        --   smart_rename = {
        --     enable = true,
        --     keymaps = {
        --       smart_rename = "grr",
        --     },
        --   },
        --   navigation = {
        --     enable = true,
        --     keymaps = {
        --       goto_definition = "gnd",
        --       list_definitions = "gnD",
        --       list_definitions_toc = "gO",
        --       goto_next_usage = "gnn",
        --       goto_previous_usage = "gNN",
        --     },
        --   },
        -- },

        -- textobjects = {
        --   select = {
        --     enable = true,
        --     lookahead = true,
        --     keymaps = {
        --       -- You can use the capture groups defined in textobjects.scm
        --       -- ["af"] = "@function.outer",
        --       -- ["if"] = "@function.inner",
        --       -- ["ac"] = "@class.outer",
        --       -- ["ic"] = "@class.inner",
        --       -- ["iA"] = "@parameter.inner",
        --       -- ["aA"] = "@parameter.outer",
        --       ["i;"] = "@call.inner",
        --       ["a;"] = "@call.outer",
        --     },
        --   },
        --   move = {
        --     enable = true,
        --     set_jumps = true, -- whether to set jumps in the jumplist
        --     goto_next_start = {
        --       ["]m"] = "@function.outer",
        --       ["]]"] = "@class.outer",
        --     },
        --     goto_next_end = {
        --       ["]M"] = "@function.outer",
        --       ["]["] = "@class.outer",
        --     },
        --     goto_previous_start = {
        --       ["[m"] = "@function.outer",
        --       ["[["] = "@class.outer",
        --     },
        --     goto_previous_end = {
        --       ["[M"] = "@function.outer",
        --       ["[]"] = "@class.outer",
        --     },
        --   },
        --   swap = {
        --     enable = true,
        --     swap_next = {
        --       ["<A-l>"] = "@parameter.inner",
        --     },
        --     swap_previous = {
        --       ["<A-h>"] = "@parameter.inner",
        --     },
        --   },
        -- },
        -- textsubjects = {
        --   enable = true,
        --   prev_selection = ",", -- (Optional) keymap to select the previous selection
        --   keymaps = {
        --     ["."] = "textsubjects-smart",
        --     ["ac"] = "textsubjects-container-outer",
        --     ["ic"] = "textsubjects-container-inner",
        --   },
        -- },
        -- indent = { enable = true },
      }
    end,
  },
}
