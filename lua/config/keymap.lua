local function map(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, opts)
end

local graphene = require "graphene"
local keybinds = require("config.keybind_definitions")

-- local neotest = require "neotest"

vim.keymap.set("n", keybinds.getKeybind("diagnostic-next"), function()
  vim.diagnostic.jump { count = 1, float = true }
end, { desc = keybinds.getDesc("diagnostic-next") })

vim.keymap.set("n", keybinds.getKeybind("diagnostic-prev"), function()
  vim.diagnostic.jump { count = -1, float = true }
end, { desc = keybinds.getDesc("diagnostic-prev") })

vim.keymap.set("n", keybinds.getKeybind("diagnostic-next-error"), function()
  vim.diagnostic.jump { count = 1, float = true, severity = vim.diagnostic.severity.ERROR }
end, { desc = keybinds.getDesc("diagnostic-next-error") })

vim.keymap.set("n", keybinds.getKeybind("diagnostic-prev-error"), function()
  vim.diagnostic.jump { count = -1, float = true, severity = vim.diagnostic.severity.ERROR }
end, { desc = keybinds.getDesc("diagnostic-prev-error") })

vim.keymap.set("n", keybinds.getKeybind("buffer-delete-others"), function()
  require("config.bclose").close_hidden()
end, { desc = "Close hidden buffers" })

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

vim.keymap.set("n", keybinds.getKeybind("window-close-others"), function()
  -- Use the custom function to preserve special windows
  close_normal_windows()
end, { desc = keybinds.getDesc("window-close-others") })

vim.keymap.set("n", keybinds.getKeybind("tab-only"), "<cmd>tabonly<CR>", { desc = keybinds.getDesc("tab-only") })
vim.keymap.set("n", keybinds.getKeybind("tab-split"), "<cmd>tab split<CR>", { desc = keybinds.getDesc("tab-split") })
vim.keymap.set("n", keybinds.getKeybind("tab-close"), "<cmd>tabclose<CR>", { desc = keybinds.getDesc("tab-close") })

vim.keymap.set("n", keybinds.getKeybind("graphene-init"), function()
  graphene.init()
end, { desc = keybinds.getDesc("graphene-init") })

for i = 0, 9 do
  map("n", "<leader>" .. i, i .. "gt")
end

vim.keymap.set("n", keybinds.getKeybind("tab-prev"), "<cmd>tabprevious<CR>", { desc = keybinds.getDesc("tab-prev") })
vim.keymap.set("n", keybinds.getKeybind("tab-next"), "<cmd>tabnext<CR>", { desc = keybinds.getDesc("tab-next") })
vim.keymap.set("n", keybinds.getKeybind("tab-move-prev"), "<cmd>tabmove -1<CR>", { desc = keybinds.getDesc("tab-move-prev") })
vim.keymap.set("n", keybinds.getKeybind("tab-move-next"), "<cmd>tabmove +1<CR>", { desc = keybinds.getDesc("tab-move-next") })

-- Search highlighting
-- map("n", "n", "<plug>(searchhi-n)")
-- map("n", "N", "<plug>(searchhi-N)")
-- map("n", "*", "<plug>(searchhi-*)")
-- map("n", "g*", "<plug>(searchhi-g*)")
-- map("n", "#", "<plug>(searchhi-#)")
-- map("n", "g#", "<plug>(searchhi-g#)")
-- map("n", "gd", "<plug>(searchhi-gd)")
-- map("n", "gD", "<plug>(searchhi-gD)")
--
-- map("x", "n", "<plug>(searchhi-v-n)")
-- map("x", "N", "<plug>(searchhi-v-N)")
-- map("x", "*", "<plug>(searchhi-v-*)")
-- map("x", "g*", "<plug>(searchhi-v-g*)")
-- map("x", "#", "<plug>(searchhi-v-#)")
-- map("x", "g#", "<plug>(searchhi-v-g#)")
-- map("x", "gd", "<plug>(searchhi-v-gd)")
-- map("x", "gD", "<plug>(searchhi-v-gD)")

-- map({ "n", "x" }, "*", "<Plug>(asterisk-z*)")
-- map({ "n", "x" }, "#", "<Plug>(asterisk-z#)")
-- map({ "n", "x" }, "g*", "<Plug>(asterisk-gz*)")
-- map({ "n", "x" }, "g#", "<Plug>(asterisk-gz#)")

-- map({ "n", "x" }, "z*", "<Plug>(asterisk-z*)")
-- map({ "n", "x" }, "z#", "<Plug>(asterisk-z#)")
-- map({ "n", "x" }, "gz*", "<Plug>(asterisk-gz*)")
-- map({ "n", "x" }, "gz#", "<Plug>(asterisk-gz#)")

-- Clear search highlight
vim.keymap.set("n", keybinds.getKeybind("nohl"), "<cmd>nohl<CR>", { desc = keybinds.getDesc("nohl") })

-- Folding
for i = 1, 9 do
  local o = vim.o
  map("n", "z" .. i, function()
    o.foldlevel = i - 1
    vim.notify("Foldlevel: " .. o.foldlevel, vim.log.levels.INFO)
  end)
end

-- Indent whole buffer
vim.keymap.set("n", keybinds.getKeybind("indent-buffer"), "mggg=G`g", { desc = keybinds.getDesc("indent-buffer") })

-- Dev utils
vim.keymap.set("n", keybinds.getKeybind("dev-save-exec"), '<cmd>lua require"config.dev_utils".save_and_exec()<CR>', { desc = keybinds.getDesc("dev-save-exec") })
