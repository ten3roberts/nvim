---
description: Clean up Rust code - unused imports, variables, and flag missed usages
---

Clean up Rust code by analyzing and fixing unused items intelligently.

Target: $ARGUMENTS (workspace, crate path, or module path. Defaults to current directory)

## Phase 1: Initial Analysis

1. Run `cargo check 2>&1` to capture all warnings
2. Run `cargo clippy 2>&1` for additional lints
3. Parse warnings for:
   - `unused_imports`
   - `unused_variables`
   - `unused_mut`
   - `dead_code`
   - `unused_assignments`

## Phase 2: Parallel Module Analysis

For each module/file with warnings, spawn an explore subagent to:

- Read the file and understand context
- Categorize each unused item:

  **AUTO-FIX (obvious cleanups):**
  - Unused imports → remove
  - Unused trait method params → replace with `_`
  - Unused loop variables → replace with `_`
  - Truly dead helper code → remove

  **FLAG AS MISSED (needs human review):**
  - Unused function parameters that SHOULD be used (logic bug)
  - Unused variables from important computations
  - Dead code that looks intentional but unreachable
  - Anything suspicious

- For MISSED items, add `// FIXME(cleanup): unused - was this intentional?` comment
- Return summary of changes and flags per file

## Phase 3: Import Optimization

After individual fixes, optimize imports per file:

- Remove duplicates
- Merge imports from same module: `use foo::{a, b, c}`
- If >5 imports from same path, use glob: `use foo::bar::*`
- Sort imports: std → external crates → crate → self/super

## Phase 4: Apply & Verify

1. Present summary of all proposed changes to user
2. On confirmation, apply fixes
3. Run `cargo check` to verify
4. Generate `.cleanup-report.md`:
   - Auto-fixes applied (count by type)
   - FIXME flags added (file:line + context)
   - Remaining warnings (if any)

## Rules

- **STOP and ask** if encountering ambiguous cases
- **Never** just prefix everything with `_` to silence warnings
- **Preserve** items marked with `#[allow(unused)]` or `#[allow(dead_code)]`
- Respect `// TODO:` or `// WIP:` comments near unused code
