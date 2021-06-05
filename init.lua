require 'config.plugins'

require 'config.toggle_bool'
require 'config.keymap'
require 'config.options'
require 'config.dev_utils'
require 'config.autocommands'

vim.cmd "command Sort :'{,'}sort"
