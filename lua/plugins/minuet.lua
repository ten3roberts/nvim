local function getZenProvider()
  local key = os.getenv "ZEN_API_KEY"
  if not key then
    return nil
  end
  return {
    openai_compatible = {
      api_key = key,
      end_point = "https://api.opencode.ai/v1/chat/completions",
      model = "zen",
      name = "OpenCode Zen",
    },
  }
end

return {
  {
    "milanglacier/minuet-ai.nvim",
    event = "VeryLazy",
    dependencies = "nvim-lua/plenary.nvim",
    opts = function()
      local zen_provider = getZenProvider()
      vim.notify("Configuring minuet: " .. (vim.inspect(zen_provider) or "none"))
      return {
        virtualtext = {
          auto_trigger_ft = { "*" },
          auto_trigger_ignore_ft = { "help", "hgcommit", "svn", "cvs" },
          keymap = {
            -- accept whole completion
            accept = "<C-e>",
            -- accept one line
            accept_line = "<C-E>",
            -- accept n lines (prompts for number)
            -- e.g. "A-z 2 CR" will accept 2 lines
            accept_n_lines = "<A-z>",
            -- Cycle to prev completion item, or manually invoke completion
            prev = "<A-[>",
            -- Cycle to next completion item, or manually invoke completion
            next = "<A-]>",
            dismiss = "<A-e>",
          },
        },
        provider = zen_provider and "openai_compatible" or nil,
        provider_options = zen_provider,
        config = function(_, opts)
          if opts.provider then
            require("minuet").setup(opts)
            vim.notify("Minuet AI enabled with OpenCode Zen", vim.log.levels.INFO)
          else
            vim.notify("Minuet AI disabled (ZEN_API_KEY not set)", vim.log.levels.WARN)
          end
        end,
      }
    end,
  },
}
