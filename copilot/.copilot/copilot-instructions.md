## Workflow orchestration

### 1. Plan mode default

- enter plan mode for ANY non-trivial task (3+ steps or architectural decisions)
- if something goes sideways, STOP immediatly and re-plan - don't keep pushing
- Use plan mode for verification steps, not just building
- Write detailed specs upfront to reduce ambiguity
- Any plan implemented must end with a review to be approved by the human controller before being considered done

### 2. Subagent Strategy to keep main context window clean

- Offload research, exploration, parallel analysis and post-analysis jobs to subagents when they are available
- One task per subagent for focused execution

### 3. Self-Improvement loop

- After ANY correction from the user: update 'tasks/lessons.md' with the pattern
- Write rules for yourself that prevent the same mistake
- Ruthlessly iterate on these rules until mistake rate drops
- Review lessons at session start for relevant project

### 4. Verification Before Done

- Never mark a task complete without proving it works
- Diff behaviour between main and your changes when relevant
- Ask yourself: "Would a staff engineer approve this?"
- Run tests, check logs, demonstrate correctness
- Any function or method added must include a full set of unit tests

### 5. Demande Elegance

- For non-trivial changes: pause and ask "is there a more elegant way?"
- If a fix feels hacky: "Knowing everything I know now, implement the most elegant solution"
- Skip this for simple, obvious fixes -- don't over-engineer
- Challenge your own work before presenting it
- Always try to refactor at least once (maximum 3 times) before presenting something as the final result

### 6. Autonomous bug fixing

- When given a bug report, just fix it -- don't ask for permission or hand-holding
- When a bug is fix, give an explanation of the cause and the resolution
- Point at logs, errors, failing tests -> then resolve them
- Zero context switching required for user
- Go fix failing CI tests without being told how

## Task management

1. **Plan First**: Write a plan to tasks/todo.md with checkable items
2. **Verify Plan**: Check in before starting implementation
3. **Track Progress**: Mark items completed as you go
4. **Explain Changes**: High-level summary of each step
5. **Document Results**: Add review to 'tasks/todo.md'
6. **Capture Lessons**: Update 'tasks/lessons.md' after corrections

## Project Identification

- If the project contains requirements.txt, the project type is python
- If the project contains package.json, the project type is typescript
- If neither of the above conditions match, the project type is generic

## Global rules

- always use pnpm for typescript projects
- before installing dependencies in python projects, ensure that there is a virtual environment active, preferably in .venv
- create the virtual environment in .venv for python projects if it doesn't exist
