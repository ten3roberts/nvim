require 'nvim-treesitter'.define_modules {
  auto_folding = {
    attach = function(_, _)
      -- Do cool stuff here
      vim.wo.foldmethod = "expr"
      vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
      vim.notify("Enabling treesitter folding")
    end,
    detach = function(_)
      vim.bo.foldmethod = "indent"
    end,
    is_supported = function(lang)
      -- local supported = {
      --   rust = true,
      --   lua = true
      -- }

      return true
    end
  }
}
require "nvim-treesitter.configs".setup {
  ensure_installed = "all",
  autopairs = { enable = true },
  playground = { enable = true },
  matchup = { enable = true },
  highlight = {
    enable = true,
    disable = { "latex" }
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "g+",
      scope_incremental = "grc",
      node_decremental = "g-",
    },
  },
  refactor = {
    highlight_definitions = {
      enable = true,
      -- Set to false if you have an `updatetime` of ~100.
      clear_on_cursor_move = true,
    },
    highlight_current_scope = { enable = false },
    smart_rename = {
      enable = true,
      keymaps = {
        smart_rename = "grr",
      }
    },
    navigation = {
      enable = true,
      keymaps = {
        goto_definition = "gnd",
        list_definitions = "gnD",
        list_definitions_toc = "gO",
        goto_next_usage = "<a-*>",
        goto_previous_usage = "<a-#>",
      },
    }
  },
  textsubjects = {
    enable = true,
    prev_selection = ',', -- (Optional) keymap to select the previous selection
    keymaps = {
      ['.'] = 'textsubjects-smart',
      [';'] = 'textsubjects-container-outer',
      ['i;'] = 'textsubjects-container-inner',
    },
  },
  indent = { enable = true },
  auto_folding = { enable = true },
}
