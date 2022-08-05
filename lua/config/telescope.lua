local actions = require "telescope.actions"

local telescope = require "telescope"

local ivy = require("telescope.themes").get_ivy {
  layout_config = { width = 0.7, height = 0.7 },
  border = false,
}

telescope.setup {
  defaults = {
    -- vimgrep_arguments = {
    --   "rg",
    --   -- '--fixed-strings',
    --   "--color=never",
    --   "--no-heading",
    --   "--with-filename",
    --   "--line-number",
    --   "--column",
    --   "--smart-case",
    -- },
    layout_config = {
      horizontal = {
        prompt_position = "top",
      },
      width = function(_, cols, _)
        return math.min(180, math.floor(cols * 0.75))
      end,
      height = 0.5,
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
        ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
        -- ["<C-i>"] = my_cool_custom_action,
      },
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
        },
      },
    },
    current_buffer_fuzzy_find = ivy,
    diagnostics = ivy,
    lsp_references = ivy,
    live_grep = ivy,
    grep_string = ivy,
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
  },
}

telescope.load_extension "fzf"
telescope.load_extension "dap"

local function map(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, opts)
end

local builtin = require "telescope.builtin"

-- Telescope
map("n", "<leader><leader>", builtin.find_files)

-- map('n',    '<leader>f',        '<cmd>lua require "telescope".extensions.file_browser.file_browser { path="%:p:h" }<CR>')
map("n", "<leader>rf", builtin.oldfiles)
map("n", "<M-x>", builtin.command_history)
map("n", "<leader>,", builtin.buffers)
map("n", "<leader>/", builtin.current_buffer_fuzzy_find)
map("n", "<leader>rg", builtin.live_grep)
map("n", "<leader>gl", builtin.git_commits)
map("n", "<leader>gs", builtin.git_status)
map("n", "<leader>o", builtin.lsp_document_symbols)
map("n", "<leader>O", builtin.lsp_dynamic_workspace_symbols)
map("n", "<leader>D", builtin.diagnostics)
map("n", "z=", builtin.spell_suggest)
