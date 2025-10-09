return {
  "GeorgesAlkhouri/nvim-aider",
  cmd = "Aider",
  -- Example key mappings for common actions:
  keys = {
    { "<leader>a/", "<cmd>Aider toggle<cr>", desc = "Toggle Aider" },
    { "<leader>as", "<cmd>Aider send<cr>", desc = "Send to Aider", mode = { "n", "v" } },
    { "<leader>ac", "<cmd>Aider command<cr>", desc = "Aider Commands" },
    { "<leader>ab", "<cmd>Aider buffer<cr>", desc = "Send Buffer" },
    { "<leader>a+", "<cmd>Aider add<cr>", desc = "Add File" },
    { "<leader>a-", "<cmd>Aider drop<cr>", desc = "Drop File" },
    { "<leader>ar", "<cmd>Aider add readonly<cr>", desc = "Add Read-Only" },
    { "<leader>aR", "<cmd>Aider reset<cr>", desc = "Reset Session" },
    -- Example nvim-tree.lua integration if needed
    { "<leader>a+", "<cmd>AiderTreeAddFile<cr>", desc = "Add File from Tree to Aider", ft = "NvimTree" },
    { "<leader>a-", "<cmd>AiderTreeDropFile<cr>", desc = "Drop File from Tree from Aider", ft = "NvimTree" },
  },
  dependencies = {
    "folke/snacks.nvim",
    --- The below dependencies are optional
    "catppuccin/nvim",
    "nvim-tree/nvim-tree.lua",
    --- Neo-tree integration
    {
      "nvim-neo-tree/neo-tree.nvim",
      opts = function(_, opts)
        -- Example mapping configuration (already set by default)
        -- opts.window = {
        --   mappings = {
        --     ["+"] = { "nvim_aider_add", desc = "add to aider" },
        --     ["-"] = { "nvim_aider_drop", desc = "drop from aider" }
        --     ["="] = { "nvim_aider_add_read_only", desc = "add read-only to aider" }
        --   }
        -- }
        require("nvim_aider.neo_tree").setup(opts)

        vim.api.nvim_create_user_command("AiderFloat", function()
          require("nvim-aider").toggle { direction = "float" }
        end, {})

        -- 🪶 Helper: open in tab directly
        vim.api.nvim_create_user_command("AiderTab", function()
          vim.cmd "tabnew | AiderOpen"
        end, {})

        -- Optional: if you want Aider’s history logs to persist
        vim.g.aider_session_dir = vim.fn.expand "~/.local/share/aider/sessions"
      end,
    },
  },
  config = true,
}
-- return {
--   {
--     -- Wrapper plugin for Aider CLI (https://github.com/FeiyouG/nvim-aider)
--     "FeiyouG/nvim-aider",
--     cmd = { "AiderOpen", "AiderClose", "AiderToggle" },
--     keys = {
--       { "<leader>aa", "<cmd>AiderToggle<cr>", desc = "Toggle Aider (Claude Agent)" },
--       { "<leader>at", "<cmd>tabnew | AiderOpen<cr>", desc = "Open Aider in new tab (fullscreen)" },
--       { "<leader>ar", "<cmd>AiderRestart<cr>", desc = "Restart Aider session" },
--     },
--     config = function()
--       require("nvim-aider").setup {
--         -- The command used to launch Aider
--         cmd = "aider --model claude-3-5-sonnet --no-auto-commits",
--         -- You can switch to gpt-4o or gemini-1.5 depending on your setup:
--         -- cmd = "aider --model gpt-4o",
--
--         -- Open automatically when the command runs
--         open_on_start = true,
--
--         -- Keep session history alive
--         persist_session = true,
--
--         -- Optional: start in vertical split instead of horizontal
--         direction = "float", -- "vertical" | "horizontal" | "float"
--
--         -- Set working directory automatically
--         set_cwd = true,
--
--         -- Optional: integrate with Telescope to quickly add files
--         integrations = {
--           telescope = true,
--         },
--       }
--
--       -- 🧠 Helper: run Aider in floating window
--       vim.api.nvim_create_user_command("AiderFloat", function()
--         require("nvim-aider").toggle { direction = "float" }
--       end, {})
--
--       -- 🪶 Helper: open in tab directly
--       vim.api.nvim_create_user_command("AiderTab", function()
--         vim.cmd "tabnew | AiderOpen"
--       end, {})
--
--       -- Optional: if you want Aider’s history logs to persist
--       vim.g.aider_session_dir = vim.fn.expand "~/.local/share/aider/sessions"
--     end,
--   },
-- }
