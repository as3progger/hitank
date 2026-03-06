---
name: railway
description: Manage Railway projects, services, deployments, variables, domains and volumes via GraphQL API
user-invocable: true
argument-hint: [project name or service]
---

# /railway

Connect to Railway to manage projects, services, deployments, environment variables, domains, volumes and more. Pure Ruby, zero gems — stdlib only.

## Structure

```
scripts/
├── auth.rb               # Bearer token auth + railway_query helper (required by all scripts)
├── check_setup.rb        # Check if token exists (outputs OK or SETUP_NEEDED)
├── save_token.rb         # Save and validate an API token
├── projects.rb           # List all projects
├── project.rb            # Get project details with services and environments
├── create_project.rb     # Create a project
├── delete_project.rb     # Delete a project
├── services.rb           # List services in a project (via project query)
├── service.rb            # Get service details and config for an environment
├── create_service.rb     # Create a service (GitHub repo, Docker image, or empty)
├── delete_service.rb     # Delete a service
├── deployments.rb        # List deployments for a service
├── deployment.rb         # Get deployment details
├── deploy.rb             # Trigger a deployment
├── redeploy.rb           # Redeploy a deployment
├── rollback.rb           # Rollback a deployment
├── stop_deployment.rb    # Stop a deployment
├── logs.rb               # Get build or runtime logs for a deployment
├── environments.rb       # List environments in a project
├── create_environment.rb # Create an environment
├── delete_environment.rb # Delete an environment
├── variables.rb          # List variables for a service/environment
├── set_variable.rb       # Set or update a variable
├── delete_variable.rb    # Delete a variable
├── domains.rb            # List domains for a service
├── create_domain.rb      # Create a Railway service domain
├── create_custom_domain.rb # Add a custom domain
├── delete_domain.rb      # Delete a domain
├── volumes.rb            # List volumes in a project
├── create_volume.rb      # Create a volume
├── delete_volume.rb      # Delete a volume
└── regions.rb            # List available deployment regions
```

## Setup (check before using)

```bash
ruby ~/.claude/skills/railway/scripts/check_setup.rb
```

If the output is `OK`, proceed to the Flow section.

If the output is `SETUP_NEEDED`, guide the user step by step. Present ONE step at a time, wait for the user to confirm before moving to the next.

**Step 1** — Ask the user to create an API token:

> You need a Railway API token.
>
> 1. Go to https://railway.com/account/tokens
> 2. Click **Create Token**
> 3. Give it a name (e.g. "hitank") and choose the scope
> 4. Copy the token
>
> Paste the token here.

**Step 2** — When the user pastes the token, save it:

```bash
ruby ~/.claude/skills/railway/scripts/save_token.rb 'PASTED_TOKEN'
```

If the script outputs an error, the token is invalid. Ask the user to double-check and try again.

**If setup is not complete, DO NOT proceed to the Flow. Complete all steps first.**

## Flow

The argument `$ARGUMENTS` may contain a project name or service reference.

### Step 1: List projects

```bash
ruby ~/.claude/skills/railway/scripts/projects.rb
```

Present the projects. If `$ARGUMENTS` matches a project name, use it. Otherwise ask which project to work with.

### Step 2: Show project details

```bash
ruby ~/.claude/skills/railway/scripts/project.rb PROJECT_ID
```

Present the project with its services and environments. Ask what the user wants to do.

### Step 3: Actions

**List services (included in project details):**
```bash
ruby ~/.claude/skills/railway/scripts/services.rb PROJECT_ID
```

**Get service details:**
```bash
ruby ~/.claude/skills/railway/scripts/service.rb SERVICE_ID ENVIRONMENT_ID
```

**Create a service (requires user confirmation):**
```bash
ruby ~/.claude/skills/railway/scripts/create_service.rb PROJECT_ID "Service Name"
ruby ~/.claude/skills/railway/scripts/create_service.rb PROJECT_ID "Service Name" --repo "user/repo" --branch "main"
ruby ~/.claude/skills/railway/scripts/create_service.rb PROJECT_ID "Service Name" --image "redis:latest"
```

**Delete a service (requires user confirmation):**

Show the service first, then ask: "Do you want to delete this service and all its deployments?" Only execute after a "yes".

```bash
ruby ~/.claude/skills/railway/scripts/delete_service.rb SERVICE_ID
```

**List deployments:**
```bash
ruby ~/.claude/skills/railway/scripts/deployments.rb PROJECT_ID SERVICE_ID ENVIRONMENT_ID
ruby ~/.claude/skills/railway/scripts/deployments.rb PROJECT_ID SERVICE_ID ENVIRONMENT_ID --limit 10
```

**Get deployment details:**
```bash
ruby ~/.claude/skills/railway/scripts/deployment.rb DEPLOYMENT_ID
```

**Trigger a deployment (requires user confirmation):**
```bash
ruby ~/.claude/skills/railway/scripts/deploy.rb SERVICE_ID ENVIRONMENT_ID
```

**Redeploy (requires user confirmation):**
```bash
ruby ~/.claude/skills/railway/scripts/redeploy.rb DEPLOYMENT_ID
```

**Rollback (requires user confirmation):**
```bash
ruby ~/.claude/skills/railway/scripts/rollback.rb DEPLOYMENT_ID
```

**Stop a deployment (requires user confirmation):**
```bash
ruby ~/.claude/skills/railway/scripts/stop_deployment.rb DEPLOYMENT_ID
```

**Get logs:**
```bash
ruby ~/.claude/skills/railway/scripts/logs.rb DEPLOYMENT_ID
ruby ~/.claude/skills/railway/scripts/logs.rb DEPLOYMENT_ID --type build --limit 200
ruby ~/.claude/skills/railway/scripts/logs.rb DEPLOYMENT_ID --type runtime --limit 100
```

**List environments:**
```bash
ruby ~/.claude/skills/railway/scripts/environments.rb PROJECT_ID
```

**Create an environment (requires user confirmation):**
```bash
ruby ~/.claude/skills/railway/scripts/create_environment.rb PROJECT_ID "staging"
ruby ~/.claude/skills/railway/scripts/create_environment.rb PROJECT_ID "preview" --ephemeral
```

**Delete an environment (requires user confirmation):**
```bash
ruby ~/.claude/skills/railway/scripts/delete_environment.rb ENVIRONMENT_ID
```

**List variables:**
```bash
ruby ~/.claude/skills/railway/scripts/variables.rb PROJECT_ID ENVIRONMENT_ID SERVICE_ID
```

**Set a variable (requires user confirmation):**
```bash
ruby ~/.claude/skills/railway/scripts/set_variable.rb PROJECT_ID ENVIRONMENT_ID SERVICE_ID "KEY" "VALUE"
```

**Delete a variable (requires user confirmation):**
```bash
ruby ~/.claude/skills/railway/scripts/delete_variable.rb PROJECT_ID ENVIRONMENT_ID SERVICE_ID "KEY"
```

**List domains:**
```bash
ruby ~/.claude/skills/railway/scripts/domains.rb PROJECT_ID ENVIRONMENT_ID SERVICE_ID
```

**Create a Railway domain (requires user confirmation):**
```bash
ruby ~/.claude/skills/railway/scripts/create_domain.rb SERVICE_ID ENVIRONMENT_ID
ruby ~/.claude/skills/railway/scripts/create_domain.rb SERVICE_ID ENVIRONMENT_ID --port 8080
```

**Add a custom domain (requires user confirmation):**
```bash
ruby ~/.claude/skills/railway/scripts/create_custom_domain.rb SERVICE_ID ENVIRONMENT_ID "app.example.com"
```

**Delete a domain (requires user confirmation):**
```bash
ruby ~/.claude/skills/railway/scripts/delete_domain.rb DOMAIN_ID --type service
ruby ~/.claude/skills/railway/scripts/delete_domain.rb DOMAIN_ID --type custom
```

**List volumes:**
```bash
ruby ~/.claude/skills/railway/scripts/volumes.rb PROJECT_ID
```

**Create a volume (requires user confirmation):**
```bash
ruby ~/.claude/skills/railway/scripts/create_volume.rb PROJECT_ID SERVICE_ID ENVIRONMENT_ID --path "/data"
```

**Delete a volume (requires user confirmation):**
```bash
ruby ~/.claude/skills/railway/scripts/delete_volume.rb VOLUME_ID
```

**List available regions:**
```bash
ruby ~/.claude/skills/railway/scripts/regions.rb
```

## Notes

- **Pure Ruby, zero gems** — stdlib only (json, net/http, uri, fileutils)
- Auth via Bearer token (`Authorization: Bearer TOKEN`)
- Token file: `~/.config/railway/token` (outside the repo, never commit)
- All queries use GraphQL API at `https://backboard.railway.com/graphql/v2`
- Creating, updating, deleting services/deployments/environments/variables/domains/volumes require explicit user confirmation
- Rate limits: 1,000/hour (Hobby), 10,000/hour (Pro)
- Service sources: GitHub repo, Docker image, or empty
