---
description: Create a detailed implementation plan for a feature
---

Create a detailed implementation plan. Wait for the user to describe what they want to build.

When the user describes their goal:

1. **Create the plan file immediately** - Create `.plans/$ARGUMENTS.md` (or generate a suitable kebab-case name) right away with:
   - Title and goal summary
   - Status: "Exploring codebase"
   - Empty sections for: Codebase Context, Questions, Decisions, Tasks, Files, Testing, Risks

   Update this file incrementally as you learn more. Do NOT hold the plan in context only.

2. **FIRST: Deep dive into the codebase** - Before asking ANY questions, you MUST thoroughly explore the codebase using explore subagents. Launch multiple explore agents in parallel to understand:

   **Required explorations (launch these in parallel):**
   - **Architecture exploration**: "What is the overall architecture? Find the main entry points, how components are organized, and the data flow patterns used."
   - **Relevant feature exploration**: "Find existing code related to [user's feature area]. How are similar features implemented? What patterns are used?"
   - **UI/Component exploration** (if UI-related): "What UI framework and component patterns are used? Find existing components similar to what we need."
   - **Data layer exploration**: "How is data stored and accessed? Find the data models, API endpoints, and state management patterns relevant to [feature]."
   - **Testing exploration**: "How are tests structured? Find examples of tests for similar features."

   **CRITICAL**: Do NOT skip this step. Do NOT ask generic high-level questions without first understanding the codebase. Your questions should be informed by what you discovered during exploration.

   **Update the plan file** with a "Codebase Context" section summarizing:
   - Relevant existing files and their purposes
   - Patterns and conventions the codebase uses
   - Integration points you discovered
   - Potential reusable components or utilities

3. **Ask INFORMED clarifying questions** - Now that you understand the codebase, ask specific questions grounded in what you found:
   - Reference specific files, components, or patterns you discovered
   - Ask about choices between approaches you identified in the codebase
   - Clarify integration with specific existing systems you found
   - Ask about edge cases relevant to the actual architecture

   **Bad example (generic, uninformed):**
   > "Where should live feedback appear in the UI?"

   **Good example (informed by exploration):**
   > "I found the workflow editor uses React Flow in `src/components/WorkflowEditor/`. The existing node components in `src/components/nodes/` have a status indicator pattern. Should we extend this pattern for execution feedback, or add a separate ExecutionOverlay component?"

   After your question prose, include a footer with checkboxes.

4. **Present findings and tradeoffs** - Share what you learned and discuss:
   - Multiple approaches based on existing codebase patterns
   - Pros/cons of each, referencing actual code
   - Get user input on direction

   **Update the plan file** with decisions made.

5. **Finalize the plan** - Update `.plans/` file with:
   - Status: "Ready for implementation"
   - Step-by-step implementation tasks
   - Specific files to create/modify (with paths)
   - Testing strategy (focus on high-value integration/behavior tests, NOT trivial unit tests)
   - Potential risks or edge cases

6. **Review with user** - Walk through the plan and refine until they approve

Do NOT make any code changes. This is planning only.
The plan file should always reflect current state - if context is lost, the file remains.
