# Neovim

This is my personal configuration of neovim

## Features

This Neovim config is tailored for efficient coding, with a focus on LSP, AI assistance, and modern UI enhancements.

### Core Functionality
- **LSP Support**: Full language server protocol integration with diagnostics, goto definitions, references, and more.
- **Treesitter**: Advanced syntax highlighting, folding, and incremental selection.
- **Completion**: Multi-source autocompletion via Blink.cmp, nvim-cmp, and Minuet AI (OpenCode Zen provider, requires ZEN_API_KEY).
- **Snippets**: LuaSnip for expandable code snippets.
- **AI Assistance**: CodeCompanion for AI chat and code generation; Minuet for inline AI completions (conditional on API key).

### UI & Navigation
- **Statusline**: Customizable Lualine (or Heirline) with mode-dependent colors and Minuet integration.
- **Picker/Fuzzy Finder**: Snacks picker for files, buffers, grep, diagnostics, undo, and more (ivy layout for grep).
- **Notifications**: Snacks notifier for clean, compact messages.
- **Command Line**: Noice for fancy popup cmdline with icons and history.
- **File Explorer**: Nvim-tree with custom mappings.
- **Harpoon**: Quick file marking and navigation.
- **Aerial**: Symbol outline for code navigation.

### Development Tools
- **Git Integration**: Diffview, Neogit, and mini.diff for Git operations.
- **Debugging**: DAP with codelldb for Rust/Python debugging.
- **Testing**: Neotest for running tests.
- **Refactoring**: Spectre for find/replace, and comment.nvim for commenting.
- **Folding**: UFO for advanced code folding.
- **Motion**: Spider for better word motions.
- **Mini Operators**: Advanced text operations (sort `gs`, exchange `gx`, evaluate `g=`, multiply `gm`, replace `gr`).
- **Mini Splitjoin**: Smart split/join of code structures (`gS` to toggle).
- **Mini Hipatterns**: Custom pattern highlighting (TODO, FIXME, HACK, NOTE, URLs, hex colors).

### Language-Specific
- **Rust**: Crates.nvim for Cargo.toml management.
- **Lua**: Enhanced Lua development with lua-lsp and dev utils.
- **Markdown**: Render-markdown with full features (code blocks, checkboxes, tables, links, quotes), and headlines.
- **TOML/JSON**: Syntax highlighting and tools.

### Utilities
- **Image Support**: Snacks image for inline images.
- **Terminal**: Integrated terminal with recipe for task running.
- **Sessions**: Auto-session with auto-save and restore for project persistence.
- **Themes**: Palette-based theming with Catppuccin (mocha) as default colorscheme.

### Disabled/Optional
- **Copilot**: GitHub Copilot (disabled in favor of local AI).
- **Telescope**: Replaced by Snacks picker for consistency.
- **Gitsigns**: Replaced by mini.diff for lightweight Git diffs.
- **Minuet AI**: Conditionally enabled if ZEN_API_KEY is set.

For keymaps, see the [Keymaps](#keymaps) section below.

# Keymaps

Below is a comprehensive list of all `vim.keymap.set` calls found in your config, organized by file. I've extracted the mode, key, action/description, and noted if it's buffer-local or has special options. Commented-out mappings are excluded.

## General Config

### lua/config/keymap.lua
- **Mode**: n | **Key**: `<C-w>o` | **Action**: Custom window maximize | **Options**: Function-based

### lua/config/autocommands.lua
- **Mode**: t | **Key**: `<esc>` | **Action**: Exit terminal mode | **Options**: Buffer-local

## Plugins

### lua/plugins/spider.lua
- **Mode**: n, o, x | **Key**: w | **Action**: Spider-w (motion)
- **Mode**: n, o, x | **Key**: e | **Action**: Spider-e (motion)
- **Mode**: n, o, x | **Key**: b | **Action**: Spider-b (motion)
- **Mode**: n, o, x | **Key**: ge | **Action**: Spider-ge (motion)

### lua/plugins/spectre.lua
- **Mode**: n | **Key**: `<leader>S` | **Action**: Toggle Spectre
- **Mode**: n | **Key**: `<leader>sw` | **Action**: Spectre word search
- **Mode**: v | **Key**: `<leader>sw` | **Action**: Spectre visual search
- **Mode**: n | **Key**: `<leader>sp` | **Action**: Spectre file search

### lua/plugins/luasnip.lua
- **Mode**: i, s | **Key**: `<c-k>` | **Action**: Luasnip expand/choice prev
- **Mode**: i, s | **Key**: `<c-j>` | **Action**: Luasnip jump next
- **Mode**: i, s | **Key**: `<c-l>` | **Action**: Luasnip choice next

### lua/plugins/lsp.lua
- **Mode**: Various (LSP-defined) | **Key**: Various (e.g., gd, gr) | **Action**: LSP actions (goto definition, references, etc.) | **Options**: Buffer-local, silent

### lua/plugins/treesitter.lua
- **Mode**: n | **Key**: `[c` | **Action**: Prev conflict (Treesitter)

### lua/plugins/init.lua
- **Mode**: n, x | **Key**: `<leader>cR` | **Action**: Comment refactor
- **Mode**: n | **Key**: `<C-a>` | **Action**: Dial increment
- **Mode**: n | **Key**: `<C-x>` | **Action**: Dial decrement
- **Mode**: n | **Key**: `g<C-a>` | **Action**: Dial g-increment
- **Mode**: n | **Key**: `g<C-x>` | **Action**: Dial g-decrement
- **Mode**: v | **Key**: `<C-a>` | **Action**: Dial visual increment
- **Mode**: v | **Key**: `<C-x>` | **Action**: Dial visual decrement
- **Mode**: v | **Key**: `g<C-a>` | **Action**: Dial g-visual increment
- **Mode**: v | **Key**: `g<C-x>` | **Action**: Dial g-visual decrement

### lua/plugins/ufo.lua
- **Mode**: n | **Key**: `zR` | **Action**: Open all folds
- **Mode**: n | **Key**: `zM` | **Action**: Close all folds
- **Mode**: n | **Key**: `z1-z9` | **Action**: Set fold level to 0-8

### lua/plugins/codecompanion.lua
- **Mode**: n, v | **Key**: `<C-c>` | **Action**: CodeCompanion actions
- **Mode**: n, v | **Key**: `<LocalLeader>a` | **Action**: CodeCompanion chat toggle
- **Mode**: n | **Key**: `<leader>cc` | **Action**: Open CodeCompanion chat
- **Mode**: v | **Key**: `ga` | **Action**: CodeCompanion chat add

### lua/plugins/snacks.lua
- **Mode**: n | **Key**: `<leader>bd` | **Action**: Buffer delete
- **Mode**: n | **Key**: `<leader>bo` | **Action**: Buffer delete others
- **Mode**: n | **Key**: `<leader><leader>` | **Action**: Files picker (ivy layout)
- **Mode**: n | **Key**: `z=` | **Action**: Spelling picker
- **Mode**: n | **Key**: `<leader>,` | **Action**: Buffers picker (ivy layout)
- **Mode**: n | **Key**: `<leader>/` | **Action**: Buffer lines (fuzzy search)
- **Mode**: n | **Key**: `<leader>?` | **Action**: Project grep (ivy layout)
- **Mode**: n | **Key**: `<leader>fg` | **Action**: Git files picker
- **Mode**: n | **Key**: `<leader>fr` | **Action**: Recent files picker
- **Mode**: n | **Key**: `<leader>sa` | **Action**: Save all buffers
- **Mode**: n | **Key**: `<leader>fa` | **Action**: Format buffer (LSP)
- **Mode**: n | **Key**: `<leader>bc` | **Action**: Close hidden buffers
- **Mode**: n | **Key**: `<leader>tt` | **Action**: Open terminal
- **Mode**: n | **Key**: `<leader>mt` | **Action**: Toggle Minuet virtual text
- **Mode**: n | **Key**: `<leader>dd` | **Action**: Debug searcher
- **Mode**: n | **Key**: `<leader>si` | **Action**: Icons picker
- **Mode**: n | **Key**: `<leader>u` | **Action**: Undo picker
- **Mode**: n | **Key**: `<leader>o` | **Action**: LSP symbols picker
- **Mode**: n | **Key**: `<leader>O` | **Action**: LSP workspace symbols picker
- **Mode**: n | **Key**: `<leader>q` | **Action**: Diagnostics buffer picker
- **Mode**: n | **Key**: `<leader>Q` | **Action**: Diagnostics picker
- **Mode**: n | **Key**: `<leader>fl` | **Action**: Buffer lines picker
- **Mode**: n,i | **Key**: `<c-r>` | **Action**: Refine picker results (grep within)

### lua/plugins/mini-diff.lua
- **Mode**: n | **Key**: gh | **Action**: Apply hunk
- **Mode**: n | **Key**: gH | **Action**: Reset hunk
- **Mode**: n, x | **Key**: gh | **Action**: Hunk textobject
- **Mode**: n | **Key**: [H | **Action**: First hunk
- **Mode**: n | **Key**: [h | **Action**: Previous hunk
- **Mode**: n | **Key**: ]h | **Action**: Next hunk
- **Mode**: n | **Key**: ]H | **Action**: Last hunk

### lua/plugins/mini-operators.lua
- **Mode**: n, x | **Key**: g= | **Action**: Evaluate math expressions
- **Mode**: n, x | **Key**: gx | **Action**: Exchange text regions
- **Mode**: n, x | **Key**: gm | **Action**: Multiply (duplicate) text
- **Mode**: n, x | **Key**: gr | **Action**: Replace with register
- **Mode**: n, x | **Key**: gs | **Action**: Sort text

### lua/plugins/mini-splitjoin.lua
- **Mode**: n | **Key**: gS | **Action**: Toggle split/join

## Filetype-Specific (after/ftplugin)

### after/ftplugin/toml.lua
- **Mode**: n | **Key**: `K` | **Action**: Show crate popup (Crates) | **Options**: Buffer-local
- **Mode**: n | **Key**: `<leader>cv` | **Action**: Show versions popup (Crates) | **Options**: Buffer-local
- **Mode**: n | **Key**: `<leader>cf` | **Action**: Show features popup (Crates) | **Options**: Buffer-local
- **Mode**: n | **Key**: `<leader>cd` | **Action**: Show dependencies popup (Crates) | **Options**: Buffer-local
- **Mode**: n | **Key**: `<leader>cu` | **Action**: Upgrade crate (Crates) | **Options**: Buffer-local
- **Mode**: n | **Key**: `<leader>cU` | **Action**: Upgrade all crates (Crates) | **Options**: Buffer-local

## Notes
- **Dynamic Mappings**: Some (e.g., LSP, treebind) are set dynamically and may vary per buffer/plugin.
- **Exclusions**: Commented-out mappings (e.g., in harpoon.lua, aerial.lua) are not included.
- **Modes**: n=normal, i=insert, v=visual, x=visual block, o=operator pending, s=select, t=terminal.
- **Leader**: Assumes `<leader>` is Space (common default).
- This list is based on static `vim.keymap.set` calls; runtime/plugin-generated ones may exist.

# TODO
- fn snippet
- non-empty
