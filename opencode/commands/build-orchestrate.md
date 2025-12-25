---
description: Execute a plan using subagents for parallel implementation
---

Execute the implementation plan using subagents to minimize main context usage.

Available plans (most recent first):
!`ls -1t .plans/*.md 2>/dev/null || echo "No plans found in .plans/"`

Plan to execute: $ARGUMENTS (if empty, use the most recent plan discussed with the user)

Plan contents:
!`if [ -n "$ARGUMENTS" ]; then cat .plans/$ARGUMENTS.md 2>/dev/null || cat .plans/$ARGUMENTS 2>/dev/null; else cat $(ls -1t .plans/*.md 2>/dev/null | head -1) 2>/dev/null; fi || echo "Plan not found."`

## Orchestration Strategy

You are the **orchestrator**. Balance direct implementation with subagent delegation to preserve context.

### What YOU Should Handle Directly

- **Core logic** - Complex algorithms, business rules, tricky edge cases
- **Architectural decisions** - Key abstractions, interfaces, type definitions
- **Integration points** - Wiring together what subagents produce
- **Review and fixes** - Correcting subagent output, resolving conflicts

### What to Delegate to Subagents

- **Boilerplate and plumbing** - Repetitive wiring, standard CRUD, route handlers
- **Refactoring** - Renaming, moving code, updating imports across files
- **Mechanical changes** - Adding fields to multiple structs, updating call sites
- **Tests** - Writing test cases (after you define the test strategy)
- **Documentation** - Updating docs to reflect changes

### Rules

1. **Delegate context-heavy work** - If a task touches many files but is mechanical, use a subagent
2. **Limit parallelism** - Run at most 2-3 subagents concurrently to avoid file conflicts
3. **Provide rich context** - Each subagent prompt must include:
   - The specific task/section to implement
   - Relevant file paths and their purposes
   - Any patterns or conventions to follow
   - Dependencies on other work (what's already done, what to expect)
   - Clear success criteria
4. **Sequence dependent work** - If task B depends on task A, wait for A to complete
5. **Verify between batches** - After each batch of subagents completes:
   - Run typecheck/build to catch integration issues early
   - Review any conflicts or inconsistencies
   - Adjust subsequent tasks if needed

### Execution Flow

1. **Analyze the plan** - Break it into independent work units
2. **Identify dependencies** - Which tasks must be sequential vs parallel
3. **Create a task graph** - Use the todo list to track:
   - Task groupings (which can run in parallel)
   - Dependencies between groups
   - Current status
4. **Dispatch in waves**:
   - Wave 1: Independent foundational work (types, interfaces, configs) - **you may write these directly**
   - Wave 2: Core implementations - **write critical logic yourself**, delegate plumbing
   - Wave 3: Integration, wiring, refactoring - **delegate to subagents**
   - Wave 4: Tests and verification - **delegate, review results**
5. **Verify after each wave** - Build/typecheck before proceeding
6. **Handle failures** - If a subagent fails or produces conflicts:
   - Assess the issue
   - Either dispatch a fix subagent or ask the user

### Subagent Prompt Template

When dispatching a subagent, structure the prompt like:

```
## Task
[Specific task description]

## Context
- This is part of: [overall feature]
- Related files: [list key files]
- Patterns to follow: [reference similar code]
- Already completed: [what other subagents have done]

## Requirements
- [Specific requirement 1]
- [Specific requirement 2]

## Files to Create/Modify
- `path/to/file.rs` - [what to do]

## Success Criteria
- [ ] [Criterion 1]
- [ ] [Criterion 2]

## Constraints
- Do NOT modify: [files being handled by other subagents]
- Follow existing patterns in: [reference files]
```

### Stopping Points

**STOP and ask the user** if you encounter:
- Subagent failures that aren't easily recoverable
- Architectural decisions not covered by the plan
- Conflicts between subagent outputs
- Build failures that suggest plan issues

Begin orchestration.
