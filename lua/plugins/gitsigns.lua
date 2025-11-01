return {
  "lewis6991/gitsigns.nvim",
  event = "BufReadPre",
  config = function()
    local keybinds = require("config.keybind_definitions")
    require("gitsigns").setup {
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
      signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
      numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
      linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
      word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
      watch_gitdir = {
        follow_files = true,
      },
      auto_attach = true,
      attach_to_untracked = false,
      current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
        delay = 0,
        ignore_whitespace = false,
        virt_text_priority = 100,
      },
      current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil, -- Use default
      max_file_length = 40000, -- Disable if file is longer than this (in lines)
      preview_config = {
        -- Options passed to nvim_open_win
        border = "single",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },
      on_attach = function(bufnr)
        local gitsigns = require "gitsigns"

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map("n", keybinds.getKeybind("gitsigns-next-hunk"), function()
          if vim.wo.diff then
            vim.cmd.normal { "]c", bang = true }
          else
            gitsigns.nav_hunk "next"
          end
        end, { desc = keybinds.getDesc("gitsigns-next-hunk") })

        map("n", keybinds.getKeybind("gitsigns-prev-hunk"), function()
          if vim.wo.diff then
            vim.cmd.normal { "[c", bang = true }
          else
            gitsigns.nav_hunk "prev"
          end
        end, { desc = keybinds.getDesc("gitsigns-prev-hunk") })

        map("n", keybinds.getKeybind("gitsigns-next-hunk-alt"), function()
          if vim.wo.diff then
            vim.cmd.normal { "]c", bang = true }
          else
            gitsigns.nav_hunk "next"
          end
        end, { desc = keybinds.getDesc("gitsigns-next-hunk-alt") })

        map("n", keybinds.getKeybind("gitsigns-prev-hunk-alt"), function()
          if vim.wo.diff then
            vim.cmd.normal { "[c", bang = true }
          else
            gitsigns.nav_hunk "prev"
          end
        end, { desc = keybinds.getDesc("gitsigns-prev-hunk-alt") })

        -- Actions
        map("n", keybinds.getKeybind("gitsigns-stage-hunk"), gitsigns.stage_hunk, { desc = keybinds.getDesc("gitsigns-stage-hunk") })
        map("n", keybinds.getKeybind("gitsigns-reset-hunk"), gitsigns.reset_hunk, { desc = keybinds.getDesc("gitsigns-reset-hunk") })
        map("n", keybinds.getKeybind("gitsigns-unstage-hunk"), gitsigns.reset_hunk, { desc = keybinds.getDesc("gitsigns-unstage-hunk") })
        map("v", keybinds.getKeybind("gitsigns-stage-hunk"), function()
          gitsigns.stage_hunk { vim.fn.line ".", vim.fn.line "v" }
        end, { desc = keybinds.getDesc("gitsigns-stage-hunk") })
        map("v", keybinds.getKeybind("gitsigns-reset-hunk"), function()
          gitsigns.reset_hunk { vim.fn.line ".", vim.fn.line "v" }
        end, { desc = keybinds.getDesc("gitsigns-reset-hunk") })
        map("v", keybinds.getKeybind("gitsigns-unstage-hunk"), function()
          gitsigns.reset_hunk { vim.fn.line ".", vim.fn.line "v" }
        end, { desc = keybinds.getDesc("gitsigns-unstage-hunk") })
        map("n", "<leader>hS", gitsigns.stage_buffer)
        map("n", "<leader>hR", gitsigns.reset_buffer)
        map("n", keybinds.getKeybind("gitsigns-preview-hunk"), gitsigns.preview_hunk, { desc = keybinds.getDesc("gitsigns-preview-hunk") })
        map("n", "<leader>hi", gitsigns.preview_hunk_inline)
        map("n", keybinds.getKeybind("gitsigns-blame-line"), function()
          gitsigns.blame_line { full = true }
        end, { desc = keybinds.getDesc("gitsigns-blame-line") })
        map("n", keybinds.getKeybind("gitsigns-diffthis"), gitsigns.diffthis, { desc = keybinds.getDesc("gitsigns-diffthis") })
        map("n", "<leader>hD", function()
          gitsigns.diffthis "~"
        end)
        map("n", "<leader>hQ", function()
          gitsigns.setqflist "all"
        end)
        map("n", "<leader>hq", gitsigns.setqflist)

        -- Toggles
        map("n", keybinds.getKeybind("gitsigns-toggle-blame"), gitsigns.toggle_current_line_blame, { desc = keybinds.getDesc("gitsigns-toggle-blame") })
        map("n", "<leader>tw", gitsigns.toggle_word_diff)

        -- Text object
        map({ "o", "x" }, "ih", gitsigns.select_hunk)
      end,
    }
  end,
}