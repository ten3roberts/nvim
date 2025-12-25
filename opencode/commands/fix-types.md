---
description: Run typecheck and fix all type errors
---

Run TypeScript type checking and fix all reported errors.

Type check output:
!`npm run typecheck 2>&1 || pnpm typecheck 2>&1 || tsc --noEmit 2>&1 || true`

Fix each type error. Prefer proper typing over using `any`. Follow existing type patterns in the codebase.

$ARGUMENTS
