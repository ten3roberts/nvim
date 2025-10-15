return {
  {
    "olimorris/codecompanion.nvim",
    event = "VeryLazy",
    opts = {
      -- strategies = {
      --   chat = {
      --     adapter = {
      --       name = "copilot",
      --       model = "claude-sonnet-4",
      --     },
      --   },
      -- },
      --   -- Change the default chat adapter and model
      --   chat = {
      --     adapter = "anthropic",
      --     model = "claude-sonnet-4-20250514",
      --   },
      -- },
      -- NOTE: The log_level is in `opts.opts`
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
        { "n", "v" },
        keybinds.getKeybind "codecompanion-chat-toggle",
        "<cmd>CodeCompanionChat Toggle<cr>",
        { noremap = true, silent = true, desc = keybinds.getDesc "codecompanion-chat-toggle" }
      )
      vim.keymap.set(
        "v",
        keybinds.getKeybind "codecompanion-chat-add",
        "<cmd>CodeCompanionChat Add<cr>",
        { noremap = true, silent = true, desc = keybinds.getDesc "codecompanion-chat-add" }
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
