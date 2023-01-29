return {

  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    keys = {
      { "z=", "<cmd>Telescope spell_suggest<CR>" },
      {
        "<leader><leader>",
        function()
          require("telescope.builtin").find_files {}
        end,
      },
      {
        "<leader>o",
        function()
          require("telescope.builtin").lsp_document_symbols {}
        end,
      },
      {
        "<leader>O",
        function()
          require("telescope.builtin").lsp_dynamic_workspace_symbols {}
        end,
      },
      {
        "<leader>rg",
        function()
          require("telescope.builtin").live_grep {}
        end,
      },
      {
        "<leader>rh",
        function()
          require("telescope.builtin").help_tags {}
        end,
      },
      {
        "<leader>rG",
        function()
          require("telescope.builtin").grep_string {}
        end,
      },
      {
        "<leader>/",
        function()
          require("telescope.builtin").current_buffer_fuzzy_find {}
        end,
      },
      {
        "<leader>,",
        function()
          require("telescope.builtin").buffers {}
        end,
      },
    },
    config = function()
      local actions = require "telescope.actions"

      local telescope = require "telescope"

      local ivy = require("telescope.themes").get_ivy {
        layout_config = { width = 0.7, height = 0.7 },
      }

      telescope.setup {
        defaults = {
          vimgrep_arguments = {
            "rg",
            "--fixed-strings",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
          },
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
          winblend = 10,
          border = true,
          borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
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
              ["<c-f>"] = actions.to_fuzzy_refine,
              -- To disable a keymap, put [map] = false
              -- So, to not map "<C-n>", just put
              -- ["<c-x>"] = false,
              ["<Esc>"] = actions.close,

              -- Otherwise, just set the mapping to the function that you want it to be.
              -- ["<C-i>"] = actions.select_horizontal,

              -- Add up multiple actions
              -- ["<CR>"] = actions.select_default + actions.center,

              -- ["<C-h>"] = actions.file_split,
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
    end,
  },
}
