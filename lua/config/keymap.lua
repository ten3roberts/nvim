local function map(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, opts)
end

local qf = require "qf"
local graphene = require "graphene"

local diffview = require "diffview"
-- local neotest = require "neotest"

local tree = require "config.treebind"

tree.register({
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
      graphene.init()
    end,
    "Open parent folder",
  },
  -- F = {
  --   function()
  --     graphene.init "."
  --   end,
  --   "Open root",
  -- },
  -- n = {
  --   r = {
  --     function()
  --       neotest.run.run()
  --     end,
  --   },
  --   f = {
  --     function()
  --       neotest.run.run(vim.fn.expand "%")
  --     end,
  --   },
  -- },

  t = {
    name = "tabs",

    o = { "<cmd>tabonly<CR>", "Close other tabs" },
    t = { "<cmd>tab split<CR>", "New tab" },
    q = { "<cmd>tabclose<CR>", "Close tab" },
  },

  g = {
    name = "git",
    d = { diffview.open, "Diffview" },
    D = {
      function()
        if vim.api.nvim_get_mode().mode == "s" then
          vim.cmd ":'<,'>DiffviewFileHistory %"
        else
          vim.cmd "DiffviewFileHistory %"
        end
      end,
      "DiffviewFileHistory",
      mode = { "n", "s" },
    },
    m = {
      function()
        diffview.open "@{u}...HEAD"
      end,
      "Diff against parent branch",
    },
  },
  h = {
    name = "term",
    t = {
      function()
        local recipe = require "recipe"
        recipe.execute({ cmd = "zsh", adapter = "term" }):focus {}
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

  j = {
    vim.diagnostic.goto_next,
    "Next diagnostic item",
  },
  k = {
    vim.diagnostic.goto_prev,
    "Prev diagnostic item",
  },
}, { prefix = "<leader>" })

tree.register {
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
      qf.next "visible"
    end,
    "Next quickfix item",
  },
  ["[q"] = {
    function()
      qf.prev "visible"
    end,
    "Prev quickfix item",
  },
}

local silent = { silent = true }

for i = 0, 9 do
  map("n", "<leader>" .. i, i .. "gt")
end

map("n", "<A-,>", ":tabprevious<CR>")
map("n", "<A-.>", ":tabnext<CR>")
map("n", "<A-<>", ":tabmove -1<CR>")
map("n", "<A->>", ":tabmove +1<CR>")

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
map("n", "<Esc>", "<cmd>nohl<CR>", {})

-- Move lines
map("n", "<A-k>", ":m .-2<CR>==", silent)
map("n", "<A-j>", ":m .+1<CR>==", silent)
map("x", "<A-k>", ":m '<-2<CR>gv=gv", silent)
map("x", "<A-j>", ":m '>+1<CR>gv=gv", silent)

-- map("n", "<A-h>", ":SidewaysLeft<CR>", silent)
-- map("n", "<A-l>", ":SidewaysRight<CR>", silent)

-- Textobjects for inside and around arguments/lists,paramater constraints
-- map({ "x", "o" }, "aa", "<Plug>SidewaysArgumentTextobjA", silent)
-- map({ "x", "o" }, "a,", "<Plug>SidewaysArgumentTextobjA", silent)

-- -- map({ "x", "o" }, "ia", "<Plug>SidewaysArgumentTextobjI", silent)
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

require("config.treebind").register({
  r = { "<cmd>RustRunnables<CR>", "Rust runnables" },
  d = { "<cmd>RustDebuggables<CR>", "Rust debuggables" },
  u = { "<cmd>RustParentModule<CR>", "Rust parent module" },
  U = { "<cmd>RustOpenCargo<CR>", "Open Cargo.toml" },
}, { prefix = "<leader>r" })
