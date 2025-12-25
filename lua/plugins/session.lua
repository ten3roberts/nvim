return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {
      dir = vim.fn.stdpath "state" .. "/sessions/",
      need = 1,
      branch = true,
    },
    config = function(_, opts)
      -- Exclude blank windows and terminal from sessions
      vim.o.sessionoptions = "buffers,curdir,folds,help,tabpages,winsize"

      -- Close plugin windows before saving session
      vim.api.nvim_create_autocmd("User", {
        pattern = "PersistenceSavePre",
        callback = function()
          local dominated_filetypes = {
            "aerial",
            "neo-tree",
            "NvimTree",
            "Outline",
            "opencode",
            "trouble",
            "qf",
            "help",
            "dap-repl",
            "dapui_scopes",
            "dapui_breakpoints",
            "dapui_stacks",
            "dapui_watches",
            "dapui_console",
          }
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            local ft = vim.bo[buf].filetype
            local bt = vim.bo[buf].buftype
            if vim.tbl_contains(dominated_filetypes, ft) or bt == "nofile" or bt == "terminal" then
              pcall(vim.api.nvim_win_close, win, true)
            end
          end
        end,
      })

      require("persistence").setup(opts)
    end,
  },
}
