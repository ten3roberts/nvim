# Neovim

This is my personal configuration of neovim

## Features

This Neovim config is tailored for efficient coding, with a focus on LSP, AI assistance, and modern UI enhancements.

### Core Functionality
- **LSP Support**: Full language server protocol integration with diagnostics, goto definitions, references, and more.
- **Treesitter**: Advanced syntax highlighting, folding, indentation, incremental selection, and textobjects.
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
   - **Mini.diff**: Lightweight inline diff visualization with signs/numbers, overlay for detailed changes, hunk apply/reset, and navigation. Ideal for quick staging and reviewing changes against the index.
   - **Diffview**: Dedicated diff windows for comparing commits, branches, or files. Best for in-depth diff reviews, merge conflict resolution, and commit history exploration.
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
- **Startup Tips**: Random keybinding and functionality tips displayed on Neovim startup for quick learning.
- **Graphene**: File manager integration for project navigation.

### Disabled/Optional
- **Copilot**: GitHub Copilot (disabled in favor of local AI).
- **Telescope**: Replaced by Snacks picker for consistency.
- **Gitsigns**: Replaced by mini.diff for lightweight Git diffs.
- **Minuet AI**: Conditionally enabled if ZEN_API_KEY is set.

For keymaps, see the [Keymaps](#keymaps) section below.

# Keymaps

Keymaps are centralized in `lua/config/keybind_definitions.lua` for consistency and organized into modules in `lua/config/keymaps/`. All use `<leader>` as Space. Below is a table of keybindings by category.

| Category | Key | Description |
|----------|-----|-------------|
 | LSP & Diagnostics | `<leader>j` / `<leader>k` | Next/previous diagnostic |
 | LSP & Diagnostics | `<leader>l` / `<leader>jk` | Next/previous error |
| Windows & Buffers | `<C-w>o` | Close other windows (preserve special) |
| Windows & Buffers | `<leader>bh` | Close hidden buffers |
| Windows & Buffers | `<leader>bo` | Buffer delete others (Snacks) |
| Windows & Buffers | `<leader>bd` | Buffer delete (Snacks) |
| Tabs | `<leader>0-9` | Switch to tab 1-10 |
| Tabs | `<A-,>` / `<A-.>` | Previous/next tab |
| Tabs | `<A-<>` / `<A->>` | Move tab left/right |
| Tabs | `<leader>to` | Close other tabs |
| Tabs | `<leader>tt` | Split tab |
| Tabs | `<leader>tq` | Close tab |
| Search & Navigation | `<Esc>` | Clear search highlight |
| Search & Navigation | `<leader><leader>` | Files picker |
| Search & Navigation | `<leader>,` | Buffers picker |
| Search & Navigation | `<leader>b` | Buffer lines (fuzzy) |
| Search & Navigation | `<leader>/` | Project grep |
| Search & Navigation | `<leader>fg` | Git files |
| Search & Navigation | `<leader>fr` | Recent files |
| Search & Navigation | `<leader>o` | LSP symbols |
| Search & Navigation | `<leader>O` | LSP workspace symbols |
| Search & Navigation | `<leader>q` | Diagnostics buffer |
| Search & Navigation | `<leader>Q` | Diagnostics picker |
| Search & Navigation | `<leader>fl` | Buffer lines picker |
| Search & Navigation | `<c-r>` | Refine picker results (grep within) |
| Search & Navigation | `z=` | Spelling picker |
 | Git & Diff | `gh` | Apply/reset hunk (mini.diff) |
 | Git & Diff | `gH` | Reset hunk |
 | Git & Diff | `[h` / `]h` | Previous/next hunk |
 | Git & Diff | `[H` / `]H` | First/last hunk |
 | Git & Diff | `<leader>dt` | Toggle diff overlay (mini.diff) |
| Folding | `zR` / `zM` | Open/close all folds |
| Folding | `z1-z9` | Set fold level 0-8 |
| Text Operations | `g=` | Evaluate math (mini) |
| Text Operations | `gx` | Exchange regions (mini) |
| Text Operations | `gm` | Multiply (duplicate) text (mini) |
| Text Operations | `gr` | Replace with register (mini) |
| Text Operations | `gs` | Sort text (mini) |
| Text Operations | `gS` | Toggle split/join (mini) |
| AI & Completion | `<C-c>` | CodeCompanion actions |
| AI & Completion | `<LocalLeader>a` | Toggle CodeCompanion chat |
| AI & Completion | `<leader>cc` | Open CodeCompanion chat |
| AI & Completion | `<leader>ga` | Add to CodeCompanion chat (visual) |
| AI & Completion | `<leader>mt` | Toggle Minuet virtual text |
| Tools & Utilities | `<leader>S` | Toggle Spectre |
| Tools & Utilities | `<leader>sw` | Spectre word/file search |
| Tools & Utilities | `<leader>sp` | Spectre file search |
| Tools & Utilities | `<leader>cR` | Structural replace (SSR) |
| Tools & Utilities | `<leader>sa` | Save all buffers |
| Tools & Utilities | `<leader>fa` | Format buffer (LSP) |
| Tools & Utilities | `<leader>tt` | Open terminal |
| Tools & Utilities | `<leader>dd` | Debug searcher |
| Tools & Utilities | `<leader>si` | Icons picker |
| Tools & Utilities | `<leader>u` | Undo picker |
| Tools & Utilities | `<leader>XX` | Save and execute (dev utils) |
| Tools & Utilities | `<leader>ci` | Indent whole buffer |
| Tools & Utilities | `<leader>f` | Init graphene |
| Window Picker | `<leader>w` | Pick window |
| Window Picker | `<leader><A-w>` | Zap window |
| Window Picker | `<leader>W` | Swap window |
| Dial (Increment/Decrement) | `<C-a>` / `<C-x>` | Increment/decrement (normal/visual) |
| Dial (Increment/Decrement) | `g<C-a>` / `g<C-x>` | G-increment/decrement (normal/visual) |
| Yanky (Clipboard) | `y`, `p`, `P`, etc. | Enhanced yank/put |
| Yanky (Clipboard) | `<A-n>` / `<A-p>` | Cycle forward/backward |
| Yanky (Clipboard) | `<C-y>` | Yank history (Telescope) |
| Spider (Motions) | `w`, `e`, `b`, `ge` | Better word motions |
| LuaSnip | `<c-k>` | Expand/choice prev |
| LuaSnip | `<c-j>` | Jump next |
| LuaSnip | `<c-l>` | Choice next |
| Crates (TOML) | `K` | Show crate popup |
| Crates (TOML) | `<leader>cv` | Versions popup |
| Crates (TOML) | `<leader>cf` | Features popup |
| Crates (TOML) | `<leader>cd` | Dependencies popup |
| Crates (TOML) | `<leader>cu` | Upgrade crate |
| Crates (TOML) | `<leader>cU` | Upgrade all crates |
| Terminal | `<Esc>` | Exit terminal mode |

## Notes
- **Dynamic Mappings**: LSP and plugin-generated mappings may vary.
- **Modes**: Most are normal mode; visual/select/insert noted where applicable.
- **Leader**: Space.
- Keymaps use centralized definitions for easy customization.

# TODO
- fn snippet
- non-empty
