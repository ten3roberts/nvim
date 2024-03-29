return {
  "sindrets/diffview.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>gd", "<cmd>DiffviewOpen<cr>" },
    { "<leader>gD", "<cmd>DiffviewFileHistory %<cr>" },
    {
      "<leader>gd",
      "<esc><cmd>'<,'>DiffviewFileHistory<cr>",
      mode = "x",
    },
  },
  lazy = false,
  config = function()
    require("diffview").setup {
      enhanced_diff_hl = true, -- See ':h diffview-config-enhanced_diff_hl'
      view = {

        merge_tool = {
          -- Config for conflicted files in diff views during a merge or rebase.
          -- layout = "diff3_mixed",
          disable_diagnostics = false, -- Temporarily disable diagnostics for conflict buffers while in the view.
        },
      },

      default_args = {
        DiffviewOpen = { "--untracked-files=no", "--imply-local" },
        DiffviewFileHistory = { "--base=LOCAL" },
      },
      keymaps = {
        view = {
          ["q"] = "<cmd>DiffviewClose<CR>",
        },
        file_history_panel = {
          ["q"] = "<cmd>DiffviewClose<CR>",
        },
        file_panel = {
          ["q"] = "<cmd>DiffviewClose<CR>",
        },
      },
    }
  end,
}
