---
name: clickup
description: Manage ClickUp tasks, lists, spaces, time tracking and comments via REST API
user-invocable: true
argument-hint: [task name or workspace]
---

# /clickup

Connect to ClickUp to manage workspaces, tasks, time tracking, comments and more. Pure Ruby, zero gems — stdlib only.

## Structure

```
scripts/
├── auth.rb          # Token auth + clickup_request helper (required by all scripts)
├── check_setup.rb   # Check if token exists (outputs OK or SETUP_NEEDED)
├── save_token.rb    # Save and validate a personal API token
├── teams.rb         # List workspaces (teams)
├── spaces.rb        # List spaces in a workspace
├── folders.rb       # List folders in a space
├── lists.rb         # List lists in a folder or space
├── tasks.rb         # List tasks in a list (with pagination)
├── task.rb          # Get task details
├── search_tasks.rb  # Search tasks by name across a workspace
├── create_task.rb   # Create a task
├── update_task.rb   # Update a task
├── delete_task.rb   # Delete a task
├── comments.rb      # List comments on a task
├── add_comment.rb   # Add a comment to a task
├── time_entries.rb  # List time entries
├── start_timer.rb   # Start a timer for a task
├── stop_timer.rb    # Stop the running timer
└── tags.rb          # List tags in a space
```

## ClickUp Hierarchy

```
Workspace (Team) → Space → Folder (optional) → List → Task → Subtask
```

In API v2, "Team" = Workspace and "Project" = Folder.

## Setup (check before using)

```bash
ruby ~/.claude/skills/clickup/scripts/check_setup.rb
```

If the output is `OK`, proceed to the Flow section.

If the output is `SETUP_NEEDED`, guide the user step by step. Present ONE step at a time, wait for the user to confirm before moving to the next.

**Step 1** — Ask the user to get their personal API token:

> Go to **ClickUp > Settings > Apps > API Token** and generate a personal token.
> Or open: https://app.clickup.com/settings/apps
>
> Copy the token and paste it here.

**Step 2** — When the user pastes the token, save it:

```bash
ruby ~/.claude/skills/clickup/scripts/save_token.rb 'PASTED_TOKEN'
```

If the script outputs an error, the token is invalid. Ask the user to double-check and try again.

**If setup is not complete, DO NOT proceed to the Flow. Complete all steps first.**

## Flow

The argument `$ARGUMENTS` may contain a task name or workspace reference.

### Step 1: List workspaces

```bash
ruby ~/.claude/skills/clickup/scripts/teams.rb
```

Present the workspaces. If there is only one, use it automatically. Otherwise ask which workspace to work with.

### Step 2: Discover hierarchy

```bash
ruby ~/.claude/skills/clickup/scripts/spaces.rb TEAM_ID
```

Then drill into spaces, folders, and lists as needed:

```bash
ruby ~/.claude/skills/clickup/scripts/folders.rb SPACE_ID
ruby ~/.claude/skills/clickup/scripts/lists.rb FOLDER_ID
ruby ~/.claude/skills/clickup/scripts/lists.rb SPACE_ID --space
```

### Step 3: Actions

**List tasks in a list:**
```bash
ruby ~/.claude/skills/clickup/scripts/tasks.rb LIST_ID
ruby ~/.claude/skills/clickup/scripts/tasks.rb LIST_ID --page 1
ruby ~/.claude/skills/clickup/scripts/tasks.rb LIST_ID --include-closed
```

**Get task details:**
```bash
ruby ~/.claude/skills/clickup/scripts/task.rb TASK_ID
```

**Search tasks by name:**
```bash
ruby ~/.claude/skills/clickup/scripts/search_tasks.rb TEAM_ID "search query"
ruby ~/.claude/skills/clickup/scripts/search_tasks.rb TEAM_ID "query" --include-closed
```

**Create a task (requires user confirmation):**

Ask the user to confirm the task name, list, and details before creating.

```bash
ruby ~/.claude/skills/clickup/scripts/create_task.rb LIST_ID "Task Name"
ruby ~/.claude/skills/clickup/scripts/create_task.rb LIST_ID "Task Name" --description "Details" --status "to do" --priority 3
```

Priority: 1=Urgent, 2=High, 3=Normal, 4=Low

**Update a task (requires user confirmation):**

Show current task details first, then ask what to change.

```bash
ruby ~/.claude/skills/clickup/scripts/update_task.rb TASK_ID '{"status":"in progress","priority":2}'
```

**Delete a task (requires user confirmation):**

Show the task details first, then ask: "Do you want to delete this task?" Only execute after a "yes".

```bash
ruby ~/.claude/skills/clickup/scripts/delete_task.rb TASK_ID
```

**List comments:**
```bash
ruby ~/.claude/skills/clickup/scripts/comments.rb TASK_ID
```

**Add a comment (requires user confirmation):**

Show the comment text first, then ask to confirm.

```bash
ruby ~/.claude/skills/clickup/scripts/add_comment.rb TASK_ID "Comment text here"
```

**List time entries:**
```bash
ruby ~/.claude/skills/clickup/scripts/time_entries.rb TEAM_ID
ruby ~/.claude/skills/clickup/scripts/time_entries.rb TEAM_ID --start 1700000000000 --end 1710000000000
```

**Start a timer (requires user confirmation):**
```bash
ruby ~/.claude/skills/clickup/scripts/start_timer.rb TEAM_ID TASK_ID
```

**Stop a timer:**
```bash
ruby ~/.claude/skills/clickup/scripts/stop_timer.rb TEAM_ID
```

**List tags:**
```bash
ruby ~/.claude/skills/clickup/scripts/tags.rb SPACE_ID
```

## Notes

- **Pure Ruby, zero gems** — stdlib only (json, net/http, uri, fileutils)
- Auth via personal API token (no Bearer prefix — ClickUp uses the raw token)
- Token file: `~/.config/clickup/token` (outside the repo, never commit)
- Creating, updating, and deleting tasks require explicit user confirmation
- Adding comments and starting timers require user confirmation
- Timestamps are in **milliseconds** (Unix epoch x 1000)
- Pagination: max 100 tasks per page, use `--page N` (0-indexed)
- Rate limit: 100 requests/minute per token
- Base URL: `https://api.clickup.com/api/v2`
