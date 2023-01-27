return {

  -- Better handling and seeking for textobjects
  "wellle/targets.vim",
  config = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "targets#mappings#user",
      callback = function()
        vim.fn["targets#mappings#extend"] {
          -- a = {},
          a = { argument = { { o = "[{([]", c = "[])}]", s = "[,;]" } } },
        }
      end,
    })
    --- { a, b, c }
    --- ( a, b, c )
  end,
  -- vim.cmd [[
  -- autocmd User targets#mappings#user call targets#mappings#extend({
  -- \ 'a': {'argument': [{'o': '{[([]', 'c': '[])]}', 's': ','}]},
  -- \ })
  -- ]]
  -- end
}
