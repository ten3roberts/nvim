require "config.options"
require "config.neovide"

-- Statusline provider toggle: "heirline" or "lualine"
vim.g.statusline_provider = "lualine"

require "config.lazy"

require "config.keymap"

require "config.devicons"
require("config.palette").setup()
require "config.dev_utils"
require "config.commands"
require "config.clean_fold"
require "config.autocommands"
require "config.profile"
