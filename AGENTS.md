# AGENTS.md - Opencode Rules for Neovim Config Changes

This document outlines the rules, conventions, and best practices for making changes to this Neovim configuration codebase. Follow these guidelines to maintain consistency, performance, and usability.

## Plugin Management

- **Lazy Loading**: Enable lazy loading for performance
- **Conditional Loading**: Use `cond` function for optional plugins (e.g., Minuet requires `ZEN_API_KEY`)
- **Dependencies**: Explicitly list all dependencies in plugin specs
- **Version Pinning**: Use specific versions or commit hashes for stability
- **Cleanup**: Remove unused plugins and update `lazy-lock.json`

## Keymaps

- **Centralized Definitions**: Use `lua/config/keybind_definitions.lua` for all keybind registrations; add new keybinds there first
- **Documentation**: Update `README.md` keymaps table to reflect changes in `keybind_definitions.lua`; keep descriptions in sync
- **Conflicts**: Avoid keymap conflicts; test thoroughly; duplicate detection warns on startup
- **Consistency**: Follow existing patterns (e.g., `<leader>` for user commands); use `getKeybind()` and `getDesc()` functions
- **Modes**: Specify modes (n, i, v, etc.) clearly

## Testing & Validation

- **Startup Time**: Monitor with `nvim --startuptime`; aim for <200ms
- **Health Checks**: Run `:checkhealth` for issues
- **Manual Testing**: Test features in real usage scenarios
- **Error Handling**: Ensure graceful failures (e.g., missing API keys)

## Code Style

- **Lua Conventions**: Follow standard Lua practices
- **No Comments**: Avoid unnecessary comments in code
- **Readability**: Use clear variable names and structure
- **Performance**: Minimize heavy operations in hot paths

## Specific Rules for this Config

- **Statusline Toggle**: Use `vim.g.statusline_provider` to switch between Heirline/Lualine
- **AI Plugins**: Conditionally load based on env vars (Minuet: `ZEN_API_KEY`)
- **Git Integration**: Prefer mini.diff over Gitsigns for lightweight diffs
- **Picker**: Use Snacks for unified fuzzy finding
- **Theme**: Catppuccin (mocha) with custom integrations
- **Mini Plugins**: Leverage mini.nvim ecosystem for consistency
- **README Updates**: Keep features, keymaps, and setup instructions current

## Workflow

1. **Plan Changes**: Analyze impact and requirements
2. **Implement**: Make changes following conventions
3. **Test**: Validate functionality and performance
4. **Document**: Update README if needed

## Emergency Contacts

- For plugin issues: Check Lazy logs and `:Lazy log`
- For performance: Profile with `:Lazy profile`
- For keymaps: Use `:map` to inspect conflicts

Remember: This config prioritizes productivity, minimalism, and performance. Changes should enhance the editing experience without bloat.
