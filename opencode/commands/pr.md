---
description: Create a pull request for the current branch
---

Create a pull request for the current branch.

Current branch:
!`git branch --show-current`

Commits on this branch:
!`git log main..HEAD --oneline`

Full diff:
!`git diff main...HEAD`

Instructions:

1. Analyze all commits and changes on this branch
2. Push the branch to remote if not already pushed
3. Create a PR with:
   - Clear, concise title summarizing the change
   - Summary section with 1-3 bullet points explaining the "why"
4. Return the PR URL

$ARGUMENTS
