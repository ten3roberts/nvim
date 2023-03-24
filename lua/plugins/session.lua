return {
  -- {
  --   "ahmedkhalf/project.nvim",
  --   config = function()
  --     require("project_nvim").setup {
  --       -- detection_methods = { "pattern", "lsp" },
  --       -- detection_methods = { "pattern" },
  --     }
  --   end,
  -- },
  {
    "rmagatti/auto-session",
    branch = "merge-session-lens",
    config = function()
      vim.o.sessionoptions = "buffers,help,tabpages"
      require("auto-session").setup {
        log_level = "info",
        -- auto_session_suppress_dirs = { "~/" },
        -- auto_session_enable_last_session = true,
        -- cwd_change_handling = {
        --   restore_upcoming_session = true,
        --   pre_cwd_changed_hook = nil, -- lua function hook. This is called after auto_session code runs for the `DirChangedPre` autocmd
        --   post_cwd_changed_hook = nil, -- lua function hook. This is called after auto_session code runs for the `DirChanged` autocmd
        -- },
      }
    end,
  },
}
