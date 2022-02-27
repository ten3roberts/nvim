local actions = require'lir.actions'
local mark_actions = require 'lir.mark.actions'
local clipboard_actions = require'lir.clipboard.actions'
local lir = require 'lir'

lir.setup {
  show_hidden_files = false,
  devicons_enable = true,
  mappings = {
    ['l']     = actions.edit,
    ['<CR>']  = actions.edit,
    ['<C-s>'] = actions.split,
    ['<C-v>'] = actions.vsplit,
    ['<C-t>'] = actions.tabedit,

    ['h']     = actions.up,
    ['q']     = actions.quit,

    ['o']     = actions.mkdir,
    ['i']     = actions.newfile,
    ['r']     = actions.rename,
    ['@']     = actions.cd,
    ['y']     = actions.yank_path,
    ['.']     = actions.toggle_show_hidden,
    ['d']     = actions.delete,
    [',']     = mark_actions.toggle_mark,

    ['J'] = function()
      mark_actions.toggle_mark()
      vim.cmd('normal! j')
    end,

    ['<C-x>'] = function()
      local ctx = lir.get_context()
        vim.fn.system('xdg-open ' .. ctx.dir)
      end,

    ['c'] = clipboard_actions.copy,
    ['x'] = clipboard_actions.cut,
    ['p'] = clipboard_actions.paste,
  },
  float = {
    winblend = 10,
    curdir_window = {
      enable = true,
      highlight_dirname = true
    },

    -- You can define a function that returns a table to be passed as the third
    -- argument of nvim_open_win().
    win_opts = function()
      local width = 60
      local height = math.floor(vim.o.lines * 0.5)
      return {
        border = require("lir.float.helper").make_border_opts({
          '╭', '─', '╮', '│', '╯', '─', '╰', '│'
          --       "+", "─", "+", "│", "+", "─", "+", "│",
        }, "Comment"),
        width = width,
        height = height,
        -- row = 1,
        -- col = math.floor((vim.o.columns - width) / 2),
      }
    end,
  },
  hide_cursor = false,
  on_init = function()
    -- use visual mode
    vim.api.nvim_buf_set_keymap(
      0,
      "x",
      "J",
      ':<C-u>lua require"lir.mark.actions".toggle_mark("v")<CR>',
      { noremap = true, silent = true }
    )
    -- echo cwd
    vim.api.nvim_echo({ { vim.fn.expand("%:p"), "Normal" } }, false, {})
  end,
}

require'lir.git_status'.setup({
  show_ignored = false
})
