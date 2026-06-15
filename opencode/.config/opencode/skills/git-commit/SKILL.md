---
name: git-commit
description: Create consistent git commits
compatibility: opencode
command: git-commit
---

## What I do

- Analyze staged git changes
- Determine the type of commit based on the changes. The commit type can be one of the following:
  - feat: A new feature
  - fix: A bug fix
  - docs: Documentation changes
  - style: Code style changes (formatting, missing semi-colons, etc.)
  - refactor: Code refactoring without adding features or fixing bugs
  - test: Adding or updating tests
  - chore: Changes to the build process or auxiliary tools and libraries such as documentation generation
  - dep: Updates to dependencies
  - update: General updates that don't fit into the above categories
- Write a short (< 50 characters) concise commit message
- Write a longer description of the commit if necessary, explaining the reasoning behind the changes and any relevant details
- Format the commit message according to the conventional commit format: `<type>: <short message>\n\n<long description>`
- Present the commit message to the user for review and allow them to make edits if necessary
- Commit the changes

## When to use me

Use this when asked to commit changes to git
If the staged changes are unclear, ask the user
If no changes are staged, inform the user and stop
