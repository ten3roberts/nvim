return {
  {
    "rmagatti/auto-session",
    -- branch = "merge-session-lens",
    config = function()
      -- vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
      vim.o.sessionoptions = "buffers,curdir,help,tabpages"
      require("auto-session").setup {
        auto_save_enabled = true,
        auto_restore_enabled = true,
        auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
      }
    end,
  },
}
