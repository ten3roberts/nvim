local keybinds = require "config.keybind_definitions"

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

-- Snacks provides unified UI components (picker, notifications, dashboard, etc.)
-- Chosen over Telescope for consistency and better Neovim integration
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
    dashboard = { enabled = false },
    explorer = { enabled = false },
    indent = { enabled = false, indent = { only_scope = false, only_current = false } },
    input = {
      enabled = true,
      win = { position = "float", backdrop = false, relative = "cursor" },
    },
    picker = {
      enabled = true,
      layout = {
        width = function()
          return math.max(0.4 * vim.o.columns, 120)
        end,
      },
      layouts = {
        default = {
          layout = {
            box = "horizontal",
            backdrop = false,
            width = 0.8,
            min_width = 120,
            height = 0.8,
            {
              box = "vertical",
              border = "rounded",
              title = "{title} {live} {flags}",
              { win = "input", height = 1, border = "none" },
              { win = "list", border = "none" },
            },
            { win = "preview", title = "{preview}", border = "none", width = 0.3 },
          },
        },
        ivy = {
          layout = {
            box = "vertical",
            backdrop = false,
            row = -1,
            width = 0,
            height = 0.6,
            border = "top",
            title = " {title} {live} {flags}",
            title_pos = "left",
            { win = "input", height = 1, border = "none" },
            {
              box = "horizontal",
              { win = "list", border = "none" },
              { win = "preview", title = "{preview}", width = 0.4, border = "none" },
            },
          },
        },
        dropdown_no_preview = {
          layout = {
            backdrop = false,
            row = 1,
            width = 0.4,
            min_width = 80,
            height = 0.4,
            border = "none",
            box = "vertical",
            {
              box = "vertical",
              border = "rounded",
              title = "{title} {live} {flags}",
              title_pos = "center",
              { win = "input", height = 1, border = "none" },
              { win = "list", border = "none" },
            },
          },
        },
        dropdown = {
          layout = {
            backdrop = false,
            row = 1,
            width = 0.4,
            min_width = 80,
            height = 0.6,
            border = "none",
            box = "vertical",
            { win = "preview", title = "{preview}", height = 0.4, border = "none" },
            {
              box = "vertical",
              border = "rounded",
              title = "{title} {live} {flags}",
              title_pos = "center",
              { win = "input", height = 1, border = "none" },
              { win = "list", border = "none" },
            },
          },
        },
      },
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
            ["<c-d>"] = { "preview_scroll_down", mode = { "n", "i" } },
            ["<c-u>"] = { "preview_scroll_up", mode = { "n", "i" } },
            ["<c-l>"] = { "toggle_lua", mode = { "n", "i" } },
            ["<c-i>"] = { "toggle_input", mode = { "n", "i" } },
            ["<c-t>"] = { "edit_tab", mode = { "n", "i" } },
            ["<c-y>"] = { "yankit", mode = { "n", "i" } },
            ["<c-r>"] = { "picker_grep", mode = { "n", "i" } },
            ["<Esc>"] = { "close", mode = { "n", "i" } },
            ["<C-c>"] = { "close", mode = { "n", "i" } },
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
    quickfile = { enabled = false },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
  },
  keys = {
    {
      keybinds.getKeybind "snacks-buffer-delete",
      function()
        require("snacks").bufdelete.delete()
      end,
      desc = keybinds.getDesc "snacks-buffer-delete",
    },
    {
      keybinds.getKeybind "snacks-buffer-delete-others",
      function()
        vim.notify "Deleting other buffers"
        require("snacks").bufdelete.other()
      end,
      desc = keybinds.getDesc "snacks-buffer-delete-others",
    },
    {
      keybinds.getKeybind "snacks-files-picker",
      function()
        require("snacks").picker.files { layout = "dropdown" }
      end,
      desc = keybinds.getDesc "snacks-files-picker",
    },

    {
      keybinds.getKeybind "snacks-spelling-picker",
      function()
        require("snacks").picker.spelling()
      end,
      desc = keybinds.getDesc "snacks-spelling-picker",
    },
    {
      keybinds.getKeybind "snacks-buffers-picker",
      function()
        require("snacks").picker.buffers(buffer_opts)
      end,
      desc = keybinds.getDesc "snacks-buffers-picker",
    },
    {
      keybinds.getKeybind "snacks-buffer-lines",
      function()
        require("snacks").picker.lines { layout = "ivy" }
      end,
      desc = keybinds.getDesc "snacks-buffer-lines",
    },
    {
      keybinds.getKeybind "snacks-project-grep",
      function()
        require("snacks").picker.grep { layout = "ivy" }
      end,
      desc = keybinds.getDesc "snacks-project-grep",
    },
    {
      keybinds.getKeybind "snacks-git-files",
      function()
        require("snacks").picker.git_files()
      end,
      desc = keybinds.getDesc "snacks-git-files",
    },
    {
      keybinds.getKeybind "snacks-recent-files",
      function()
        require("snacks").picker.recent()
      end,
      desc = keybinds.getDesc "snacks-recent-files",
    },
    {
      keybinds.getKeybind "snacks-save-all",
      ":wa<CR>",
      desc = keybinds.getDesc "snacks-save-all",
    },
    {
      keybinds.getKeybind "snacks-format-buffer",
      function()
        vim.lsp.buf.format()
      end,
      desc = keybinds.getDesc "snacks-format-buffer",
    },
    {
      keybinds.getKeybind "snacks-close-hidden",
      ":BCloseHidden<CR>",
      desc = keybinds.getDesc "snacks-close-hidden",
    },
    {
      keybinds.getKeybind "snacks-open-terminal",
      ":term<CR>",
      desc = keybinds.getDesc "snacks-open-terminal",
    },
    {
      keybinds.getKeybind "snacks-toggle-minuet",
      ":Minuet virtualtext toggle<CR>",
      desc = keybinds.getDesc "snacks-toggle-minuet",
    },
    {
      keybinds.getKeybind "snacks-debug-searcher",
      function()
        require("snacks").picker.grep { search = "^(?!\\s*--).*\\b(bt|dd)\\(", args = { "-P" }, live = false, ft = "lua" }
      end,
      desc = keybinds.getDesc "snacks-debug-searcher",
    },
    {
      keybinds.getKeybind "snacks-icons-picker",
      function()
        require("snacks").picker.icons()
      end,
      desc = keybinds.getDesc "snacks-icons-picker",
    },

    {
      keybinds.getKeybind "snacks-lsp-symbols",
      function()
        require("snacks").picker.lsp_symbols()
      end,
      desc = keybinds.getDesc "snacks-lsp-symbols",
    },
    {
      keybinds.getKeybind "snacks-lsp-workspace-symbols",
      function()
        require("snacks").picker.lsp_workspace_symbols()
      end,
      desc = keybinds.getDesc "snacks-lsp-workspace-symbols",
    },
    {
      keybinds.getKeybind "snacks-diagnostics-buffer",
      function()
        require("snacks").picker.diagnostics_buffer()
      end,
      desc = keybinds.getDesc "snacks-diagnostics-buffer",
    },
    {
      keybinds.getKeybind "snacks-diagnostics",
      function()
        require("snacks").picker.diagnostics()
      end,
      desc = keybinds.getDesc "snacks-diagnostics",
    },
    {
      keybinds.getKeybind "snacks-buffer-lines-picker",
      function()
        require("snacks").picker.lines()
      end,
      desc = keybinds.getDesc "snacks-buffer-lines-picker",
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
