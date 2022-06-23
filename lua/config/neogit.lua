local neogit = require "neogit"
neogit.setup {
  integrations = {
    diffview = true,
  },
  disable_commit_confirmation = true,
  sections = {
    untracked = {
      folded = true,
    },
    unstaged = {
      folded = false,
    },
    staged = {
      folded = false,
    },
    stashes = {
      folded = true,
    },
    unpulled = {
      folded = false,
    },
    unmerged = {
      folded = false,
    },
    recent = {
      folded = false,
    },
  },
}

-- vim.keymap.set("n", "<leader>gg", neogit.open)
