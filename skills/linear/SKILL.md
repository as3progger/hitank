---
name: linear
description: Manage Linear issues, projects, teams, cycles and labels via GraphQL API
user-invocable: true
argument-hint: [action or issue identifier]
---

# /linear

Connect to Linear to manage issues, projects, teams, cycles, labels and search. Pure Ruby, zero gems — stdlib only.

## Structure

```
scripts/
├── auth.rb              # Bearer token auth + linear_query helper (required by all scripts)
├── check_setup.rb       # Check if token exists (outputs OK or SETUP_NEEDED)
├── save_token.rb        # Save and validate an API key
├── issues.rb            # List issues
├── issue.rb             # Get issue details
├── create_issue.rb      # Create an issue
├── update_issue.rb      # Update an issue
├── projects.rb          # List projects
├── project.rb           # Get project details
├── teams.rb             # List teams
├── cycles.rb            # List cycles
├── labels.rb            # List labels
├── search.rb            # Search issues
├── comments.rb          # List comments on an issue
└── create_comment.rb    # Create a comment on an issue
```

## Setup (check before using)

```bash
ruby ~/.claude/skills/linear/scripts/check_setup.rb
```

If the output is `OK`, proceed to the Flow section.

If the output is `SETUP_NEEDED`, guide the user step by step. Present ONE step at a time, wait for the user to confirm before moving to the next.

**Step 1** — Ask the user to get their API key:

> You need a Linear Personal API key.
>
> 1. Go to https://linear.app/settings/api
> 2. Under **Personal API keys**, click **Create key**
> 3. Give it a label (e.g. "hitank")
> 4. Copy the key (starts with `lin_api_`)
>
> Paste the API key here.

**Step 2** — When the user pastes the key, save it:

```bash
ruby ~/.claude/skills/linear/scripts/save_token.rb 'PASTED_KEY'
```

If the script outputs an error, the key is invalid. Ask the user to double-check and try again.

**If setup is not complete, DO NOT proceed to the Flow. Complete all steps first.**

## Flow

The argument `$ARGUMENTS` may contain an action or issue identifier.

### Step 1: List teams

```bash
ruby ~/.claude/skills/linear/scripts/teams.rb
```

Present the teams. If `$ARGUMENTS` matches a team key or issue identifier, use that context. Otherwise ask which team to work with.

### Step 2: List issues

```bash
ruby ~/.claude/skills/linear/scripts/issues.rb --team TEAM_KEY
```

Present the issues and ask what the user wants to do.

### Step 3: Actions

**Get issue details:**
```bash
ruby ~/.claude/skills/linear/scripts/issue.rb ISSUE_ID
```

**Search issues:**
```bash
ruby ~/.claude/skills/linear/scripts/search.rb "search term"
```

**List issues with filters:**
```bash
ruby ~/.claude/skills/linear/scripts/issues.rb --team ENG --state "In Progress" --limit 20
```

**Create an issue (requires user confirmation):**

Ask the user to confirm the details before creating.

```bash
ruby ~/.claude/skills/linear/scripts/create_issue.rb TEAM_ID "Issue title"
ruby ~/.claude/skills/linear/scripts/create_issue.rb TEAM_ID "Fix login bug" --description "Detailed description" --priority 1 --assignee USER_ID
```

**Update an issue (requires user confirmation):**

Show current issue details first, then ask what to change.

```bash
ruby ~/.claude/skills/linear/scripts/update_issue.rb ISSUE_ID --title "New title"
ruby ~/.claude/skills/linear/scripts/update_issue.rb ISSUE_ID --priority 2 --state STATE_ID --assignee USER_ID
```

**List projects:**
```bash
ruby ~/.claude/skills/linear/scripts/projects.rb
ruby ~/.claude/skills/linear/scripts/projects.rb --limit 10
```

**Get project details:**
```bash
ruby ~/.claude/skills/linear/scripts/project.rb PROJECT_ID
```

**List cycles:**
```bash
ruby ~/.claude/skills/linear/scripts/cycles.rb
ruby ~/.claude/skills/linear/scripts/cycles.rb --team TEAM_ID
```

**List labels:**
```bash
ruby ~/.claude/skills/linear/scripts/labels.rb
ruby ~/.claude/skills/linear/scripts/labels.rb --team TEAM_ID
```

**List comments:**
```bash
ruby ~/.claude/skills/linear/scripts/comments.rb ISSUE_ID
```

**Create a comment (requires user confirmation):**
```bash
ruby ~/.claude/skills/linear/scripts/create_comment.rb ISSUE_ID "Comment text here"
```

## Notes

- **Pure Ruby, zero gems** — stdlib only (json, net/http, uri, fileutils)
- Auth via Bearer token (Personal API key starting with `lin_api_`)
- Linear uses the token directly as the Authorization header value (no "Bearer " prefix needed)
- Token file: `~/.config/linear/token` (outside the repo, never commit)
- All queries use the GraphQL API at `https://api.linear.app/graphql`
- Creating issues, updating issues, and adding comments require explicit user confirmation
- Priority values: 0 (No priority), 1 (Urgent), 2 (High), 3 (Medium), 4 (Low)
