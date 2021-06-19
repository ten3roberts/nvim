local g = vim.g

local completion_nvim = false

if completion_nvim then
  g.completion_abbr_length            = 20
  g.completion_confirm_key            = '<C-y>'
  g.completion_enable_snippet         = 'vim-vsnip'
  g.completion_matching_smart_case    = 1
  g.completion_matching_strategy_list = { 'exact', 'substring', 'fuzzy' }
  g.completion_sorting                = 'none'
  g.completion_timer_cycle            = 200
  g.completion_trigger_keyword_length = 2

  g.completion_chain_complete_list = {
    TelescopePrompt = {
      { complete_items= { } },
      { mode= '<c-p>' },
      { mode= '<c-n>' }
    },
    default = {
      { complete_items= { 'snippet', 'lsp', 'path', 'buffers' } },
      { mode= '<c-p>' },
      { mode= '<c-n>' }
    }
  }
else
  local function t(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
  end

  local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
      return true
    else
      return false
    end
  end

-- Use (s-)tab to:
  --- move to prev/next item in completion menuone
  --- jump to prev/next snippet's placeholder
  function _G.tab_complete()
    if vim.fn.pumvisible() == 1 then
      return t "<C-n>"
    elseif vim.fn.call("vsnip#available", {1}) == 1 then
      return t "<Plug>(vsnip-expand-or-jump)"
    elseif check_back_space() then
      return t "<Tab>"
    else
      return vim.fn['compe#complete']()
    end
  end

  function _G.s_tab_complete()
    if vim.fn.pumvisible() == 1 then
      return t "<C-p>"
    elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
      return t "<Plug>(vsnip-jump-prev)"
    else
      -- If <S-Tab> is not working in your terminal, change it to <C-h>
      return t "<S-Tab>"
    end
  end


  require'compe'.setup {
    enabled = true;
    autocomplete = true;
    debug = false;
    min_length = 2;
    preselect = 'disable';
    throttle_time = 200;
    source_timeout = 200;
    incomplete_delay = 400;
    max_abbr_width = 100;
    max_kind_width = 100;
    max_menu_width = 100;
    documentation = true;

    source = {
      path = true;
      buffer = true;
      calc = false;
      nvim_lsp = true;
      nvim_lua = false;
      vsnip = true;
      ultisnips = false;
      treesitter = false;
    };
  }

  vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
  vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
  vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
  vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
end
