---
description: Execute an existing plan from .plans/
---

Execute the implementation plan.

Available plans (most recent first):
!`ls -1t .plans/*.md 2>/dev/null || echo "No plans found in .plans/"`

Most recent plan:
!`ls -1t .plans/*.md 2>/dev/null | head -1`

Plan to execute: $ARGUMENTS (if empty, use the most recent plan discussed with the user in the current session)

Plan contents:
!`if [ -n "$ARGUMENTS" ]; then cat .plans/$ARGUMENTS.md 2>/dev/null || cat .plans/$ARGUMENTS 2>/dev/null; else cat $(ls -1t .plans/*.md 2>/dev/null | head -1) 2>/dev/null; fi || echo "Plan not found."`

Instructions:

1. Read and understand the full plan
2. Execute each step in order
3. After each major step, verify it works (run tests, typecheck, lint, etc.)
4. **STOP and ask the user** if you encounter:
   - Unplanned circumstances or blockers
   - Decision points not covered by the plan
   - Conflicts or tradeoffs that need input
   - Anything that might significantly deviate from the plan
5. When writing tests, focus on HIGH-VALUE tests:
   - Integration tests that verify real behavior
   - Tests for edge cases and error conditions
   - Tests that would catch actual bugs
   - AVOID trivial unit tests (testing constructors, simple getters, 1+1=2 patterns)
6. Mark progress as you go

Begin implementation.
