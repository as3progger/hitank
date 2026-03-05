---
name: honeybadger
description: Monitor errors, uptime and deployments on Honeybadger
user-invocable: true
argument-hint: [project name or ID]
---

# /honeybadger

Connect to Honeybadger to monitor errors, manage faults, track deployments and check uptime. Pure Ruby, zero gems — stdlib only.

## Structure

```
scripts/
├── auth.rb          # Basic Auth + hb_request helper (required by all scripts)
├── check_setup.rb   # Check if token exists (outputs OK or SETUP_NEEDED)
├── save_token.rb    # Save and validate a personal API token
├── projects.rb      # List all projects
├── faults.rb        # List faults for a project (with filters)
├── fault.rb         # Get fault details + recent notices
├── resolve.rb       # Resolve a fault
├── summary.rb       # Fault summary (counts by env/status)
├── deploys.rb       # List deployments for a project
├── sites.rb         # List uptime sites for a project
└── outages.rb       # List outages for an uptime site
```

## Setup (check before using)

```bash
ruby ~/.claude/skills/honeybadger/scripts/check_setup.rb
```

If the output is `OK`, proceed to the Flow section.

If the output is `SETUP_NEEDED`, guide the user step by step. Present ONE step at a time, wait for the user to confirm before moving to the next.

**Step 1** — Ask the user to get their personal API token:

> Open your Honeybadger profile page to find your personal API token:
> https://app.honeybadger.io/users/edit
>
> Scroll to **Authentication** and copy your **Personal Auth Token**.
> Paste the token here.

**Step 2** — When the user pastes the token, save it:

```bash
ruby ~/.claude/skills/honeybadger/scripts/save_token.rb 'PASTED_TOKEN'
```

If the script outputs an error, the token is invalid. Ask the user to double-check and try again.

**If setup is not complete, DO NOT proceed to the Flow. Complete all steps first.**

## Flow

The argument `$ARGUMENTS` may contain a project name or ID.

### Step 1: List projects

```bash
ruby ~/.claude/skills/honeybadger/scripts/projects.rb
```

Present the projects to the user. If `$ARGUMENTS` matches a project name, use that project. Otherwise ask which project to work with.

### Step 2: Show fault summary

```bash
ruby ~/.claude/skills/honeybadger/scripts/summary.rb PROJECT_ID
```

Present the summary and ask what the user wants to do.

### Step 3: Actions

**List faults:**
```bash
ruby ~/.claude/skills/honeybadger/scripts/faults.rb PROJECT_ID
```

With filters:
```bash
ruby ~/.claude/skills/honeybadger/scripts/faults.rb PROJECT_ID --env production
ruby ~/.claude/skills/honeybadger/scripts/faults.rb PROJECT_ID --resolved
```

**Get fault details:**
```bash
ruby ~/.claude/skills/honeybadger/scripts/fault.rb PROJECT_ID FAULT_ID
```

**Resolve a fault (requires user confirmation):**

Show the fault details first, then ask: "Do you want to resolve this fault?" Only execute after a "yes".

```bash
ruby ~/.claude/skills/honeybadger/scripts/resolve.rb PROJECT_ID FAULT_ID
```

**List deployments:**
```bash
ruby ~/.claude/skills/honeybadger/scripts/deploys.rb PROJECT_ID
```

**List uptime sites:**
```bash
ruby ~/.claude/skills/honeybadger/scripts/sites.rb PROJECT_ID
```

**List outages for a site:**
```bash
ruby ~/.claude/skills/honeybadger/scripts/outages.rb PROJECT_ID SITE_ID
```

## Notes

- **Pure Ruby, zero gems** — stdlib only (json, net/http, uri, fileutils)
- Auth via HTTP Basic Auth (personal token as username, no password)
- Token file: `~/.config/honeybadger/token` (outside the repo, never commit)
- Resolving a fault requires explicit user confirmation
- Base URL: `https://app.honeybadger.io/v2`
