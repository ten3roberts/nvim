local M = {}

-- stylua ignore start
local keybinds = {
  ["window-close-others"] = { keybind = "<C-w>o", desc = "Close other windows, preserving special ones" },
  ["terminal-exit"] = { keybind = "<esc>", desc = "Exit terminal mode" },
  ["context-go-to"] = { keybind = "[c", desc = "Go to context" },
  ["fold-open-all"] = { keybind = "zR", desc = "Open all folds" },
  ["fold-close-all"] = { keybind = "zM", desc = "Close all folds" },
  ["spectre-toggle"] = { keybind = "<leader>S", desc = "Toggle Spectre" },
  ["spectre-word-search"] = { keybind = "<leader>sw", desc = "Spectre word search" },
  ["spectre-visual-search"] = { keybind = "<leader>sw", desc = "Spectre visual search" },
  ["spectre-file-search"] = { keybind = "<leader>sp", desc = "Spectre file search" },
  ["codecompanion-actions"] = { keybind = "<C-c>", desc = "CodeCompanion actions" },
  ["codecompanion-chat-toggle"] = { keybind = "<LocalLeader>a", desc = "Toggle CodeCompanion chat" },
  ["codecompanion-chat-open"] = { keybind = "<leader>cc", desc = "Open CodeCompanion chat" },
  ["codecompanion-chat-add"] = { keybind = "<leader>ga", desc = "Add to CodeCompanion chat" },
  ["codecompanion-inline"] = { keybind = "<leader>ci", desc = "CodeCompanion inline transformation" },
  ["ssr-open"] = { keybind = "<leader>cR", desc = "Structural replace (SSR)" },
  ["dial-inc-normal"] = { keybind = "<C-a>", desc = "Dial increment" },
  ["dial-dec-normal"] = { keybind = "<C-x>", desc = "Dial decrement" },
  ["dial-inc-gnormal"] = { keybind = "g<C-a>", desc = "Dial g-increment" },
  ["dial-dec-gnormal"] = { keybind = "g<C-x>", desc = "Dial g-decrement" },
  ["dial-inc-visual"] = { keybind = "<C-a>", desc = "Dial visual increment" },
  ["dial-dec-visual"] = { keybind = "<C-x>", desc = "Dial visual decrement" },
  ["dial-inc-gvisual"] = { keybind = "g<C-a>", desc = "Dial g-visual increment" },
  ["dial-dec-gvisual"] = { keybind = "g<C-x>", desc = "Dial g-visual decrement" },
  ["luasnip-prev-choice"] = { keybind = "<c-k>", desc = "LuaSnip expand/choice prev" },
  ["luasnip-next"] = { keybind = "<c-j>", desc = "LuaSnip jump next" },
  ["luasnip-choice-next"] = { keybind = "<c-l>", desc = "LuaSnip choice next" },
  ["spider-w"] = { keybind = "w", desc = "Spider-w (motion)" },
  ["spider-e"] = { keybind = "e", desc = "Spider-e (motion)" },
  ["spider-b"] = { keybind = "b", desc = "Spider-b (motion)" },
  ["spider-ge"] = { keybind = "ge", desc = "Spider-ge (motion)" },
  ["dap-ui-toggle"] = { keybind = "<leader>dO", desc = "Toggle DAP UI" },
  ["dap-eval-input"] = { keybind = "<leader>dE", desc = "Evaluate input" },
  ["dap-float-element"] = { keybind = "<leader>d.", desc = "Open floating element" },
  ["dap-hover"] = { keybind = "<leader>dw", desc = "Hover" },
  ["dap-variables"] = { keybind = "<leader>dlv", desc = "Variables" },
  ["dap-breakpoints"] = { keybind = "<leader>dlb", desc = "Breakpoints" },
  ["dap-frames"] = { keybind = "<leader>dlf", desc = "Frames" },
  ["dap-commands"] = { keybind = "<leader>dlc", desc = "Commands" },
  ["snacks-buffer-delete"] = { keybind = "<leader>bd", desc = "Buffer delete" },
  ["snacks-buffer-delete-others"] = { keybind = "<leader>bo", desc = "Buffer delete others" },
  ["buffer-close-hidden"] = { keybind = "<leader>bh", desc = "Close hidden buffers" },
  ["snacks-files-picker"] = { keybind = "<leader><leader>", desc = "Files picker" },
  ["snacks-spelling-picker"] = { keybind = "z=", desc = "Spelling picker" },
  ["snacks-buffers-picker"] = { keybind = "<leader>,", desc = "Buffers picker" },
  ["snacks-buffer-lines"] = { keybind = "<leader>b", desc = "Buffer lines (fuzzy search)" },
  ["snacks-project-grep"] = { keybind = "<leader>/", desc = "Project grep" },
  ["snacks-git-files"] = { keybind = "<leader>fg", desc = "Git files picker" },
  ["snacks-recent-files"] = { keybind = "<leader>fr", desc = "Recent files picker" },
  ["snacks-save-all"] = { keybind = "<leader>sa", desc = "Save all buffers" },
  ["snacks-format-buffer"] = { keybind = "<leader>fa", desc = "Format buffer (LSP)" },
  ["snacks-close-hidden"] = { keybind = "<leader>bc", desc = "Close hidden buffers" },
  ["snacks-open-terminal"] = { keybind = "<leader>tt", desc = "Open terminal" },
  ["snacks-toggle-minuet"] = { keybind = "<leader>mt", desc = "Toggle Minuet virtual text" },
  ["snacks-debug-searcher"] = { keybind = "<leader>dd", desc = "Debug searcher" },
  ["snacks-icons-picker"] = { keybind = "<leader>si", desc = "Icons picker" },
  ["snacks-undo-picker"] = { keybind = "<leader>u", desc = "Undo picker" },
  ["snacks-lsp-symbols"] = { keybind = "<leader>o", desc = "LSP symbols picker" },
  ["snacks-lsp-workspace-symbols"] = { keybind = "<leader>O", desc = "LSP workspace symbols picker" },
  ["snacks-diagnostics-buffer"] = { keybind = "<leader>q", desc = "Diagnostics buffer picker" },
  ["snacks-diagnostics"] = { keybind = "<leader>Q", desc = "Diagnostics picker" },
  ["snacks-buffer-lines-picker"] = { keybind = "<leader>fl", desc = "Buffer lines picker" },
  ["snacks-refine-picker-results"] = { keybind = "<c-r>", desc = "Refine picker results (grep within)" },
  ["mini-diff-apply"] = { keybind = "gh", desc = "Apply hunk" },
  ["mini-diff-reset"] = { keybind = "gH", desc = "Reset hunk" },
  ["mini-diff-textobject"] = { keybind = "gh", desc = "Hunk textobject" },
  ["mini-diff-first"] = { keybind = "[H", desc = "First hunk" },
  ["mini-diff-prev"] = { keybind = "[h", desc = "Previous hunk" },
  ["mini-diff-next"] = { keybind = "]h", desc = "Next hunk" },
   ["mini-diff-last"] = { keybind = "]H", desc = "Last hunk" },
   ["mini-diff-toggle-overlay"] = { keybind = "<leader>dt", desc = "Toggle diff overlay" },
   ["mini-eval-math"] = { keybind = "g=", desc = "Evaluate math expressions" },
  ["mini-exchange-text"] = { keybind = "gx", desc = "Exchange text regions" },
  ["mini-multiply-text"] = { keybind = "gm", desc = "Multiply (duplicate) text" },
  ["mini-replace-register"] = { keybind = "gr", desc = "Replace with register" },
  ["mini-sort-text"] = { keybind = "gs", desc = "Sort text" },
  ["mini-splitjoin-toggle"] = { keybind = "gS", desc = "Toggle split/join" },
  ["crates-popup"] = { keybind = "K", desc = "Show crate popup" },
  ["crates-versions"] = { keybind = "<leader>cv", desc = "Show versions popup" },
  ["crates-features"] = { keybind = "<leader>cf", desc = "Show features popup" },
  ["crates-dependencies"] = { keybind = "<leader>cd", desc = "Show dependencies popup" },
  ["crates-upgrade"] = { keybind = "<leader>cu", desc = "Upgrade crate" },
  ["crates-upgrade-all"] = { keybind = "<leader>cU", desc = "Upgrade all crates" },
  ["diagnostic-next"] = { keybind = "<leader>j", desc = "Next diagnostic" },
  ["diagnostic-prev"] = { keybind = "<leader>k", desc = "Previous diagnostic" },
  ["diagnostic-next-error"] = { keybind = "<leader>l", desc = "Next error" },
   ["diagnostic-prev-error"] = { keybind = "<leader>jk", desc = "Previous error" },
  ["tab-only"] = { keybind = "<leader>to", desc = "Close other tabs" },
  ["tab-split"] = { keybind = "<leader>tt", desc = "Split tab" },
  ["tab-close"] = { keybind = "<leader>tq", desc = "Close tab" },
  ["tab-prev"] = { keybind = "<A-,>", desc = "Previous tab" },
  ["tab-next"] = { keybind = "<A-.>", desc = "Next tab" },
  ["tab-move-prev"] = { keybind = "<A-<>", desc = "Move tab left" },
  ["tab-move-next"] = { keybind = "<A->>", desc = "Move tab right" },
  ["graphene-init"] = { keybind = "<leader>f", desc = "Init graphene" },
  ["nohl"] = { keybind = "<Esc>", desc = "Clear search highlight" },
  ["indent-buffer"] = { keybind = "<leader>ci", desc = "Indent whole buffer" },
  ["dev-save-exec"] = { keybind = "<leader>XX", desc = "Save and exec" },
}
-- stylua ignore start

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

local function checkDuplicates()
  -- Check for duplicate keybinds on startup
  local keybind_to_names = {}
  for name, info in pairs(keybinds) do
    local kb = info.keybind
    if not keybind_to_names[kb] then
      keybind_to_names[kb] = {}
    end
    table.insert(keybind_to_names[kb], name)
  end

  local messages = {}
  for kb, names in pairs(keybind_to_names) do
    if #names > 1 then
      table.insert(messages, "Duplicate keybind '" .. kb .. "' used by: " .. table.concat(names, ", "))
    end
  end

  if #messages > 0 then
    vim.notify(table.concat(messages, "\n"), vim.log.levels.WARN)
  end
end

vim.defer_fn(checkDuplicates, 15000)

return M
