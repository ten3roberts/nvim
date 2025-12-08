local M = {}

-- stylua: ignore start
local keybinds = {
  -- ============================================================================
  -- SNACKS PICKER
  -- ============================================================================
  ["snacks-files-picker"] = { keybind = "<leader><leader>", desc = "Files picker" },
  ["snacks-buffers-picker"] = { keybind = "<leader>,", desc = "Buffers picker" },
  ["snacks-buffer-lines"] = { keybind = "<leader>?", desc = "Buffer lines (fuzzy search)" },
  ["snacks-buffer-lines-picker"] = { keybind = "<leader>bl", desc = "Buffer lines picker" },
  ["snacks-project-grep"] = { keybind = "<leader>/", desc = "Project grep" },
  ["snacks-git-files"] = { keybind = "<leader>Fg", desc = "Git files picker" },
  ["snacks-recent-files"] = { keybind = "<leader>Fr", desc = "Recent files picker" },
  ["snacks-lsp-symbols"] = { keybind = "<leader>o", desc = "LSP symbols picker" },
  ["snacks-lsp-workspace-symbols"] = { keybind = "<leader>O", desc = "LSP workspace symbols picker" },
  ["snacks-diagnostics-buffer"] = { keybind = "<leader>q", desc = "Diagnostics buffer picker" },
  ["snacks-diagnostics"] = { keybind = "<leader>Q", desc = "Diagnostics picker" },
  ["snacks-spelling-picker"] = { keybind = "z=", desc = "Spelling picker" },
  ["snacks-icons-picker"] = { keybind = "<leader>si", desc = "Icons picker" },
  ["snacks-undo-picker"] = { keybind = "<leader>u", desc = "Undo picker" },
  ["snacks-debug-searcher"] = { keybind = "<leader>dd", desc = "Debug searcher" },
  ["snacks-explorer"] = { keybind = "<leader>ct", desc = "Snacks explorer" },

  -- ============================================================================
  -- BUFFER MANAGEMENT
  -- ============================================================================
  ["snacks-buffer-delete"] = { keybind = "<leader>bd", desc = "Buffer delete" },
  ["snacks-buffer-delete-others"] = { keybind = "<leader>bo", desc = "Buffer delete others" },
  ["buffer-close-hidden"] = { keybind = "<leader>bh", desc = "Close hidden buffers" },
  ["snacks-close-hidden"] = { keybind = "<leader>bc", desc = "Close hidden buffers" },
  ["snacks-format-buffer"] = { keybind = "<leader>bf", desc = "Format buffer (LSP)" },
  ["snacks-save-all"] = { keybind = "<leader>sa", desc = "Save all buffers" },

  -- ============================================================================
  -- GIT & GITSIGNS
  -- ============================================================================
  ["gitsigns-stage-hunk"] = { keybind = "<leader>hs", desc = "Stage hunk" },
  ["gitsigns-reset-hunk"] = { keybind = "<leader>hr", desc = "Reset hunk" },
  ["gitsigns-unstage-hunk"] = { keybind = "<leader>hu", desc = "Unstage hunk" },
  ["gitsigns-preview-hunk"] = { keybind = "<leader>hp", desc = "Preview hunk" },
  ["gitsigns-blame-line"] = { keybind = "<leader>hb", desc = "Blame line" },
  ["gitsigns-diffthis"] = { keybind = "<leader>hd", desc = "Diff this" },
  ["gitsigns-toggle-blame"] = { keybind = "<leader>tb", desc = "Toggle current line blame" },
  ["gitsigns-prev-hunk"] = { keybind = "[c", desc = "Previous hunk" },
  ["gitsigns-next-hunk"] = { keybind = "]c", desc = "Next hunk" },
  ["gitsigns-prev-hunk-alt"] = { keybind = "[h", desc = "Previous hunk (alt)" },
  ["gitsigns-next-hunk-alt"] = { keybind = "]h", desc = "Next hunk (alt)" },
  ["git-status"] = { keybind = "<leader>gs", desc = "Git status" },
  ["git-commit"] = { keybind = "<leader>gc", desc = "Git commit" },
  ["git-push"] = { keybind = "<leader>gp", desc = "Git push" },
  ["git-pull"] = { keybind = "<leader>gl", desc = "Git pull" },
  ["git-diff-staged"] = { keybind = "<leader>gd", desc = "Show staged diff" },

  -- ============================================================================
  -- LSP & DIAGNOSTICS
  -- ============================================================================
  ["diagnostic-next"] = { keybind = "<leader>j", desc = "Next diagnostic" },
  ["diagnostic-prev"] = { keybind = "<leader>k", desc = "Previous diagnostic" },
  ["diagnostic-next-error"] = { keybind = "]d", desc = "Next error" },
  ["diagnostic-prev-error"] = { keybind = "[d", desc = "Previous error" },
  ["lsp-toggle-inlay-hints"] = { keybind = "<leader>li", desc = "Toggle inlay hints" },
  ["lsp-toggle-diagnostics"] = { keybind = "<leader>ld", desc = "Toggle diagnostic virtual text" },
  ["lsp-call-hierarchy"] = { keybind = "<leader>ch", desc = "Call hierarchy" },
  ["lsp-hover-actions"] = { keybind = "<leader>ha", desc = "Hover with actions" },
  ["lsp-next-error"] = { keybind = "<leader>le", desc = "Next error" },

  -- ============================================================================
  -- DEBUGGING (DAP)
  -- ============================================================================
  ["dap-ui-toggle"] = { keybind = "<leader>dO", desc = "Toggle DAP UI" },
  ["dap-eval-input"] = { keybind = "<leader>dE", desc = "Evaluate input" },
  ["dap-float-element"] = { keybind = "<leader>d.", desc = "Open floating element" },
  ["dap-hover"] = { keybind = "<leader>dw", desc = "Hover" },
  ["dap-variables"] = { keybind = "<leader>dlv", desc = "Variables" },
  ["dap-breakpoints"] = { keybind = "<leader>dlb", desc = "Breakpoints" },
  ["dap-frames"] = { keybind = "<leader>dlf", desc = "Frames" },
  ["dap-commands"] = { keybind = "<leader>dlc", desc = "Commands" },

  -- ============================================================================
  -- RUST-SPECIFIC
  -- ============================================================================
  ["rust-run-tests"] = { keybind = "<leader>rt", desc = "Run tests" },
  ["rust-expand-macro"] = { keybind = "<leader>me", desc = "Expand macro" },
  ["crates-popup"] = { keybind = "K", desc = "Show crate popup" },
  ["crates-versions"] = { keybind = "<leader>cv", desc = "Show versions popup" },
  ["crates-features"] = { keybind = "<leader>cf", desc = "Show features popup" },
  ["crates-dependencies"] = { keybind = "<leader>cd", desc = "Show dependencies popup" },
  ["crates-upgrade"] = { keybind = "<leader>cu", desc = "Upgrade crate" },
  ["crates-upgrade-all"] = { keybind = "<leader>cU", desc = "Upgrade all crates" },

  -- ============================================================================
  -- WINDOW MANAGEMENT
  -- ============================================================================
  ["window-close-others"] = { keybind = "<C-w>o", desc = "Close other windows, preserving special ones" },

  -- ============================================================================
  -- TAB MANAGEMENT
  -- ============================================================================
  ["tab-only"] = { keybind = "<leader>to", desc = "Close other tabs" },
  ["tab-split"] = { keybind = "<leader>tt", desc = "Split tab" },
  ["tab-close"] = { keybind = "<leader>tq", desc = "Close tab" },
  ["tab-prev"] = { keybind = "<A-,>", desc = "Previous tab" },
  ["tab-next"] = { keybind = "<A-.>", desc = "Next tab" },
  ["tab-move-prev"] = { keybind = "<A-<>", desc = "Move tab left" },
  ["tab-move-next"] = { keybind = "<A->>", desc = "Move tab right" },

  -- ============================================================================
  -- NAVIGATION (Bracket motions - vim-unimpaired style)
  -- ============================================================================
  ["bracket-prev-buffer"] = { keybind = "[b", desc = "Previous buffer" },
  ["bracket-next-buffer"] = { keybind = "]b", desc = "Next buffer" },
  ["bracket-prev-tab"] = { keybind = "[t", desc = "Previous tab" },
  ["bracket-next-tab"] = { keybind = "]t", desc = "Next tab" },
  ["bracket-prev-quickfix"] = { keybind = "[q", desc = "Previous quickfix" },
  ["bracket-next-quickfix"] = { keybind = "]q", desc = "Next quickfix" },
  ["bracket-prev-loclist"] = { keybind = "[l", desc = "Previous location list" },
  ["bracket-next-loclist"] = { keybind = "]l", desc = "Next location list" },
  ["bracket-prev-diagnostic"] = { keybind = "[d", desc = "Previous diagnostic" },
  ["bracket-next-diagnostic"] = { keybind = "]d", desc = "Next diagnostic" },
  ["bracket-prev-error"] = { keybind = "[e", desc = "Previous error" },
  ["bracket-next-error"] = { keybind = "]e", desc = "Next error" },

  -- ============================================================================
  -- TEXT EDITING - DIAL (Increment/Decrement)
  -- ============================================================================
  ["dial-inc-normal"] = { keybind = "<C-a>", desc = "Dial increment" },
  ["dial-dec-normal"] = { keybind = "<C-x>", desc = "Dial decrement" },
  ["dial-inc-gnormal"] = { keybind = "g<C-a>", desc = "Dial g-increment" },
  ["dial-dec-gnormal"] = { keybind = "g<C-x>", desc = "Dial g-decrement" },
  ["dial-inc-visual"] = { keybind = "<C-a>", desc = "Dial visual increment" },
  ["dial-dec-visual"] = { keybind = "<C-x>", desc = "Dial visual decrement" },
  ["dial-inc-gvisual"] = { keybind = "g<C-a>", desc = "Dial g-visual increment" },
  ["dial-dec-gvisual"] = { keybind = "g<C-x>", desc = "Dial g-visual decrement" },

  -- ============================================================================
  -- TEXT EDITING - SPIDER (Enhanced motions)
  -- ============================================================================
  ["spider-w"] = { keybind = "w", desc = "Spider-w (motion)" },
  ["spider-e"] = { keybind = "e", desc = "Spider-e (motion)" },
  ["spider-b"] = { keybind = "b", desc = "Spider-b (motion)" },
  ["spider-ge"] = { keybind = "ge", desc = "Spider-ge (motion)" },

  -- ============================================================================
  -- TEXT EDITING - MINI OPERATORS
  -- ============================================================================
  ["mini-eval-math"] = { keybind = "g=", desc = "Evaluate math expressions" },
  ["mini-exchange-text"] = { keybind = "gx", desc = "Exchange text regions" },
  ["mini-multiply-text"] = { keybind = "gm", desc = "Multiply (duplicate) text" },
  ["mini-replace-register"] = { keybind = "gr", desc = "Replace with register" },
  ["mini-sort-text"] = { keybind = "gs", desc = "Sort text" },
  ["mini-splitjoin-toggle"] = { keybind = "gS", desc = "Toggle split/join" },

  -- ============================================================================
  -- SEARCH & REPLACE
  -- ============================================================================
  ["spectre-toggle"] = { keybind = "<leader>S", desc = "Toggle Spectre" },
  ["spectre-word-search"] = { keybind = "<leader>sw", desc = "Spectre word search" },
  ["spectre-visual-search"] = { keybind = "<leader>sw", desc = "Spectre visual search" },
  ["spectre-file-search"] = { keybind = "<leader>sp", desc = "Spectre file search" },
  ["ssr-open"] = { keybind = "<leader>cR", desc = "Structural replace (SSR)" },
  ["nohl"] = { keybind = "<Esc>", desc = "Clear search highlight" },

  -- ============================================================================
  -- TROUBLE (Diagnostics UI)
  -- ============================================================================
  ["trouble-master-toggle"] = { keybind = "<leader>x", desc = "Toggle Trouble (smart context)" },
  ["trouble-next"] = { keybind = "]]", desc = "Next item (Trouble)" },
  ["trouble-prev"] = { keybind = "[[", desc = "Previous item (Trouble)" },

  -- ============================================================================
  -- FOLDING
  -- ============================================================================
  ["fold-open-all"] = { keybind = "zR", desc = "Open all folds" },
  ["fold-close-all"] = { keybind = "zM", desc = "Close all folds" },

  -- ============================================================================
  -- TERMINAL
  -- ============================================================================
  ["terminal-exit"] = { keybind = "<esc>", desc = "Exit terminal mode" },
  ["snacks-open-terminal"] = { keybind = "<leader>tt", desc = "Open terminal" },

  -- ============================================================================
  -- CLIPBOARD
  -- ============================================================================
  ["clipboard-yank"] = { keybind = "<leader>y", desc = "Yank to system clipboard" },
  ["clipboard-paste"] = { keybind = "<leader>p", desc = "Paste from system clipboard" },
  ["clipboard-paste-before"] = { keybind = "<leader>P", desc = "Paste before from system clipboard" },

  -- ============================================================================
  -- MISC
  -- ============================================================================
  ["context-go-to"] = { keybind = "[c", desc = "Go to context" },
  ["graphene-init"] = { keybind = "<leader>f", desc = "Init graphene" },
  ["indent-buffer"] = { keybind = "<leader>ci", desc = "Indent whole buffer" },
  ["dev-save-exec"] = { keybind = "<leader>XX", desc = "Save and exec" },
}
-- stylua: ignore end

function M.getKeybind(name)
  local kb = keybinds[name]
  if not kb then
    vim.notify("Keybind not found: " .. name, vim.log.levels.ERROR)
    return "<leader>?" -- sane default
  end
  return kb.keybind
end

function M.getDesc(name)
  local kb = keybinds[name]
  return kb and kb.desc or ""
end

return M
