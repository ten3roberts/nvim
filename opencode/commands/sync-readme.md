---
description: Update README to reflect changes since it was last modified
---

Update the README to reflect all changes since it was last modified.

Last commit that touched README:
!`git log -1 --format="%H %s" -- README.md`

README last modified commit hash:
!`git log -1 --format="%H" -- README.md`

All commits since README was last updated:
!`git log $(git log -1 --format="%H" -- README.md)..HEAD --oneline`

Files changed since README was last updated (grouped by directory):
!`git diff $(git log -1 --format="%H" -- README.md)..HEAD --stat -- . ':!README.md'`

Current README content:
!`cat README.md`

Instructions:

1. First, identify which modules/packages/directories have significant changes based on the file stats above

2. For each module with significant changes, spawn an explore subagent (using the Task tool) to analyze that module's changes. Run these in PARALLEL to save time. Each subagent should:
   - Review the diff for that module: `git diff $(git log -1 --format="%H" -- README.md)..HEAD -- <module-path>`
   - Understand what was added, modified, or removed
   - Summarize the architectural or feature-level impact
   - Note any new APIs, patterns, or dependencies
   - Return a concise summary (not the raw diff)

3. Wait for all subagent results to come back

4. Synthesize the findings and update the README to accurately reflect the current state:
   - Add new sections for new features/modules
   - Update existing sections that are now outdated
   - Remove documentation for removed features
   - Keep the existing style and structure

5. Don't bloat the README - keep it concise and useful

$ARGUMENTS
