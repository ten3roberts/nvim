return {

  {
    "Weissle/persistent-breakpoints.nvim",
    event = "VeryLazy",
    config = function()
      require("persistent-breakpoints").setup {
        load_breakpoints_event = { "BufReadPost" },
      }
    end,
  },

  {
    "nvim-telescope/telescope-dap.nvim",
    config = function()
      require("telescope").load_extension "dap"
    end,
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "Weissle/persistent-breakpoints.nvim",
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
    },
    keys = {
      {
        "<leader>dn",
        function()
          require("dap").step_over()
        end,
      },
      {
        "<leader>di",
        function()
          require("dap").step_into()
        end,
      },
      {
        "<leader>do",
        function()
          require("dap").step_out()
        end,
      },
      {
        "<leader>dd",
        function()
          require("dap").down()
        end,
      },
      {
        "<leader>du",
        function()
          require("dap").up()
        end,
      },
      {
        "<leader>dq",
        function()
          require("dap").terminate()
        end,
      },
      {
        "<leader>dr",
        function()
          require("dap").restart()
        end,
      },

      {
        "<leader>dg",
        function()
          require("dap").run_to_cursor()
        end,
      },
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
      },
      {
        "<leader>dbb",
        function()
          -- require("dap").toggle_breakpoint()
          require("persistent-breakpoints.api").toggle_breakpoint()
        end,
      },
      {
        "<leader>dbB",
        function()
          require("persistent-breakpoints.api").set_conditional_breakpoint()
        end,
      },
      {
        "<leader>dbe",
        function()
          require("dap").set_exception_breakpoints()
        end,
      },
      {
        "<leader>dl",
        function()
          require("dap").run_last()
        end,
      },

      {
        "<leader>dh",
        function()
          require("dap.ui.widgets").hover()
        end,
      },
      {
        "<leader>dp",
        function()
          require("dap.ui.widgets").preview()
        end,
      },
      {
        "<leader>df",
        function()
          require("telescope").extensions.dap.frames()
        end,
      },
      {
        "<leader>ds",
        function()
          local widgets = require "dap.ui.widgets"
          widgets.centered_float(widgets.scopes)
        end,
      },
    },
    config = function()
      require "config.dap"
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
  },
  {
    "rcarriga/nvim-dap-ui",
  },
}
