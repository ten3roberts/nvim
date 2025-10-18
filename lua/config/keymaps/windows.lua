local keybinds = require "config.keybind_definitions"

vim.keymap.set("n", keybinds.getKeybind "buffer-close-hidden", function()
  require("config.bclose").close_hidden()
end, { desc = keybinds.getDesc "buffer-close-hidden" })

local function close_normal_windows()
  vim.notify "Closing normal windows"
  local wins = vim.api.nvim_list_wins()
  local normal_wins = {}
  -- Collect all normal windows
  for _, win in ipairs(wins) do
    local buf = vim.api.nvim_win_get_buf(win)
    local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
    if buftype == "" then
      table.insert(normal_wins, win)
    end
  end
  -- Always preserve the current window if it's normal
  local current_win = vim.api.nvim_get_current_win()
  local preserve_win = nil
  for _, win in ipairs(normal_wins) do
    if win == current_win then
      preserve_win = win
      break
    end
  end
  -- If current window is not normal, preserve the first normal window
  if not preserve_win and #normal_wins > 0 then
    preserve_win = normal_wins[1]
  end

  -- Close all normal windows except the preserved one
  local closed_count = 0
  for _, win in ipairs(normal_wins) do
    if win ~= preserve_win then
      local ok = pcall(vim.api.nvim_win_close, win, true)
      if ok then
        closed_count = closed_count + 1
      end
    end
  end
  local window_word = closed_count == 1 and "window" or "windows"
  vim.notify("Closed " .. closed_count .. " " .. window_word)
end

vim.keymap.set({ "n", "v" }, keybinds.getKeybind "window-close-others", function()
  -- Use the custom function to preserve special windows
  close_normal_windows()
end, { desc = keybinds.getDesc "window-close-others" })

vim.keymap.set("n", keybinds.getKeybind "tab-only", "<cmd>tabonly<CR>", { desc = keybinds.getDesc "tab-only" })
vim.keymap.set("n", keybinds.getKeybind "tab-split", "<cmd>tab split<CR>", { desc = keybinds.getDesc "tab-split" })
vim.keymap.set("n", keybinds.getKeybind "tab-close", "<cmd>tabclose<CR>", { desc = keybinds.getDesc "tab-close" })

for i = 0, 9 do
  vim.keymap.set("n", "<leader>" .. i, i .. "gt")
end

vim.keymap.set("n", keybinds.getKeybind "tab-prev", "<cmd>tabprevious<CR>", { desc = keybinds.getDesc "tab-prev" })
vim.keymap.set("n", keybinds.getKeybind "tab-next", "<cmd>tabnext<CR>", { desc = keybinds.getDesc "tab-next" })
vim.keymap.set(
  "n",
  keybinds.getKeybind "tab-move-prev",
  "<cmd>tabmove -1<CR>",
  { desc = keybinds.getDesc "tab-move-prev" }
)
vim.keymap.set(
  "n",
  keybinds.getKeybind "tab-move-next",
  "<cmd>tabmove +1<CR>",
  { desc = keybinds.getDesc "tab-move-next" }
)

