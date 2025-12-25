---
description: Remove AI-generated code slop from the current branch
---

Check the diff against origin/main and remove all AI-generated slop introduced in this branch.

Here is the full diff:
!`git diff origin/main...HEAD`

## What to Remove

### Comments
- Obvious comments that restate what the code does (`// increment counter` above `counter++`)
- Overly detailed docstrings/doccomments where the function name + params are self-explanatory
- Section separator comments (`// ===== HELPERS =====`)
- Comments explaining basic language features or standard library usage
- Inline comments on every line or every few lines

### Defensive Over-Engineering
- Redundant null/undefined/nil checks on values that are already validated or cannot be null
- Try/catch blocks around code that cannot throw or where errors should propagate
- Unnecessary `.clone()`, defensive copies, or ownership gymnastics (Rust)
- Extra validation that duplicates checks already done by callers or type system

### Type System Workarounds
- Casts to `any`/`unknown` (TS), `as _` for type erasure (Rust) to silence errors
- Turbofish (`::<>`) or type annotations where inference works fine
- Overly complex generics or trait bounds when simpler types suffice

### Structural Patterns
- Extracting single-use helper functions that obscure rather than clarify
- Unnecessary intermediate variables (`let result = foo(); return result;`)
- Over-abstraction: interfaces/traits with single implementations, excessive indirection
- Factory functions or builders for simple object construction

### Naming and Style
- Overly verbose names (`userAuthenticationTokenString` vs `auth_token`)
- Inconsistent naming style with the rest of the file
- Using `.unwrap()` or `.expect()` where the codebase prefers `?` propagation
- Swallowing errors with `.ok()` or `.unwrap_or_default()` where errors should propagate
- Silent no-ops via `if let Some(v) = ... { }` that skip logic when None, where absence is actually an error condition

### Other AI Tells
- Emoji in comments or strings (unless the codebase uses them)
- Brittle "Verify" or "Ensure" function prefixes appearing suddenly
- Logging/debug statements at unusual verbosity for the codebase
- Constants extracted for single-use magic values that are obvious in context

## Process

1. For each changed file, read the full file to understand the existing style and patterns
2. Compare the diff to identify AI-introduced slop
3. Remove or fix the slop while preserving the intended functionality
4. Keep changes minimal - only remove what's clearly slop

## Output

After making changes, provide only a 1-3 sentence summary of what you changed.

$ARGUMENTS
