local actions = require 'telescope.actions'

local telescope = require "telescope"

telescope.setup {
  defaults = {
    vimgrep_arguments = {
      'rg',
      -- '--fixed-strings',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case'
    },
    layout_config = {
      horizontal = {
        prompt_position = "top"
      },
      width = function(_, cols, _)
        return math.min(120, math.floor(cols * 0.75))
      end,
      height = 0.5
    },
    sorting_strategy = "ascending",
    border = false,
    -- borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
    path_display = { "truncate" },
    prompt_prefix = "   ",
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
        -- ["<CR>"] = actions.select_default + actions.center,
        ["<Tab>"] = actions.select_default + actions.center,
        ["<C-s>"] = actions.file_tab,
        ["<C-v>"] = actions.file_vsplit,
        ["<C-h>"] = actions.file_split,
        -- ["<C-s>"] = custom_actions.file_drop,

        -- You can perform as many actions in a row as you like
        -- ["<CR>"] = actions.select_default + actions.center + my_cool_custom_action,
      },
      n = {
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
    current_buffer_fuzzy_find = require 'telescope.themes'.get_ivy {
      border = false,
      layout_config = { width = 0.7, height = 0.7 },
    },
    diagnostics = require 'telescope.themes'.get_ivy {
      layout_config = { width = 0.7, height = 0.7 },
      border = false,
      mappings = {
        i = {
          -- ["<CR>"] = custom_actions.file_drop,
        }
      }
    },
    live_grep = require 'telescope.themes'.get_ivy {
      layout_config = { width = 0.7, height = 0.7 },
      border = false,
      mappings = {
        i = {
          -- ["<CR>"] = custom_actions.file_drop,
        }
      }
    },
  },

  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
    file_browser = {
      path = "%:p:h",
    },
    project = {
      mappings = {
        i = {
          ["<c-e>"] = actions.file_edit,
        },
        n = {
          ["<c-e>"] = actions.file_edit,
        }
      },
      base_dirs = {
        { path = '~/dev', max_depth = 4 },
        { '~/.config/nvim' }
      },
      hidden_files = false -- default: false
    }
  },
}

telescope.load_extension 'fzf'
telescope.load_extension 'dap'
telescope.load_extension('harpoon')


local function map(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Telescope
map('n', '<leader><leader>', ':Telescope find_files<CR>')
-- map('n',    '<leader>f',        '<cmd>lua require "telescope".extensions.file_browser.file_browser { path="%:p:h" }<CR>')
map('n', '<leader>rf', ':Telescope oldfiles<CR>')
map('n', '<M-x>', ':Telescope command_history<CR>')
map('n', '<leader>,', ':Telescope buffers<CR>')
map('n', '<leader>/', ':Telescope current_buffer_fuzzy_find<CR>')
map('n', '<leader>/', ':Telescope current_buffer_fuzzy_find<CR>')
map('n', '<leader>rg', ':Telescope live_grep<CR>')
map('n', '<leader>gl', ':Telescope git_commits<CR>')
map('n', '<leader>gs', ':Telescope git_status<CR>')
map('n', '<leader>o', ':Telescope lsp_document_symbols<CR>')
map('n', '<leader>O', ':Telescope lsp_dynamic_workspace_symbols<CR>')
map('n', '<leader>dd', ':Telescope lsp_document_diagnostics<CR>')
map('n', '<leader>D', ':Telescope diagnostics<CR>')
map('n', '<leader>pp', ":SessionLoad<CR>")
map('n', '<leader>pp', ":SessionLoad<CR>")
