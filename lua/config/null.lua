local null_ls = require "null-ls"
null_ls.setup {
  sources = {
    -- shell
    -- null_ls.builtins.diagnostics.shellcheck,
    -- null_ls.builtins.formatting.shfmt.with {
    --   extra_args = { "-i", "2", "-ci" },
    -- },
    -- md
    -- null_ls.builtins.diagnostics.markdownlint,
    -- null_ls.builtins.completion.spell,

    -- null_ls.builtins.diagnostics.alex,
    null_ls.builtins.diagnostics.jsonlint,
    null_ls.builtins.diagnostics.yamllint,
    -- null_ls.builtins.diagnostics.selene,

    null_ls.builtins.formatting.latexindent,
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.jq,
    null_ls.builtins.formatting.prettier,
  },
}
