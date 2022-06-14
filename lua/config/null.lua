local null_ls = require "null-ls"
null_ls.setup {
  sources = {
    -- shell
    null_ls.builtins.diagnostics.shellcheck,
    null_ls.builtins.formatting.shfmt.with {
      extra_args = { "-i", "2", "-ci" },
    },
    -- md
    null_ls.builtins.diagnostics.markdownlint,
    -- python
    null_ls.builtins.diagnostics.pylint,
    null_ls.builtins.formatting.black.with {
      extra_args = { "-l", "120" },
    },
    -- latex
    null_ls.builtins.diagnostics.chktex,
    null_ls.builtins.formatting.latexindent,
    -- lua
    null_ls.builtins.formatting.stylua,
  },
}
