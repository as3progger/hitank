---
name: slack
description: Manage Slack channels, messages, users, reactions and files via Bot API
user-invocable: true
argument-hint: [action or channel name]
---

# /slack

Connect to Slack to manage channels, send messages, browse history, list users, add reactions, pin messages, upload files and search across your workspace. Pure Ruby, zero gems — stdlib only.

## Structure

```
scripts/
├── auth.rb            # Bearer token auth + slack_request helper (required by all scripts)
├── check_setup.rb     # Check if token exists (outputs OK or SETUP_NEEDED)
├── save_token.rb      # Save and validate a Bot token
├── channels.rb        # List channels in the workspace
├── channel_info.rb    # Get info about a channel
├── post_message.rb    # Post a message to a channel
├── messages.rb        # Get message history for a channel
├── users.rb           # List users in the workspace
├── user_info.rb       # Get info about a user
├── add_reaction.rb    # Add a reaction to a message
├── remove_reaction.rb # Remove a reaction from a message
├── pins.rb            # List pinned messages in a channel
├── pin_message.rb     # Pin a message in a channel
├── upload_file.rb     # Upload file content to a channel
└── search_messages.rb # Search messages across the workspace
```

## Setup (check before using)

```bash
ruby ~/.claude/skills/slack/scripts/check_setup.rb
```

If the output is `OK`, proceed to the Flow section.

If the output is `SETUP_NEEDED`, guide the user step by step. Present ONE step at a time, wait for the user to confirm before moving to the next.

**Step 1** — Ask the user to create a Slack app and get the Bot token:

> You need a Slack Bot User OAuth Token. Go to the Slack API portal:
> https://api.slack.com/apps
>
> 1. Click **Create New App** > **From scratch**, give it a name and select your workspace
> 2. Go to **OAuth & Permissions** in the left menu
> 3. Under **Bot Token Scopes**, add the following scopes:
>    - `channels:read`
>    - `channels:history`
>    - `chat:write`
>    - `users:read`
>    - `reactions:write`
>    - `pins:write`
>    - `files:write`
>    - `search:read`
> 4. Click **Install to Workspace** at the top and authorize
> 5. Copy the **Bot User OAuth Token** (starts with `xoxb-`)
>
> Paste the bot token here.

**Step 2** — When the user pastes the token, save it:

```bash
ruby ~/.claude/skills/slack/scripts/save_token.rb 'PASTED_TOKEN'
```

If the script outputs an error, the token is invalid. Ask the user to double-check and try again.

**If setup is not complete, DO NOT proceed to the Flow. Complete all steps first.**

## Flow

The argument `$ARGUMENTS` may contain a channel name or action reference.

### Step 1: List channels

```bash
ruby ~/.claude/skills/slack/scripts/channels.rb
ruby ~/.claude/skills/slack/scripts/channels.rb --limit 50
ruby ~/.claude/skills/slack/scripts/channels.rb --types public_channel,private_channel
```

Present the channels. Ask which channel to work with if needed.

### Step 2: Actions

**Get channel info:**
```bash
ruby ~/.claude/skills/slack/scripts/channel_info.rb CHANNEL_ID
```

**Read messages:**
```bash
ruby ~/.claude/skills/slack/scripts/messages.rb CHANNEL_ID
ruby ~/.claude/skills/slack/scripts/messages.rb CHANNEL_ID --limit 50
```

**Post a message (requires user confirmation):**

Show the message content first, then ask to confirm before sending.

```bash
ruby ~/.claude/skills/slack/scripts/post_message.rb CHANNEL_ID "Hello from HiTank!"
```

**List users:**
```bash
ruby ~/.claude/skills/slack/scripts/users.rb
ruby ~/.claude/skills/slack/scripts/users.rb --limit 50
```

**Get user info:**
```bash
ruby ~/.claude/skills/slack/scripts/user_info.rb USER_ID
```

**Add a reaction (requires user confirmation):**
```bash
ruby ~/.claude/skills/slack/scripts/add_reaction.rb CHANNEL_ID TIMESTAMP thumbsup
```

**Remove a reaction (requires user confirmation):**
```bash
ruby ~/.claude/skills/slack/scripts/remove_reaction.rb CHANNEL_ID TIMESTAMP thumbsup
```

**List pinned messages:**
```bash
ruby ~/.claude/skills/slack/scripts/pins.rb CHANNEL_ID
```

**Pin a message (requires user confirmation):**
```bash
ruby ~/.claude/skills/slack/scripts/pin_message.rb CHANNEL_ID TIMESTAMP
```

**Upload a file (requires user confirmation):**
```bash
ruby ~/.claude/skills/slack/scripts/upload_file.rb CHANNEL_ID "file content here" --filename notes.txt --title "My Notes"
```

**Search messages:**
```bash
ruby ~/.claude/skills/slack/scripts/search_messages.rb "search query"
ruby ~/.claude/skills/slack/scripts/search_messages.rb "search query" --count 10
```

## Notes

- **Pure Ruby, zero gems** — stdlib only (json, net/http, uri, fileutils)
- Auth via Bot User OAuth Token (`Authorization: Bearer xoxb-...`)
- Token file: `~/.config/slack/token` (outside the repo, never commit)
- Posting messages, adding/removing reactions, pinning, and uploading files require explicit user confirmation
- Mention users as `<@USER_ID>` in message content
- Slack API returns `{"ok": true/false}` — all scripts check `data['ok']` and output errors
- The `search:read` scope is required for search_messages.rb
- Base URL: `https://slack.com/api`
