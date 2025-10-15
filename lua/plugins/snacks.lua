local buffer_opts = {
  finder = "buffers",
  format = "buffer",
  hidden = false,
  unloaded = true,
  current = false,
  sort_lastused = true,
  win = {
    input = {
      keys = {
        ["<c-x>"] = { "bufdelete", mode = { "n", "i" } },
      },
    },
    list = { keys = { ["dd"] = "bufdelete" } },
  },
}

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    explorer = { enabled = true },
    indent = { enabled = true, indent = { only_scope = false, only_current = false } },
    input = {
      enabled = true,
      win = { position = "float", backdrop = false, relative = "cursor" },
    },
    picker = {
      enabled = true,
      matcher = {
        frecency = true,
      },
      win = {
        list = {
          keys = {
            ["<c-i>"] = { "toggle_input", mode = { "n", "i" } },
          },
        },
        input = {
          keys = {
            ["<c-l>"] = { "toggle_lua", mode = { "n", "i" } },
            ["<c-i>"] = { "toggle_input", mode = { "n", "i" } },
            ["<c-t>"] = { "edit_tab", mode = { "n", "i" } },
            ["<c-y>"] = { "yankit", mode = { "n", "i" } },
            ["<c-r>"] = { "picker_grep", mode = { "n", "i" } },
            ["<Esc>"] = { "close", mode = { "n", "i" } },
          },
        },
      },
    },
    image = {
      force = false,
      enabled = true,
      debug = { request = false, convert = false, placement = false },
      math = { enabled = true },
      doc = { inline = true, float = true },
    },
    notifier = {
      enabled = true,
      style = "compact",
      position = "top_center",
      animate = {
        enabled = true,
        duration = 300,
        easing = "inout",
      },
    },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
  },
  keys = {
    {
      "<leader>bd",
      function()
        require("snacks").bufdelete.delete()
      end,
    },
    {
      "<leader>bo",
      function()
        require("snacks").bufdelete.other()
      end,
    },
    {
      "<leader><leader>",
      function()
        require("snacks").picker.files { layout = "ivy" }
      end,
    },
    {
      "z=",
      function()
        require("snacks").picker.spelling()
      end,
    },
    {
      "<leader>,",
      function()
        require("snacks").picker.buffers(vim.tbl_extend("force", buffer_opts, { layout = "ivy" }))
      end,
    },
    {
      "<leader>/",
      function()
        require("snacks").picker.lines()
      end,
      desc = "Buffer lines (fuzzy search)",
    },
    {
      "<leader>?",
      function()
        require("snacks").picker.grep { layout = "ivy" }
      end,
      desc = "Project grep (ivy layout)",
    },
    {
      "<leader>fl",
      function()
        require("snacks").picker.lines()
      end,
      desc = "Buffer local fuzzy search",
    },
    {
      "<leader>fg",
      function()
        require("snacks").picker.git_files()
      end,
      desc = "Git files picker",
    },
    {
      "<leader>fr",
      function()
        require("snacks").picker.recent()
      end,
      desc = "Recent files picker",
    },
    {
      "<leader>sa",
      ":wa<CR>",
      desc = "Save all buffers",
    },
    {
      "<leader>fa",
      function()
        vim.lsp.buf.format()
      end,
      desc = "Format buffer",
    },
    {
      "<leader>cc",
      function()
        require("codecompanion").chat()
      end,
      desc = "Open CodeCompanion chat",
    },
    {
      "<leader>bc",
      ":BCloseHidden<CR>",
      desc = "Close hidden buffers",
    },
    {
      "<leader>tt",
      ":term<CR>",
      desc = "Open terminal",
    },
    {
      "<leader>mt",
      ":Minuet virtualtext toggle<CR>",
      desc = "Toggle Minuet virtual text",
    },
    {
      "<leader>dd",
      function()
        Snacks.picker.grep { search = "^(?!\\s*--).*\\b(bt|dd)\\(", args = { "-P" }, live = false, ft = "lua" }
      end,
      desc = "Debug Searcher",
    },
    {
      "<leader>si",
      function()
        require("snacks").picker.icons()
      end,
    },
    {
      "<leader>u",
      function()
        require("snacks").picker.undo()
      end,
    },
    {
      "<leader>o",
      function()
        require("snacks").picker.lsp_symbols()
      end,
    },
    {
      "<leader>O",
      function()
        require("snacks").picker.lsp_workspace_symbols()
      end,
    },
    {
      "<leader>q",
      function()
        require("snacks").picker.diagnostics_buffer()
      end,
    },
    {
      "<leader>Q",
      function()
        require("snacks").picker.diagnostics()
      end,
    },
  },
  config = function(_, opts)
    local Snacks = require("snacks").setup(opts)

    vim.api.nvim_create_autocmd("User", {
      pattern = "OilActionsPost",
      callback = function(event)
        if event.data.actions.type == "move" then
          Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
        end
      end,
    })
  end,
}
