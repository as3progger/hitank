---
name: rewrite
description: Send SMS messages, manage templates, webhooks and API keys via Rewrite API
user-invocable: true
argument-hint: [action or phone number]
---

# /rewrite

Connect to Rewrite to send SMS messages, manage templates, webhooks and API keys. Pure Ruby, zero gems — stdlib only.

## Structure

```
scripts/
├── auth.rb              # Bearer token auth + rewrite_request helper (required by all scripts)
├── check_setup.rb       # Check if token exists (outputs OK or SETUP_NEEDED)
├── save_token.rb        # Save and validate an API token
├── send_message.rb      # Send an SMS message
├── templates.rb         # List templates for a project
├── template.rb          # Get template details
├── create_template.rb   # Create a message template
├── update_template.rb   # Update a template
├── delete_template.rb   # Delete a template
├── webhooks.rb          # List webhooks for a project
├── create_webhook.rb    # Create a webhook
├── update_webhook.rb    # Update a webhook
├── delete_webhook.rb    # Delete a webhook
├── api_keys.rb          # List API keys for a project
├── create_api_key.rb    # Create an API key
├── delete_api_key.rb    # Delete an API key
├── update_project.rb    # Update project settings
└── delete_project.rb    # Delete a project
```

## Setup (check before using)

```bash
ruby ~/.claude/skills/rewrite/scripts/check_setup.rb
```

If the output is `OK`, proceed to the Flow section.

If the output is `SETUP_NEEDED`, guide the user step by step. Present ONE step at a time, wait for the user to confirm before moving to the next.

**Step 1** — Ask the user to get their API token:

> You need a Rewrite API token.
>
> 1. Go to https://app.rewritetoday.com and log in
> 2. Go to your project settings
> 3. Create or copy an API key (starts with `rw_`)
>
> Paste the token here.

**Step 2** — When the user pastes the token, save it:

```bash
ruby ~/.claude/skills/rewrite/scripts/save_token.rb 'PASTED_TOKEN'
```

If the script outputs an error, the token is invalid. Ask the user to double-check and try again.

**If setup is not complete, DO NOT proceed to the Flow. Complete all steps first.**

## Flow

The argument `$ARGUMENTS` may contain an action or phone number.

### Step 1: Send a message

If the user wants to send an SMS:

```bash
ruby ~/.claude/skills/rewrite/scripts/send_message.rb "+5511999999999" "Hello from Rewrite!"
```

With metadata:
```bash
ruby ~/.claude/skills/rewrite/scripts/send_message.rb "+5511999999999" "Hi" --metadata campaign=welcome source=api
```

### Step 2: Templates

**List templates:**
```bash
ruby ~/.claude/skills/rewrite/scripts/templates.rb PROJECT_ID
```

**Get template details:**
```bash
ruby ~/.claude/skills/rewrite/scripts/template.rb PROJECT_ID TEMPLATE_ID
```

**Create a template (requires user confirmation):**
```bash
ruby ~/.claude/skills/rewrite/scripts/create_template.rb PROJECT_ID "welcome" "Hello {{name}}, welcome!"
```

**Update a template (requires user confirmation):**
```bash
ruby ~/.claude/skills/rewrite/scripts/update_template.rb PROJECT_ID TEMPLATE_ID --name "new-name" --content "New content"
```

**Delete a template (requires user confirmation):**
```bash
ruby ~/.claude/skills/rewrite/scripts/delete_template.rb PROJECT_ID TEMPLATE_ID
```

### Step 3: Webhooks

**List webhooks:**
```bash
ruby ~/.claude/skills/rewrite/scripts/webhooks.rb PROJECT_ID
```

**Create a webhook (requires user confirmation):**
```bash
ruby ~/.claude/skills/rewrite/scripts/create_webhook.rb PROJECT_ID "https://example.com/hook" sms.delivered sms.failed
```

Available events: `sms.queued`, `sms.delivered`, `sms.failed`, `sms.scheduled`, `sms.canceled`

**Update a webhook (requires user confirmation):**
```bash
ruby ~/.claude/skills/rewrite/scripts/update_webhook.rb PROJECT_ID WEBHOOK_ID --url "https://new.url/hook" --events "sms.delivered,sms.failed"
```

**Delete a webhook (requires user confirmation):**
```bash
ruby ~/.claude/skills/rewrite/scripts/delete_webhook.rb PROJECT_ID WEBHOOK_ID
```

### Step 4: API Keys

**List API keys:**
```bash
ruby ~/.claude/skills/rewrite/scripts/api_keys.rb PROJECT_ID
```

**Create an API key (requires user confirmation):**
```bash
ruby ~/.claude/skills/rewrite/scripts/create_api_key.rb PROJECT_ID "my-key-name"
```

**Delete an API key (requires user confirmation):**
```bash
ruby ~/.claude/skills/rewrite/scripts/delete_api_key.rb PROJECT_ID API_KEY
```

### Step 5: Project Management

**Update project (requires user confirmation):**
```bash
ruby ~/.claude/skills/rewrite/scripts/update_project.rb PROJECT_ID --name "New Project Name"
```

**Delete project (requires user confirmation):**
```bash
ruby ~/.claude/skills/rewrite/scripts/delete_project.rb PROJECT_ID
```

## Notes

- **Pure Ruby, zero gems** — stdlib only (json, net/http, uri, fileutils)
- Auth via Bearer token (API key starting with `rw_`)
- Token file: `~/.config/rewrite/token` (outside the repo, never commit)
- Sending messages, creating/updating/deleting templates, webhooks, API keys and projects require explicit user confirmation
- Webhook events: sms.queued, sms.delivered, sms.failed, sms.scheduled, sms.canceled
- Templates support variables with `{{variable}}` syntax
- Cursor-based pagination: use `--limit N` and `--after CURSOR` on list endpoints
- Base URL: `https://api.rewritetoday.com/v1`
