return {
  {
    "olimorris/codecompanion.nvim",
    event = "VeryLazy",
    opts = {
      adapters = {
        anthropic = {
          model = "claude-sonnet-4-20250514",
        },
      },
      strategies = {
        inline = {
          adapter = "anthropic",
        },
      },
      opts = {
        log_level = "DEBUG",
      },
    },
    config = function(_, opts)
      local keybinds = require "config.keybind_definitions"
      vim.keymap.set(
        { "n", "v" },
        keybinds.getKeybind "codecompanion-actions",
        "<cmd>CodeCompanionActions<cr>",
        { noremap = true, silent = true, desc = keybinds.getDesc "codecompanion-actions" }
      )

      vim.keymap.set(
        "v",
        keybinds.getKeybind "codecompanion-inline",
        "<cmd>CodeCompanion<cr>",
        { noremap = true, silent = true, desc = keybinds.getDesc "codecompanion-inline" }
      )

      -- Expand 'cc' into 'CodeCompanion' in the command line
      vim.cmd [[cab cc CodeCompanion]]

      require("codecompanion").setup(opts)
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "codecompanion", "Avante" },
  },
   {
     "HakonHarnes/img-clip.nvim",
     opts = {
       filetypes = {
         codecompanion = {
           prompt_for_file_name = false,
           template = "[Image]($FILE_PATH)",
           use_absolute_path = true,
         },
       },
     },
   },
 }
