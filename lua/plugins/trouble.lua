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

    -- Helper to detect if Trouble window is open
    local function is_trouble_open()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype == "trouble" then
          return true
        end
      end
      return false
    end

    -- Smart context-aware toggle function
    local function smart_trouble_toggle()
      -- If Trouble is already open, close it
      if is_trouble_open() then
        require("trouble").close()
        return
      end

      -- Context detection to choose the most relevant mode
      local qf_count = #vim.fn.getqflist()
      local diagnostics_count = #vim.diagnostic.get(0)

      -- Priority order:
      if qf_count > 0 then
        require("trouble").open("qflist")
        vim.g.last_trouble_mode = "qflist"
      elseif vim.g.last_lsp_mode then
        -- Set by LSP operations when they have multiple results
        require("trouble").open("lsp")
        vim.g.last_trouble_mode = "lsp"
        vim.g.last_lsp_mode = nil -- Clear after use
      elseif diagnostics_count > 0 then
        require("trouble").open("diagnostics")
        vim.g.last_trouble_mode = "diagnostics"
      else
        -- Open last mode or default to diagnostics
        local mode = vim.g.last_trouble_mode or "diagnostics"
        require("trouble").open(mode)
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

    -- Add buffer-local keymaps for easy dismissal when Trouble opens
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "trouble",
      callback = function(event)
        vim.keymap.set("n", "q", function()
          require("trouble").close()
        end, { buffer = event.buf, desc = "Close Trouble", silent = true })

        vim.keymap.set("n", "<Esc>", function()
          require("trouble").close()
        end, { buffer = event.buf, desc = "Close Trouble", silent = true })
      end,
    })

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
      keybinds.getKeybind "trouble-master-toggle",
      function() vim.g.smart_trouble_toggle() end,
      desc = keybinds.getDesc "trouble-master-toggle",
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