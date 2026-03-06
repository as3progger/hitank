---
name: flyio
description: Manage Fly.io apps, machines, volumes and certificates via Machines API
user-invocable: true
argument-hint: [app name or machine]
---

# /flyio

Connect to the Fly.io Machines API to manage apps, machines, volumes, certificates and more. Pure Ruby, zero gems — stdlib only.

## Structure

```
scripts/
├── auth.rb              # Bearer token auth + flyio_request helper (required by all scripts)
├── check_setup.rb       # Check if token exists (outputs OK or SETUP_NEEDED)
├── save_token.rb        # Save and validate an API token
├── apps.rb              # List apps in an organization
├── app.rb               # Get app details
├── create_app.rb        # Create a new app
├── delete_app.rb        # Delete an app
├── machines.rb          # List machines for an app
├── machine.rb           # Get machine details
├── create_machine.rb    # Create a new machine
├── update_machine.rb    # Update machine configuration
├── start_machine.rb     # Start a stopped machine
├── stop_machine.rb      # Stop a running machine
├── delete_machine.rb    # Delete a machine
├── machine_wait.rb      # Wait for machine to reach a state
├── volumes.rb           # List volumes for an app
├── volume.rb            # Get volume details
├── create_volume.rb     # Create a volume
├── extend_volume.rb     # Extend a volume size
├── delete_volume.rb     # Delete a volume
├── snapshots.rb         # List snapshots for a volume
├── certificates.rb      # List certificates for an app
├── certificate.rb       # Get certificate details for a hostname
└── create_certificate.rb # Request ACME certificate for a hostname
```

## Setup (check before using)

```bash
ruby ~/.claude/skills/flyio/scripts/check_setup.rb
```

If the output is `OK`, proceed to the Flow section.

If the output is `SETUP_NEEDED`, guide the user step by step. Present ONE step at a time, wait for the user to confirm before moving to the next.

**Step 1** — Ask the user to create an API token:

> You need a Fly.io API token. You can create one with the flyctl CLI:
>
> ```
> fly tokens deploy
> ```
>
> Or create a personal access token at:
> https://fly.io/dashboard → Account → Access Tokens
>
> Copy the token and paste it here.

**Step 2** — When the user pastes the token, save it:

```bash
ruby ~/.claude/skills/flyio/scripts/save_token.rb 'PASTED_TOKEN'
```

If the script outputs an error, the token is invalid. Ask the user to double-check and try again.

**If setup is not complete, DO NOT proceed to the Flow. Complete all steps first.**

## Flow

The argument `$ARGUMENTS` may contain an app name or machine reference.

### Step 1: List apps

```bash
ruby ~/.claude/skills/flyio/scripts/apps.rb ORG_SLUG
```

Present the apps. If `$ARGUMENTS` matches an app name, use that app. Otherwise ask which app to work with.

### Step 2: Show app details

```bash
ruby ~/.claude/skills/flyio/scripts/app.rb APP_NAME
```

Present the app info and ask what the user wants to do.

### Step 3: Actions

**List machines:**
```bash
ruby ~/.claude/skills/flyio/scripts/machines.rb APP_NAME
```

**Get machine details:**
```bash
ruby ~/.claude/skills/flyio/scripts/machine.rb APP_NAME MACHINE_ID
```

**Create a machine (requires user confirmation):**

Show the config first, then ask to confirm before creating.

```bash
ruby ~/.claude/skills/flyio/scripts/create_machine.rb APP_NAME --image "registry.fly.io/APP:latest" --region "gru" --cpus 1 --memory 256 --name "my-machine"
```

**Update a machine (requires user confirmation):**
```bash
ruby ~/.claude/skills/flyio/scripts/update_machine.rb APP_NAME MACHINE_ID --image "registry.fly.io/APP:latest" --cpus 2 --memory 512
```

**Start a machine (requires user confirmation):**
```bash
ruby ~/.claude/skills/flyio/scripts/start_machine.rb APP_NAME MACHINE_ID
```

**Stop a machine (requires user confirmation):**
```bash
ruby ~/.claude/skills/flyio/scripts/stop_machine.rb APP_NAME MACHINE_ID
```

**Delete a machine (requires user confirmation):**

Show the machine first, then ask: "Do you want to permanently delete this machine?" Only execute after a "yes".

```bash
ruby ~/.claude/skills/flyio/scripts/delete_machine.rb APP_NAME MACHINE_ID
```

**Wait for machine state:**
```bash
ruby ~/.claude/skills/flyio/scripts/machine_wait.rb APP_NAME MACHINE_ID --state started --timeout 30
```

**Create an app (requires user confirmation):**
```bash
ruby ~/.claude/skills/flyio/scripts/create_app.rb APP_NAME --org ORG_SLUG
```

**Delete an app (requires user confirmation):**

Show the app first, then ask: "Do you want to permanently delete this app?" Only execute after a "yes".

```bash
ruby ~/.claude/skills/flyio/scripts/delete_app.rb APP_NAME
```

**List volumes:**
```bash
ruby ~/.claude/skills/flyio/scripts/volumes.rb APP_NAME
```

**Get volume details:**
```bash
ruby ~/.claude/skills/flyio/scripts/volume.rb APP_NAME VOLUME_ID
```

**Create a volume (requires user confirmation):**
```bash
ruby ~/.claude/skills/flyio/scripts/create_volume.rb APP_NAME --name "data" --region "gru" --size 1
```

**Extend a volume (requires user confirmation):**
```bash
ruby ~/.claude/skills/flyio/scripts/extend_volume.rb APP_NAME VOLUME_ID --size 10
```

**Delete a volume (requires user confirmation):**

Show the volume first, then ask: "Do you want to permanently delete this volume? This cannot be undone." Only execute after a "yes".

```bash
ruby ~/.claude/skills/flyio/scripts/delete_volume.rb APP_NAME VOLUME_ID
```

**List volume snapshots:**
```bash
ruby ~/.claude/skills/flyio/scripts/snapshots.rb APP_NAME VOLUME_ID
```

**List certificates:**
```bash
ruby ~/.claude/skills/flyio/scripts/certificates.rb APP_NAME
```

**Get certificate details:**
```bash
ruby ~/.claude/skills/flyio/scripts/certificate.rb APP_NAME HOSTNAME
```

**Request ACME certificate (requires user confirmation):**
```bash
ruby ~/.claude/skills/flyio/scripts/create_certificate.rb APP_NAME HOSTNAME
```

## Notes

- **Pure Ruby, zero gems** — stdlib only (json, net/http, uri, fileutils)
- Auth via Bearer token (`Authorization: Bearer TOKEN`)
- Token file: `~/.config/flyio/token` (outside the repo, never commit)
- Base URL: `https://api.machines.dev`
- Creating, updating, starting, stopping, deleting machines/apps/volumes and requesting certificates require explicit user confirmation
- Machine states: `created`, `started`, `stopped`, `suspended`, `destroyed`
- Rate limits: 1 req/s per action (burst 3), GET machine 5 req/s (burst 10)
- Regions: use 3-letter codes (e.g. `gru`, `iad`, `lhr`, `nrt`)
