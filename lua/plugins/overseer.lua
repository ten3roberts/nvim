return {
  "stevearc/overseer.nvim",
  lazy = "false",
  keys = {
    { "<leader>co", "<cmd>OverseerToggle<cr>", desc = "Toggle Overseer" },
    { "<leader>cr", "<cmd>OverseerRun<cr>", desc = "Start a new task" },
    { "<leader>cS", "<cmd>OverseerRunCmd<cr>", desc = "Start a new task with command" },
    { "<leader>cR", "<cmd>OverseerResume<cr>", desc = "Resume last task" },
    { "<leader>cC", "<cmd>OverseerClose<cr>", desc = "Close Overseer" },
  },

  opts = {},
}
