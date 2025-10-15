local M = {}

local keybinds = {
  -- General
  -- Close other windows, preserving special ones
  ["window-close-others"] = { keybind = "<C-w>o", desc = "Close other windows, preserving special ones" },
  -- Exit terminal mode
  ["terminal-exit"] = { keybind = "<esc>", desc = "Exit terminal mode" },

  -- Treesitter
  -- Go to context
  ["context-go-to"] = { keybind = "[c", desc = "Go to context" },

  -- UFO
  -- Open all folds
  ["fold-open-all"] = { keybind = "zR", desc = "Open all folds" },
  -- Close all folds
  ["fold-close-all"] = { keybind = "zM", desc = "Close all folds" },

  -- Spectre
  -- Toggle Spectre
  ["spectre-toggle"] = { keybind = "<leader>S", desc = "Toggle Spectre" },
  -- Spectre word search
  ["spectre-word-search"] = { keybind = "<leader>sw", desc = "Spectre word search" },
  -- Spectre visual search
  ["spectre-visual-search"] = { keybind = "<leader>sw", desc = "Spectre visual search" },
  -- Spectre file search
  ["spectre-file-search"] = { keybind = "<leader>sp", desc = "Spectre file search" },

  -- CodeCompanion
  -- CodeCompanion actions
  ["codecompanion-actions"] = { keybind = "<C-c>", desc = "CodeCompanion actions" },
  -- Toggle CodeCompanion chat
  ["codecompanion-chat-toggle"] = { keybind = "<LocalLeader>a", desc = "Toggle CodeCompanion chat" },
  -- Open CodeCompanion chat
  ["codecompanion-chat-open"] = { keybind = "<leader>cc", desc = "Open CodeCompanion chat" },
  -- Add to CodeCompanion chat
  ["codecompanion-chat-add"] = { keybind = "ga", desc = "Add to CodeCompanion chat" },

  -- Comment
  -- Comment refactor
  ["comment-refactor"] = { keybind = "<leader>cR", desc = "Comment refactor" },

  -- Dial
  -- Dial increment
  ["dial-inc-normal"] = { keybind = "<C-a>", desc = "Dial increment" },
  -- Dial decrement
  ["dial-dec-normal"] = { keybind = "<C-x>", desc = "Dial decrement" },
  -- Dial g-increment
  ["dial-inc-gnormal"] = { keybind = "g<C-a>", desc = "Dial g-increment" },
  -- Dial g-decrement
  ["dial-dec-gnormal"] = { keybind = "g<C-x>", desc = "Dial g-decrement" },
  -- Dial visual increment
  ["dial-inc-visual"] = { keybind = "<C-a>", desc = "Dial visual increment" },
  -- Dial visual decrement
  ["dial-dec-visual"] = { keybind = "<C-x>", desc = "Dial visual decrement" },
  -- Dial g-visual increment
  ["dial-inc-gvisual"] = { keybind = "g<C-a>", desc = "Dial g-visual increment" },
  -- Dial g-visual decrement
  ["dial-dec-gvisual"] = { keybind = "g<C-x>", desc = "Dial g-visual decrement" },

  -- LuaSnip
  -- LuaSnip expand/choice prev
  ["luasnip-prev-choice"] = { keybind = "<c-k>", desc = "LuaSnip expand/choice prev" },
  -- LuaSnip jump next
  ["luasnip-next"] = { keybind = "<c-j>", desc = "LuaSnip jump next" },
  -- LuaSnip choice next
  ["luasnip-choice-next"] = { keybind = "<c-l>", desc = "LuaSnip choice next" },

  -- Spider
  -- Spider-w (motion)
  ["spider-w"] = { keybind = "w", desc = "Spider-w (motion)" },
  -- Spider-e (motion)
  ["spider-e"] = { keybind = "e", desc = "Spider-e (motion)" },
  -- Spider-b (motion)
  ["spider-b"] = { keybind = "b", desc = "Spider-b (motion)" },
  -- Spider-ge (motion)
  ["spider-ge"] = { keybind = "ge", desc = "Spider-ge (motion)" },

  -- DAP
  -- Toggle DAP UI
  ["dap-ui-toggle"] = { keybind = "<leader>dO", desc = "Toggle DAP UI" },
  -- Evaluate input
  ["dap-eval-input"] = { keybind = "<leader>dE", desc = "Evaluate input" },
  -- Open floating element
  ["dap-float-element"] = { keybind = "<leader>d.", desc = "Open floating element" },
  -- Hover
  ["dap-hover"] = { keybind = "<leader>dw", desc = "Hover" },
  -- Variables
  ["dap-variables"] = { keybind = "<leader>dlv", desc = "Variables" },
  -- Breakpoints
  ["dap-breakpoints"] = { keybind = "<leader>dlb", desc = "Breakpoints" },
  -- Frames
  ["dap-frames"] = { keybind = "<leader>dlf", desc = "Frames" },
  -- Commands
  ["dap-commands"] = { keybind = "<leader>dlc", desc = "Commands" },

  -- Snacks
  -- Buffer delete
  ["snacks-buffer-delete"] = { keybind = "<leader>bd", desc = "Buffer delete" },
  -- Buffer delete others
  ["snacks-buffer-delete-others"] = { keybind = "<leader>bo", desc = "Buffer delete others" },
  -- Files picker
  ["snacks-files-picker"] = { keybind = "<leader><leader>", desc = "Files picker" },
  -- Spelling picker
  ["snacks-spelling-picker"] = { keybind = "z=", desc = "Spelling picker" },
  -- Buffers picker
  ["snacks-buffers-picker"] = { keybind = "<leader>,", desc = "Buffers picker" },
  -- Buffer lines (fuzzy search)
  ["snacks-buffer-lines"] = { keybind = "<leader>/", desc = "Buffer lines (fuzzy search)" },
  -- Project grep
  ["snacks-project-grep"] = { keybind = "<leader>?", desc = "Project grep" },
  -- Git files picker
  ["snacks-git-files"] = { keybind = "<leader>fg", desc = "Git files picker" },
  -- Recent files picker
  ["snacks-recent-files"] = { keybind = "<leader>fr", desc = "Recent files picker" },
  -- Save all buffers
  ["snacks-save-all"] = { keybind = "<leader>sa", desc = "Save all buffers" },
  -- Format buffer (LSP)
  ["snacks-format-buffer"] = { keybind = "<leader>fa", desc = "Format buffer (LSP)" },
  -- Close hidden buffers
  ["snacks-close-hidden"] = { keybind = "<leader>bc", desc = "Close hidden buffers" },
  -- Open terminal
  ["snacks-open-terminal"] = { keybind = "<leader>tt", desc = "Open terminal" },
  -- Toggle Minuet virtual text
  ["snacks-toggle-minuet"] = { keybind = "<leader>mt", desc = "Toggle Minuet virtual text" },
  -- Debug searcher
  ["snacks-debug-searcher"] = { keybind = "<leader>dd", desc = "Debug searcher" },
  -- Icons picker
  ["snacks-icons-picker"] = { keybind = "<leader>si", desc = "Icons picker" },
  -- Undo picker
  ["snacks-undo-picker"] = { keybind = "<leader>u", desc = "Undo picker" },
  -- LSP symbols picker
  ["snacks-lsp-symbols"] = { keybind = "<leader>o", desc = "LSP symbols picker" },
  -- LSP workspace symbols picker
  ["snacks-lsp-workspace-symbols"] = { keybind = "<leader>O", desc = "LSP workspace symbols picker" },
  -- Diagnostics buffer picker
  ["snacks-diagnostics-buffer"] = { keybind = "<leader>q", desc = "Diagnostics buffer picker" },
  -- Diagnostics picker
  ["snacks-diagnostics"] = { keybind = "<leader>Q", desc = "Diagnostics picker" },
  -- Buffer lines picker
  ["snacks-buffer-lines-picker"] = { keybind = "<leader>fl", desc = "Buffer lines picker" },
  -- Refine picker results (grep within)
  ["snacks-refine-picker-results"] = { keybind = "<c-r>", desc = "Refine picker results (grep within)" },

  -- Mini-diff
  -- Apply hunk
  ["mini-diff-apply"] = { keybind = "gh", desc = "Apply hunk" },
  -- Reset hunk
  ["mini-diff-reset"] = { keybind = "gH", desc = "Reset hunk" },
  -- Hunk textobject
  ["mini-diff-textobject"] = { keybind = "gh", desc = "Hunk textobject" },
  -- First hunk
  ["mini-diff-first"] = { keybind = "[H", desc = "First hunk" },
  -- Previous hunk
  ["mini-diff-prev"] = { keybind = "[h", desc = "Previous hunk" },
  -- Next hunk
  ["mini-diff-next"] = { keybind = "]h", desc = "Next hunk" },
  -- Last hunk
  ["mini-diff-last"] = { keybind = "]H", desc = "Last hunk" },

  -- Mini-operators
  -- Evaluate math expressions
  ["mini-eval-math"] = { keybind = "g=", desc = "Evaluate math expressions" },
  -- Exchange text regions
  ["mini-exchange-text"] = { keybind = "gx", desc = "Exchange text regions" },
  -- Multiply (duplicate) text
  ["mini-multiply-text"] = { keybind = "gm", desc = "Multiply (duplicate) text" },
  -- Replace with register
  ["mini-replace-register"] = { keybind = "gr", desc = "Replace with register" },
  -- Sort text
  ["mini-sort-text"] = { keybind = "gs", desc = "Sort text" },

  -- Mini-splitjoin
  -- Toggle split/join
  ["mini-splitjoin-toggle"] = { keybind = "gS", desc = "Toggle split/join" },

  -- Crates (TOML)
  -- Show crate popup
  ["crates-popup"] = { keybind = "K", desc = "Show crate popup" },
  -- Show versions popup
  ["crates-versions"] = { keybind = "<leader>cv", desc = "Show versions popup" },
  -- Show features popup
  ["crates-features"] = { keybind = "<leader>cf", desc = "Show features popup" },
  -- Show dependencies popup
  ["crates-dependencies"] = { keybind = "<leader>cd", desc = "Show dependencies popup" },
  -- Upgrade crate
  ["crates-upgrade"] = { keybind = "<leader>cu", desc = "Upgrade crate" },
  -- Upgrade all crates
  ["crates-upgrade-all"] = { keybind = "<leader>cU", desc = "Upgrade all crates" },

  -- Diagnostics
  -- Next diagnostic
  ["diagnostic-next"] = { keybind = "<leader>j", desc = "Next diagnostic" },
  -- Previous diagnostic
  ["diagnostic-prev"] = { keybind = "<leader>k", desc = "Previous diagnostic" },
  -- Next error
  ["diagnostic-next-error"] = { keybind = "<leader>l", desc = "Next error" },
  -- Previous error
  ["diagnostic-prev-error"] = { keybind = "<leader>h", desc = "Previous error" },

  -- Windows/Tabs
  -- Close other tabs
  ["tab-only"] = { keybind = "<leader>to", desc = "Close other tabs" },
  -- Split tab
  ["tab-split"] = { keybind = "<leader>tt", desc = "Split tab" },
  -- Close tab
  ["tab-close"] = { keybind = "<leader>tq", desc = "Close tab" },
  -- Previous tab
  ["tab-prev"] = { keybind = "<A-,>", desc = "Previous tab" },
  -- Next tab
  ["tab-next"] = { keybind = "<A-.>", desc = "Next tab" },
  -- Move tab left
  ["tab-move-prev"] = { keybind = "<A-<>", desc = "Move tab left" },
  -- Move tab right
  ["tab-move-next"] = { keybind = "<A->>", desc = "Move tab right" },

  -- Misc
  -- Init graphene
  ["graphene-init"] = { keybind = "<leader>f", desc = "Init graphene" },
  -- Clear search highlight
  ["nohl"] = { keybind = "<Esc>", desc = "Clear search highlight" },
  -- Indent whole buffer
  ["indent-buffer"] = { keybind = "<leader>ci", desc = "Indent whole buffer" },
  -- Save and exec
  ["dev-save-exec"] = { keybind = "<leader>XX", desc = "Save and exec" },
}

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

-- Check for duplicate keybinds on startup
local keybind_to_names = {}
for name, info in pairs(keybinds) do
  local kb = info.keybind
  if not keybind_to_names[kb] then
    keybind_to_names[kb] = {}
  end
  table.insert(keybind_to_names[kb], name)
end

for kb, names in pairs(keybind_to_names) do
  if #names > 1 then
    vim.notify("Duplicate keybind '" .. kb .. "' used by: " .. table.concat(names, ", "), vim.log.levels.WARN)
  end
end

return M