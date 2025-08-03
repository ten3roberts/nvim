return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-jest",
      "rouge8/neotest-rust",
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      -- Define commands
      vim.api.nvim_create_user_command("NeotestSummary", function()
        require("neotest").summary.toggle()
      end, { desc = "Toggle Neotest Summary" })

      vim.api.nvim_create_user_command("NeotestRun", function()
        require("neotest").run.run()
      end, { desc = "Run Neotest" })

      vim.api.nvim_create_user_command("NeotestRunFile", function()
        require("neotest").run.run(vim.fn.expand "%")
      end, { desc = "Run Neotest on Current File" })

      vim.api.nvim_create_user_command("NeotestRunNearest", function()
        require("neotest").run.run { nearest = true }
      end, { desc = "Run Neotest on Nearest Test" })

      require("neotest").setup {
        adapters = {
          require "neotest-jest" {
            jestCommand = "pnpm test --",
            jestConfigFile = "custom.jest.config.ts",
            env = { CI = true },
            cwd = function(_)
              return vim.fn.getcwd()
            end,
          },
          require "neotest-rust" {
            args = { "--no-capture" },
          },
        },
        diagnostics = {
          enabled = true,
          virtual_text = true,
          underline = true,
          update_in_insert = true,
        },
        status = {
          enabled = true,
          signs = true,
          virtual_text = false,
        },
      }
    end,
  },
}
