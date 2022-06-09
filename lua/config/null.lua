local null_ls = require("null-ls")
print("Setting up null_ls")
null_ls.setup({
	sources = {
		-- shell
		null_ls.builtins.diagnostics.shellcheck,
		null_ls.builtins.formatting.shfmt.with({
			extra_args = { "-i", "2", "-ci" },
		}),
		-- md
		null_ls.builtins.diagnostics.markdownlint,
		-- python
		null_ls.builtins.diagnostics.pylint,
		null_ls.builtins.formatting.black.with({
			extra_args = { "-l", "120" },
		}),
		-- latex
		null_ls.builtins.diagnostics.chktex,
		null_ls.builtins.formatting.latexindent,
		-- lua
		null_ls.builtins.formatting.stylua,
		-- git
		null_ls.builtins.code_actions.gitsigns,
		null_ls.builtins.completion.spell,
	},
	on_attach = function(client, bufnr)
		if client.server_capabilities.documentFormattingProvider then
			vim.api.nvim_create_autocmd("BufWritePre", {
				callback = function()
					vim.lsp.buf.format({ bufnr = bufnr })
				end,
				group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
			})
		end
	end,
})
