local function map(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, opts)
end

local wk = require "which-key"

local qf = require "qf"
local graphene = require "graphene"

local diffview = require "diffview"
local recipe = require "recipe"
local neogit = require "neogit"
local window_picker = require "window-picker"
local builtin = require "telescope.builtin"

vim.g.mapleader = " "

wk.register({
  ["<leader>"] = {
    builtin.find_files,
    "Find files",
  },
  c = {
    name = "Quickfix",
    c = {
      function()
        qf.toggle "c"
      end,
      "Toggle",
    },
    f = {
      "<cmd>cc<CR>",
      "Find first",
    },
    o = {
      function()
        qf.open "c"
      end,
      "Open",
    },
  },
  l = {
    name = "Loclist",
    l = {
      function()
        qf.toggle "l"
      end,
      "Toggle",
    },
    c = {
      function()
        qf.close "l"
      end,
      "Close",
    },
  },
  f = {
    function()
      graphene.open()
    end,
    "Open parent folder",
  },
  F = {
    function()
      graphene.open "."
    end,
    "Open root",
  },
  e = {
    recipe.pick,
    "Pick a recipe",
  },
  E = {
    name = "recipe",
    r = {
      function()
        recipe.bake "run"
      end,
      "Run",
    },
    b = {
      function()
        recipe.bake "build"
      end,
      "Build",
    },

    E = {
      function()
        qf.filter("visible", function(v)
          return v.type == "E"
        end)
      end,
      "Filter errors",
    },
  },

  t = {
    name = "tabs",

    o = { "<cmd>tabonly<CR>", "Close other tabs" },
    t = { "<cmd>tab split<CR>", "New tab" },
    q = { "<cmd>tabclose<CR>", "Close tab" },
  },

  o = {
    builtin.lsp_document_symbols,
    "Document symbols",
  },

  O = {
    builtin.lsp_dynamic_workspace_symbols,
    "Workspace symbols",
  },

  r = {
    g = { builtin.live_grep, "Live grep" },
    h = { builtin.help_tags, "Help grep" },
    G = { builtin.grep_string, "Grep string" },
  },

  ["/"] = {
    builtin.current_buffer_fuzzy_find,
    "Buffer fuzzy find",
  },

  [","] = {
    builtin.buffers,
    "Buffers",
  },

  g = {
    name = "git",
    g = { neogit.open, "Git status" },
    d = { diffview.open, "Diffview" },
    b = { builtin.git_branches },
    l = { builtin.git_commits },
    m = {
      function()
        diffview.open "@{u}...HEAD"
      end,
      "Diff againt parent branch",
    },
  },
  h = {
    name = "term",
    t = {
      function()
        recipe.execute { cmd = "zsh", kind = "term" }
      end,
      "Open terminal",
    },
  },

  b = {
    name = "buffer",
    k = {
      require("config.bclose").close,
      "Close buffer",
    },
    o = {
      require("config.bclose").close_hidden,
      "Close all hidden buffers",
    },
  },

  w = {
    window_picker.pick,
    "Navigate to window",
  },
  W = {
    window_picker.swap,
    "Swap window",
  },

  j = {
    vim.diagnostic.goto_next,
    "Next diagnostic item",
  },
  k = {
    vim.diagnostic.goto_prev,
    "Prev diagnostic item",
  },
}, { prefix = "<leader>" })

wk.register {
  ["<M-x>"] = {
    builtin.command_history,
    "Command history",
  },
  ["]l"] = {
    function()
      qf.next "l"
    end,
    "Next loclist item",
  },
  ["[l"] = {
    function()
      qf.prev "l"
    end,
    "Prev loclist item",
  },
  ["]q"] = {
    function()
      qf.next "c"
    end,
    "Next quickfix item",
  },
  ["[q"] = {
    function()
      qf.prev "c"
    end,
    "Prev quickfix item",
  },
}

wk.register({
  ["<CR>"] = {
    function()
      recipe.bake "check"
    end,
    "Check",
  },
}, { prefix = "`" })

local silent = { silent = true }

for i = 0, 9 do
  map("n", "<leader>" .. i, i .. "gt")
end

map("n", "<A-,>", ":tabprevious<CR>")
map("n", "<A-.>", ":tabnext<CR>")
map("n", "<A-<>", ":tabmove -1<CR>")
map("n", "<A->>", ":tabmove +1<CR>")

-- Search highlighting
map("n", "n", "<plug>(searchhi-n)")
map("n", "N", "<plug>(searchhi-N)")
-- map("n", "*", "<plug>(searchhi-*)")
-- map("n", "g*", "<plug>(searchhi-g*)")
-- map("n", "#", "<plug>(searchhi-#)")
-- map("n", "g#", "<plug>(searchhi-g#)")
-- map("n", "gd", "<plug>(searchhi-gd)")
-- map("n", "gD", "<plug>(searchhi-gD)")
--
map("x", "n", "<plug>(searchhi-v-n)")
map("x", "N", "<plug>(searchhi-v-N)")
-- map("x", "*", "<plug>(searchhi-v-*)")
-- map("x", "g*", "<plug>(searchhi-v-g*)")
-- map("x", "#", "<plug>(searchhi-v-#)")
-- map("x", "g#", "<plug>(searchhi-v-g#)")
-- map("x", "gd", "<plug>(searchhi-v-gd)")
-- map("x", "gD", "<plug>(searchhi-v-gD)")

map({ "n", "x" }, "*", "<Plug>(asterisk-*)<Plug>(searchhi-update)")
map({ "n", "x" }, "#", "<Plug>(asterisk-#)<Plug>(searchhi-update)")
map({ "n", "x" }, "g*", "<Plug>(asterisk-g*)<Plug>(searchhi-update)")
map({ "n", "x" }, "g#", "<Plug>(asterisk-g#)<Plug>(searchhi-update)")

map({ "n", "x" }, "z*", "<Plug>(asterisk-z*)<Plug>(searchhi-update)")
map({ "n", "x" }, "z#", "<Plug>(asterisk-z#)<Plug>(searchhi-update)")
map({ "n", "x" }, "gz*", "<Plug>(asterisk-gz*)<Plug>(searchhi-update)")
map({ "n", "x" }, "gz#", "<Plug>(asterisk-gz#)<Plug>(searchhi-update)")

-- Clear search highlight
map("n", "<Esc>", "<plug>(searchhi-clear-all)")

-- Easy align
map("x", "ga", "<plug>(EasyAlign)")
map("n", "ga", "<plug>(EasyAlign)")

wk.register({
  y = { "<Plug>(YankyYank)", "Yank" },
  p = { "<Plug>(YankyPutAfter)", "Put" },
  P = { "<Plug>(YankyPutBefore)", "Put before" },
  gp = { "<Plug>(YankyGPutAfter)", "Gput" },
  gP = { "<Plug>(YankyGPutBefore)", "Gput after" },
  ["<A-n>"] = { "<Plug>(YankyCycleForward)", "Yankring forward" },
  ["<A-p>"] = { "<Plug>(YankyCycleBackward)", "Yankring backward" },
}, { mode = "n" })

wk.register({
  y = { "<Plug>(YankyYank)", "Yank" },
  p = { "<Plug>(YankyPutAfter)", "Put" },
  P = { "<Plug>(YankyPutBefore)", "Put before" },
  gp = { "<Plug>(YankyGPutAfter)", "Gput" },
  gP = { "<Plug>(YankyGPutBefore)", "Gput after" },
  ["<A-n>"] = { "<Plug>(YankyCycleForward)", "Yankring forward" },
  ["<A-p>"] = { "<Plug>(YankyCycleBackward)", "Yankring backward" },
}, { mode = "x" })

-- map("n", "y", "<Plug>(YankyYank)")
-- map("x", "y", "<Plug>(YankyYank)")
-- map('', '<C-a>', '^')
-- map('', '<C-e>', '$')

-- Transpose word
-- map('', 'L', 'daWWPB')
-- map('', 'H', 'daWBPB')
-- map('', 'M', '2dWBhP')

-- Move lines

map("n", "<A-k>", ":m .-2<CR>==", silent)
map("n", "<A-j>", ":m .+1<CR>==", silent)
map("x", "<A-k>", ":m '<-2<CR>gv=gv", silent)
map("x", "<A-j>", ":m '>+1<CR>gv=gv", silent)

map("n", "<A-h>", ":SidewaysLeft<CR>", silent)
map("n", "<A-l>", ":SidewaysRight<CR>", silent)

-- Textobjects for inside and around arguments/lists,paramater constraints
-- map({ "x", "o" }, "aa", "<Plug>SidewaysArgumentTextobjA", silent)
-- map({ "x", "o" }, "a,", "<Plug>SidewaysArgumentTextobjA", silent)

-- map({ "x", "o" }, "ia", "<Plug>SidewaysArgumentTextobjI", silent)
-- map({ "x", "o" }, "i,", "<Plug>SidewaysArgumentTextobjI", silent)

-- map({ "x", "o" }, "i,", "<Plug>SidewaysArgumentTextobjI", silent)

-- map('x', 'x', ':lua require"treesitter-unit".select()<CR>',      silent)
-- map('o', 'x', ':<c-u>lua require"treesitter-unit".select()<CR>', silent)
-- map('n', 'X', ':lua require"treesitter-unit".select()<CR>', silent)

-- Folding
for i = 1, 9 do
  local o = vim.o
  map("n", "z" .. i, function()
    o.foldlevel = i - 1
    print("Foldlevel: ", o.foldlevel)
  end)
end

-- Indent whole buffer
map("n", "<leader>ci", "mggg=G`g")

-- Dev utils
map("n", "<leader>xx", '<cmd>lua require"config.dev_utils".save_and_exec()<CR>')
wk.register({
  ["<C-a>"] = {
    require("dial.map").inc_normal(),
    "Increment",
  },
  ["<C-x>"] = {
    require("dial.map").dec_normal(),
    "Decrement",
  },
}, { mode = "n" })

wk.register({
  ["<C-a>"] = {
    require("dial.map").inc_visual(),
    "Increment",
  },
  ["<C-x>"] = {
    require("dial.map").dec_visual(),
    "Decrement",
  },
  ["g<C-a>"] = {
    require("dial.map").inc_gvisual(),
    "Increment",
  },
  ["g<C-x>"] = {
    require("dial.map").dec_gvisual(),
    "Decrement",
  },
}, { mode = "x" })
