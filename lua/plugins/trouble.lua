local keybinds = require "config.keybind_definitions"

return {
  "folke/trouble.nvim",
  enabled = true,
  opts = {
    throttle = {
      refresh = 1000, -- fetches new data when needed
      update = 10, -- updates the window
      render = 10, -- renders the window
      follow = 100, -- follows the current item
      preview = { ms = 100, debounce = true }, -- shows the preview for the current item
    },
    modes = {
      -- Enhanced unified diagnostics mode
      diagnostics = {
        filter = {
          any = {
            { severity = vim.diagnostic.severity.ERROR },
            { severity = vim.diagnostic.severity.WARN },
          },
        },
        groups = {
          { "filename", format = "{file_icon} {basename} ({count})" },
        },
      },
      -- Current buffer only
      buffer = {
        mode = "diagnostics",
        filter = { buf = 0 },
      },
      -- Unified LSP mode for references, definitions, etc.
      lsp = {
        mode = "lsp",
        focus = true,
        win = { position = "right" },
      },
    },
  },
  config = function(_, opts)
    require("trouble").setup(opts)
    
    -- Store last used Trouble mode for smart toggle
    local last_trouble_mode = "diagnostics"
    
    -- Smart toggle function that remembers last mode
    local function smart_trouble_toggle(mode)
      if vim.fn.exists(":Trouble") == 2 then
        if require("trouble").is_open() then
          require("trouble").close()
        else
          require("trouble").open(mode)
          last_trouble_mode = mode
        end
      end
    end
    
    -- Context-aware navigation that adapts to current view
    local function smart_trouble_next()
      if require("trouble").is_open() then
        require("trouble").next({ jump = true })
      else
        -- Fallback to diagnostic navigation if no Trouble window
        vim.diagnostic.goto_next()
      end
    end
    
    local function smart_trouble_prev()
      if require("trouble").is_open() then
        require("trouble").prev({ jump = true })
      else
        -- Fallback to diagnostic navigation if no Trouble window
        vim.diagnostic.goto_prev()
      end
    end
    
    -- Custom Snacks picker action to send to Trouble instead of quickfix
    vim.defer_fn(function()
      local snacks = require("snacks")
      if snacks and snacks.picker and snacks.picker.actions then
        snacks.picker.actions.qflist = function(picker)
          local items = picker:selected()
          if #items == 0 then
            items = picker:items()
          end
          
          -- Convert to quickfix format and open in Trouble
          local qf_items = {}
          for _, item in ipairs(items) do
            table.insert(qf_items, {
              filename = item.file,
              lnum = item.line or 1,
              col = item.col or 1,
              text = item.text or item.title or "",
            })
          end
          
          vim.fn.setqflist(qf_items, "r")
          require("trouble").open("qflist")
        end
      end
    end, 100)
    
    -- Expose smart functions to global scope for keybinds
    vim.g.smart_trouble_toggle = smart_trouble_toggle
    vim.g.smart_trouble_next = smart_trouble_next
    vim.g.smart_trouble_prev = smart_trouble_prev
  end,
  keys = {
    {
      keybinds.getKeybind "trouble-diagnostics",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = keybinds.getDesc "trouble-diagnostics",
    },
    {
      keybinds.getKeybind "trouble-buffer",
      "<cmd>Trouble buffer toggle<cr>",
      desc = keybinds.getDesc "trouble-buffer",
    },
    {
      keybinds.getKeybind "trouble-lsp",
      "<cmd>Trouble lsp toggle<cr>",
      desc = keybinds.getDesc "trouble-lsp",
    },
    {
      keybinds.getKeybind "trouble-symbols",
      "<cmd>Trouble symbols toggle focus=false<cr>",
      desc = keybinds.getDesc "trouble-symbols",
    },
    {
      keybinds.getKeybind "trouble-quickfix",
      "<cmd>Trouble quickfix toggle<cr>",
      desc = keybinds.getDesc "trouble-quickfix",
    },
    {
      keybinds.getKeybind "trouble-next",
      function() vim.g.smart_trouble_next() end,
      desc = keybinds.getDesc "trouble-next",
    },
    {
      keybinds.getKeybind "trouble-prev",
      function() vim.g.smart_trouble_prev() end,
      desc = keybinds.getDesc "trouble-prev",
    },
  },
}