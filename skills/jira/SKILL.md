---
name: jira
description: Manage Jira issues, projects, sprints and boards via REST API
user-invocable: true
argument-hint: [project key or issue key]
---

# /jira

Connect to Jira Cloud to manage projects, issues, sprints, boards and more. Pure Ruby, zero gems — stdlib only.

## Structure

```
scripts/
├── auth.rb          # Basic Auth + jira_request helper (required by all scripts)
├── check_setup.rb   # Check if config exists (outputs OK or SETUP_NEEDED)
├── save_config.rb   # Save and validate domain, email and API token
├── projects.rb      # List projects
├── project.rb       # Get project details
├── issues.rb        # Search issues using JQL
├── issue.rb         # Get issue details
├── create_issue.rb  # Create an issue
├── update_issue.rb  # Update an issue
├── transitions.rb   # List available transitions for an issue
├── transition.rb    # Transition an issue (change status)
├── comments.rb      # List comments on an issue
├── add_comment.rb   # Add a comment to an issue
├── assign.rb        # Assign an issue to a user
├── boards.rb        # List boards (Agile)
└── sprints.rb       # List sprints for a board
```

## Setup (check before using)

```bash
ruby ~/.claude/skills/jira/scripts/check_setup.rb
```

If the output is `OK`, proceed to the Flow section.

If the output is `SETUP_NEEDED`, guide the user step by step. Present ONE step at a time, wait for the user to confirm before moving to the next.

**Step 1** — Ask the user for their Jira domain:

> What is your Jira Cloud domain?
> For example, if you access Jira at `https://mycompany.atlassian.net`, the domain is `mycompany`.

**Step 2** — Ask the user to create an API token:

> Create an API token at:
> https://id.atlassian.com/manage-profile/security/api-tokens
>
> Click **Create API token**, give it a name (e.g. "hitank"), and copy the token.
> Also confirm your Atlassian account email.
>
> Paste the email and token here.

**Step 3** — When the user provides all three values, save them:

```bash
ruby ~/.claude/skills/jira/scripts/save_config.rb 'DOMAIN' 'EMAIL' 'TOKEN'
```

If the script outputs an error, the config is invalid. Ask the user to double-check and try again.

**If setup is not complete, DO NOT proceed to the Flow. Complete all steps first.**

## Flow

The argument `$ARGUMENTS` may contain a project key or issue key.

### Step 1: List projects

```bash
ruby ~/.claude/skills/jira/scripts/projects.rb
```

Present the projects. If `$ARGUMENTS` matches a project key, use that project. Otherwise ask which project to work with.

### Step 2: Search issues

```bash
ruby ~/.claude/skills/jira/scripts/issues.rb 'project = PROJECT_KEY ORDER BY updated DESC'
```

Present the issues and ask what the user wants to do.

### Step 3: Actions

**Get issue details:**
```bash
ruby ~/.claude/skills/jira/scripts/issue.rb ISSUE_KEY
```

**Search with JQL:**
```bash
ruby ~/.claude/skills/jira/scripts/issues.rb 'project = MYPROJ AND status = "In Progress"'
ruby ~/.claude/skills/jira/scripts/issues.rb 'assignee = currentUser() ORDER BY priority DESC' --max 50
```

**Create an issue (requires user confirmation):**

Ask the user to confirm the details before creating.

```bash
ruby ~/.claude/skills/jira/scripts/create_issue.rb PROJECT_KEY "Issue summary"
ruby ~/.claude/skills/jira/scripts/create_issue.rb PROJECT_KEY "Fix login bug" --type Bug --priority High --description "Detailed description"
```

**Update an issue (requires user confirmation):**

Show current issue details first, then ask what to change.

```bash
ruby ~/.claude/skills/jira/scripts/update_issue.rb ISSUE_KEY '{"summary":"New title","priority":{"name":"High"}}'
```

**Transition an issue (requires user confirmation):**

First list available transitions, then ask which one to apply.

```bash
ruby ~/.claude/skills/jira/scripts/transitions.rb ISSUE_KEY
ruby ~/.claude/skills/jira/scripts/transition.rb ISSUE_KEY TRANSITION_ID
```

**Assign an issue (requires user confirmation):**
```bash
ruby ~/.claude/skills/jira/scripts/assign.rb ISSUE_KEY ACCOUNT_ID
ruby ~/.claude/skills/jira/scripts/assign.rb ISSUE_KEY unassign
```

**List comments:**
```bash
ruby ~/.claude/skills/jira/scripts/comments.rb ISSUE_KEY
```

**Add a comment (requires user confirmation):**
```bash
ruby ~/.claude/skills/jira/scripts/add_comment.rb ISSUE_KEY "Comment text here"
```

**List boards (Agile):**
```bash
ruby ~/.claude/skills/jira/scripts/boards.rb
```

**List sprints:**
```bash
ruby ~/.claude/skills/jira/scripts/sprints.rb BOARD_ID
ruby ~/.claude/skills/jira/scripts/sprints.rb BOARD_ID --state active
```

## Notes

- **Pure Ruby, zero gems** — stdlib only (json, net/http, uri, base64, fileutils)
- Auth via Basic Auth (email + API token)
- Config file: `~/.config/jira/config.json` (outside the repo, never commit)
- Creating, updating, transitioning, and assigning issues require explicit user confirmation
- Adding comments requires user confirmation
- Jira Cloud API v3 uses Atlassian Document Format (ADF) for descriptions and comments
- JQL (Jira Query Language) is used for searching issues
- Base URL: `https://DOMAIN.atlassian.net/rest/api/3`
- Agile URL: `https://DOMAIN.atlassian.net/rest/agile/1.0`
