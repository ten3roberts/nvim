local keybinds = require("config.keybind_definitions")

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
      keybinds.getKeybind("snacks-buffer-delete"),
      function()
        require("snacks").bufdelete.delete()
      end,
      desc = keybinds.getDesc("snacks-buffer-delete"),
    },
    {
      keybinds.getKeybind("snacks-buffer-delete-others"),
      function()
        require("snacks").bufdelete.other()
      end,
      desc = keybinds.getDesc("snacks-buffer-delete-others"),
    },
    {
      keybinds.getKeybind("snacks-files-picker"),
      function()
        require("snacks").picker.files({ layout = "ivy" })
      end,
      desc = keybinds.getDesc("snacks-files-picker"),
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
      keybinds.getKeybind("snacks-spelling-picker"),
      function()
        require("snacks").picker.spelling()
      end,
      desc = keybinds.getDesc("snacks-spelling-picker"),
    },
    {
      keybinds.getKeybind("snacks-buffers-picker"),
      function()
        require("snacks").picker.buffers(vim.tbl_extend("force", buffer_opts, { layout = "ivy" }))
      end,
      desc = keybinds.getDesc("snacks-buffers-picker"),
    },
    {
      keybinds.getKeybind("snacks-buffer-lines"),
      function()
        require("snacks").picker.lines()
      end,
      desc = keybinds.getDesc("snacks-buffer-lines"),
    },
    {
      keybinds.getKeybind("snacks-project-grep"),
      function()
        require("snacks").picker.grep({ layout = "ivy" })
      end,
      desc = keybinds.getDesc("snacks-project-grep"),
    },
    {
      keybinds.getKeybind("snacks-git-files-picker"),
      function()
        require("snacks").picker.git_files()
      end,
      desc = keybinds.getDesc("snacks-git-files-picker"),
    },
    {
      keybinds.getKeybind("snacks-recent-files-picker"),
      function()
        require("snacks").picker.recent()
      end,
      desc = keybinds.getDesc("snacks-recent-files-picker"),
    },
    {
      keybinds.getKeybind("snacks-save-all-buffers"),
      ":wa<CR>",
      desc = keybinds.getDesc("snacks-save-all-buffers"),
    },
    {
      keybinds.getKeybind("snacks-format-buffer"),
      function()
        vim.lsp.buf.format()
      end,
      desc = keybinds.getDesc("snacks-format-buffer"),
    },
    {
      keybinds.getKeybind("snacks-close-hidden-buffers"),
      ":BCloseHidden<CR>",
      desc = keybinds.getDesc("snacks-close-hidden-buffers"),
    },
    {
      keybinds.getKeybind("snacks-open-terminal"),
      ":term<CR>",
      desc = keybinds.getDesc("snacks-open-terminal"),
    },
    {
      keybinds.getKeybind("snacks-toggle-minuet-virtual-text"),
      ":Minuet virtualtext toggle<CR>",
      desc = keybinds.getDesc("snacks-toggle-minuet-virtual-text"),
    },
    {
      keybinds.getKeybind("snacks-debug-searcher"),
      function()
        Snacks.picker.grep { search = "^(?!\\s*--).*\\b(bt|dd)\\(", args = { "-P" }, live = false, ft = "lua" }
      end,
      desc = keybinds.getDesc("snacks-debug-searcher"),
    },
    {
      keybinds.getKeybind("snacks-icons-picker"),
      function()
        require("snacks").picker.icons()
      end,
      desc = keybinds.getDesc("snacks-icons-picker"),
    },
    {
      keybinds.getKeybind("snacks-undo-picker"),
      function()
        require("snacks").picker.undo()
      end,
      desc = keybinds.getDesc("snacks-undo-picker"),
    },
    {
      keybinds.getKeybind("snacks-lsp-symbols-picker"),
      function()
        require("snacks").picker.lsp_symbols()
      end,
      desc = keybinds.getDesc("snacks-lsp-symbols-picker"),
    },
    {
      keybinds.getKeybind("snacks-lsp-workspace-symbols-picker"),
      function()
        require("snacks").picker.lsp_workspace_symbols()
      end,
      desc = keybinds.getDesc("snacks-lsp-workspace-symbols-picker"),
    },
    {
      keybinds.getKeybind("snacks-diagnostics-buffer-picker"),
      function()
        require("snacks").picker.diagnostics_buffer()
      end,
      desc = keybinds.getDesc("snacks-diagnostics-buffer-picker"),
    },
    {
      keybinds.getKeybind("snacks-diagnostics-picker"),
      function()
        require("snacks").picker.diagnostics()
      end,
      desc = keybinds.getDesc("snacks-diagnostics-picker"),
    },
    {
      keybinds.getKeybind("snacks-buffer-lines-picker"),
      function()
        require("snacks").picker.lines()
      end,
      desc = keybinds.getDesc("snacks-buffer-lines-picker"),
    },
    {
      keybinds.getKeybind("snacks-refine-picker-results"),
      function()
        -- refine
      end,
      mode = { "n", "i" },
      desc = keybinds.getDesc("snacks-refine-picker-results"),
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
