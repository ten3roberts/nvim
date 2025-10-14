local function getZenProvider()
  local key = os.getenv "ZEN_API_KEY"
  if not key then
    return nil
  end
  return {
    openai_compatible = {
      api_key = "ZEN_API_KEY",
      end_point = "https://api.opencode.ai/v1/chat/completions",
      model = "zen",
      name = "OpenCode Zen",
    },
  }
end

return {
  {
    "milanglacier/minuet-ai.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    opts = function()
      local zen_provider = getZenProvider()
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
          end
        end,
      }
    end,
  },
}
