function notify_lsp_progress()
  ---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
  local progress = vim.defaulttable()
  vim.api.nvim_create_autocmd("LspProgress", {
    ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
      if not client or type(value) ~= "table" then
        return
      end
      local p = progress[client.id]

      for i = 1, #p + 1 do
        if i == #p + 1 or p[i].token == ev.data.params.token then
          p[i] = {
            token = ev.data.params.token,
            msg = ("[%3d%%] %s%s"):format(
              value.kind == "end" and 100 or value.percentage or 100,
              value.title or "",
              value.message and (" **%s**"):format(value.message) or ""
            ),
            done = value.kind == "end",
          }
          break
        end
      end

      local msg = {} ---@type string[]
      progress[client.id] = vim.tbl_filter(function(v)
        return table.insert(msg, v.msg) or not v.done
      end, p)

      local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
      vim.notify(table.concat(msg, "\n"), "info", {
        id = "lsp_progress",
        title = client.name,
        opts = function(notif)
          notif.icon = #progress[client.id] == 0 and " "
            or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
        end,
      })
    end,
  })
end

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
    indent = { enabled = true, indent = { only_scope = true, only_current = true } },
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
            -- ["<c-t>"] = { "edit_tab", mode = { "n", "i" } },
            -- ["<c-t>"] = { "yankit", mode = { "n", "i" } },
            -- ["<Esc>"] = { "close", mode = { "n", "i" } },
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
        require("snacks").picker.files()
      end,
    },
    {
      "<leader>,",
      function()
        require("snacks").picker.buffers()
      end,
    },
    {
      "<leader>/",
      function()
        require("snacks").picker.grep()
      end,
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

    notify_lsp_progress()
  end,
}
