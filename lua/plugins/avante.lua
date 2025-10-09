-- lua/plugins/avante.lua
return {
  enable = false,
  "yetone/avante.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "stevearc/dressing.nvim",
    -- copilot helpers (optional, uncomment if you use them)
    "zbirenbaum/copilot.lua",
    "nvim-tree/nvim-web-devicons",
    { "HakonHarnes/img-clip.nvim", event = "VeryLazy" },
  },
  opts = {
    -- === provider ===
    provider = "copilot", -- default provider for all interactions (set globally)
    providers = {
      copilot = {
        -- name used in Avante; set depending on your copilot plugin:
        -- common values: "copilot.vim" or "copilot.lua" (match your copilot plugin)
        suggestion_provider = "copilot.lua",
        -- custom fields (if needed) can be added here
      },
      --[[ Uncomment if you want Anthropic later (example)
      anthropic = {
        endpoint = "https://api.anthropic.com",
        api_key_name = "ANTHROPIC_API_KEY",
        model = "claude-2.1",
        timeout = 30000,
      },
      --]]
    },

    -- === behaviour: automatic / inline transforms ===
    behaviour = {
      auto_set_keymaps = true, -- let Avante register its helpful keymaps
      auto_set_highlight_group = true,
      auto_suggestions = true, -- inline suggestions (experimental / expensive)
      auto_apply_diff_after_generation = true, -- *automatically apply* generated diffs
      auto_approve_tool_permissions = true, -- let agent tools run without interactive prompt
      enable_fastapply = false, -- Morph fastapply (super fast) -> SEE NOTE below
      minimize_diff = true,
      support_paste_from_clipboard = true,
      enable_token_counting = true,
    },

    -- UI / windows
    windows = {
      position = "right",
      hints = { enabled = true }, -- in-buffer virtual hint when selecting (the virtual text you saw)
      wrap = true,
      width = 34,
      height = 32,

      spinner = {
        editing = {
          "⠋",
          "⠙",
          "⠚",
          "⠒",
          "⠂",
          "⠂",
          "⠒",
          "⠲",
          "⠴",
          "⠦",
          "⠖",
          "⠒",
          "⠐",
          "⠐",
          "⠒",
          "⠓",
          "⠋",
        },
        generating = { "∙∙∙", "●∙∙", "∙●∙", "∙∙●", "∙∙∙" },

        thinking = { "󰌶", "󰗣", "󰟶" },
      },
    },

    -- input / editor windows
    input = { prefix = "> ", height = 20 },
    edit = { start_insert = true, border = "shadow" },
    ask = { floating = false, start_insert = true },

    -- simple mappings (keeps Avante UX Particularly)
    mappings = {
      ask = "<leader>aa",
      new_ask = "<leader>an",
      edit = "<leader>ae", -- visual mode: run edit on selection
      refresh = "<leader>ar",
      suggestion = { accept = "<M-l>", next = "<M-]>", prev = "<M-[>" },
      sidebar = { apply_cursor = "a", apply_all = "A", next_prompt = "]p", prev_prompt = "[p" },
    },

    -- project / prompt rules
    rules = {
      project_dir = ".avante/rules",
      global_dir = vim.fn.expand "~/.config/avante/rules",
    },

    prompt_logger = { enabled = true },
  },

  config = function(_, opts)
    -- apply
    require("avante").setup(opts)

    -- convenience keymaps that use the *public* API properly:
    -- open interactive ask (chat) — this is the normal flow
    vim.keymap.set({ "n", "v" }, "<leader>aa", function()
      require("avante.api").ask()
    end, { desc = "Avante: Ask" })

    -- visual-edit: select code in visual mode, then press <leader>ae to Edit (opens Avante edit UI)
    vim.keymap.set("v", "<leader>ae", function()
      require("avante.api").edit()
    end, { desc = "Avante: Edit selection" })

    -- small helper: one-shot ask from lua (calls the CLI command that accepts a question)
    vim.api.nvim_create_user_command("AvanteAskNow", function(ctx)
      local q = ctx.args or ""
      if q == "" then
        require("avante.api").ask()
      else
        -- :AvanteAsk accepts a question and optional position; use vim.cmd to pass it
        vim.cmd("AvanteAsk " .. vim.fn.shellescape(q))
      end
    end, { nargs = "?" })
  end,
}
