return {
  "saghen/blink.cmp",
  -- optional: provides snippets for the snippet source
  dependencies = { "rafamadriz/friendly-snippets" },

  -- use a release tag to download pre-built binaries
  version = "1.*",
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
    -- 'super-tab' for mappings similar to vscode (tab to accept)
    -- 'enter' for enter to accept
    -- 'none' for no mappings
    --
    -- All presets have the following mappings:
    -- C-space: Open menu or open docs if already open
    -- C-n/C-p or Up/Down: Select next/previous item
    -- C-e: Hide menu
    -- C-k: Toggle signature help (if signature.enabled = true)
    --
    -- See :h blink-cmp-config-keymap for defining your own keymap
    keymap = {
      preset = "default",
      ["<C-k>"] = { "snippet_forward" },
      ["<C-j>"] = { "snippet_backward" },
      ["<C-e>"] = {
        function()
          require("minuet.virtualtext").action.accept()
        end,
      },
      ["<Tab>"] = {
        function(cmp)
          if cmp.snippet_active() then
            return cmp.accept()
          else
            local item = cmp.get_selected_item()
            if item and item.kind == "Snippet" then
              vim.api.nvim_feedkeys("\\<C-g>u", "n", false)
            end
            return cmp.select_and_accept()
          end
        end,
        "fallback",
      },

      -- Additional navigation and control
      ["<C-y>"] = { "accept" },
      ["<C-n>"] = { "select_next" },
      ["<C-p>"] = { "select_prev" },
      ["<C-b>"] = { "scroll_documentation_up" },
      ["<C-f>"] = { "scroll_documentation_down" },
      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
    },

    appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = "mono",

      -- Enhanced kind icons
      kind_icons = {
        Text = "󰉿",
        Method = "󰆧",
        Function = "󰊕",
        Constructor = "󰒓",
        Field = "󰜢",
        Variable = "󰀫",
        Class = "󰠱",
        Interface = "󰜰",
        Module = "󰏗",
        Property = "󰜢",
        Unit = "󰑭",
        Value = "󰎠",
        Enum = "󰕘",
        Keyword = "󰌋",
        Snippet = "󰩫",
        Color = "󰏘",
        File = "󰈙",
        Reference = "󰈇",
        Folder = "󰉋",
        EnumMember = "󰕘",
        Constant = "󰏿",
        Struct = "󰙅",
        Event = "󰗽",
        Operator = "󰆕",
        TypeParameter = "󰊄",
      },
    },

    completion = {
      menu = {
        -- Auto-show menu so you can see all options alongside ghost text
        auto_show = true,

        -- Menu appearance - sleek, no border
        border = "none",
        scrollbar = false,
      },

      -- (Default) Only show the documentation popup when manually triggered
      documentation = { auto_show = false },

      -- Replace similar text ahead of cursor on completion
      keyword = { range = "full" },

      -- Auto-insert brackets
      accept = { auto_brackets = { enabled = true } },

      -- List behavior
      list = {
        selection = {
          preselect = true,
          auto_insert = false,
        },
      },

      -- Trigger completion settings
      trigger = {
        show_on_keyword = true,
        show_on_trigger_character = true,
      },

      -- Ghost text shows the top result inline
      ghost_text = {
        enabled = true,
      },
    },

    signature = { enabled = true },
    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = { "snippets", "lsp", "path", "buffer" },
      per_filetype = {
        codecompanion = { "codecompanion" },
      },

      -- Source-specific tuning
      providers = {
        snippets = {
          score_offset = 10, -- Prefer snippets above all other sources
        },
        lsp = {
          timeout_ms = 500,
        },
        buffer = {
          min_keyword_length = 3,
        },
      },
    },

    -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
    -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
    -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
    --
    -- See the fuzzy documentation for more information
    fuzzy = {
      frecency = { enabled = true },
      proximity = { enabled = true },
    },
  },
  opts_extend = { "sources.default" },
}
