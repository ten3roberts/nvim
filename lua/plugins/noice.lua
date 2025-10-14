return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        cmdline = {
          enabled = true,
          view = "cmdline_popup",  -- Fancy popup for command line
          format = {
            cmdline = { pattern = "^:", icon = "", lang = "vim" },
            search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
            search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
            filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
            lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
            help = { pattern = "^:%s*he?l?p?%s+", icon = "" },
          },
        },
        messages = {
          enabled = false,  -- Disable since using snacks.notify
        },
        popupmenu = {
          enabled = true,
          backend = "nui",
        },
        notify = {
          enabled = false,  -- Disable since using snacks.notify
        },
        lsp = {
          progress = {
            enabled = false,  -- Disable LSP progress since using snacks
          },
          hover = {
            enabled = false,
          },
          signature = {
            enabled = false,
          },
          message = {
            enabled = false,
          },
        },
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
          inc_rename = false,
          lsp_doc_border = false,
        },
      })
    end,
  },
}