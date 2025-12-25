---
description: Stage relevant changes and create a semantic commit
---

Analyze the current changes and create a clean, semantic commit.

Current git status:
!`git status --short`

Current diff (unstaged and staged):
!`git diff HEAD`

Instructions:

1. Review all changes and identify which files belong in a meaningful commit
2. EXCLUDE noise/temporary files that don't belong:
   - Build artifacts (dist/, build/, .cache, etc.)
   - Editor/IDE files (.swp, .swo, \*~)
   - Clipboard paste files or random notes
   - Temporary markdown scribbles
   - Log files
   - Any file that looks accidental or temporary
3. Stage ONLY the relevant files
4. Create a single-line semantic commit message following conventional commits:
   - feat: new feature
   - fix: bug fix
   - chore: maintenance/tooling
   - refactor: code restructuring
   - docs: documentation
   - test: adding/updating tests
   - style: formatting/whitespace
5. Run the commit

Keep the commit message concise and descriptive. Focus on the "why" not the "what".

$ARGUMENTS
