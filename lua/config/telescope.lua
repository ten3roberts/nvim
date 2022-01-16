local actions = require'telescope.actions'

local telescope = require"telescope"

telescope.setup{
  defaults = require'telescope.themes'.get_dropdown {
    vimgrep_arguments = {
      'rg',
      '--fixed-strings',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case'
    },
    prompt_prefix = "> ",
    layout_config = { width = 0.5 },
    selection_caret = "> ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    file_sorter =  require'telescope.sorters'.get_fuzzy_file,
    file_ignore_patterns = {},
    generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
    winblend = 10,
    border = {},
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },

    mappings = {
      i = {
        ["<C-c>"] = actions.close,
        ["<A-a>"] = actions.toggle_selection,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-n>"] = actions.move_selection_next,
        ["<C-p>"] = actions.move_selection_previous,
        ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
        -- To disable a keymap, put [map] = false
        -- So, to not map "<C-n>", just put
        -- ["<c-x>"] = false,
        -- ["<Esc>"] = actions.close,

        -- Otherwise, just set the mapping to the function that you want it to be.
        -- ["<C-i>"] = actions.select_horizontal,

        -- Add up multiple actions
        ["<CR>"] = actions.select_default + actions.center,
        ["<Tab>"] = actions.select_default + actions.center,
        ["<C-s>"] = actions.file_tab,
        ["<C-v>"] = actions.file_vsplit,
        ["<C-h>"] = actions.file_split,
        -- ["<C-s>"] = custom_actions.file_drop,

        -- You can perform as many actions in a row as you like
        -- ["<CR>"] = actions.select_default + actions.center + my_cool_custom_action,
      },
      n = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist
        -- ["<C-i>"] = my_cool_custom_action,
      }
    },
  },
  pickers = {
    buffers = {
      sort_lastused = true,
      ignore_current_buffer = true,
      selection_strategy = "reset",
      previewer = false,
      bufnr_width = 2,
      mappings = {
        i = {
          ["<c-d>"] = require("telescope.actions").delete_buffer,
        },
        n = {
          ["<c-d>"] = require("telescope.actions").delete_buffer,
        }
      }
    },
    current_buffer_fuzzy_find = require'telescope.themes'.get_ivy{
      layout_config = { width = 0.7, height = 0.7 },
    },
    live_grep = require'telescope.themes'.get_ivy{
      layout_config = { width = 0.7, height = 0.7 },
      mappings = {
        i = {
          -- ["<CR>"] = custom_actions.file_drop,
        }
      }
    },
    lsp_code_actions = {
      theme = 'cursor',
    }
  },

  extensions = {
    fzy_native = {
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
    },
    file_browser = require 'telescope.themes'.get_dropdown {
      -- theme = "ivy",
      layout_config = { width = 0.5, height = 0.5 },
    },
    project = {
      base_dirs = {
        { path = '~/dev', max_depth = 4 },
        { '~/.config/nvim' }
      },
      hidden_files = false -- default: false
    }
  },
}

telescope.load_extension 'fzy_native'
telescope.load_extension 'dap'
telescope.load_extension 'project'
