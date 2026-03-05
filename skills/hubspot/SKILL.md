---
name: hubspot
description: Manage HubSpot contacts, companies, deals and pipelines via CRM API
user-invocable: true
argument-hint: [contact name, company or deal]
---

# /hubspot

Connect to HubSpot CRM to manage contacts, companies, deals, pipelines and more. Pure Ruby, zero gems — stdlib only.

## Structure

```
scripts/
├── auth.rb            # Bearer token auth + hubspot_request helper (required by all scripts)
├── check_setup.rb     # Check if token exists (outputs OK or SETUP_NEEDED)
├── save_token.rb      # Save and validate a private app token
├── contacts.rb        # List contacts
├── contact.rb         # Get contact details
├── create_contact.rb  # Create a contact
├── update_contact.rb  # Update a contact
├── companies.rb       # List companies
├── company.rb         # Get company details
├── deals.rb           # List deals
├── deal.rb            # Get deal details
├── create_deal.rb     # Create a deal
├── search.rb          # Search CRM objects (contacts, companies, deals, tickets)
├── pipelines.rb       # List pipelines and stages
├── owners.rb          # List owners
└── notes.rb           # List notes for a contact, company or deal
```

## Setup (check before using)

```bash
ruby ~/.claude/skills/hubspot/scripts/check_setup.rb
```

If the output is `OK`, proceed to the Flow section.

If the output is `SETUP_NEEDED`, guide the user step by step. Present ONE step at a time, wait for the user to confirm before moving to the next.

**Step 1** — Ask the user to create a private app token:

> You need a HubSpot private app access token.
>
> 1. Go to **Settings > Integrations > Private Apps** in your HubSpot account
> 2. Or open: https://app.hubspot.com/private-apps/
> 3. Click **Create a private app**, give it a name (e.g. "hitank")
> 4. Under **Scopes**, select: `crm.objects.contacts.read`, `crm.objects.contacts.write`, `crm.objects.companies.read`, `crm.objects.companies.write`, `crm.objects.deals.read`, `crm.objects.deals.write`, `crm.objects.owners.read`
> 5. Click **Create app** and copy the access token
>
> Paste the token here.

**Step 2** — When the user pastes the token, save it:

```bash
ruby ~/.claude/skills/hubspot/scripts/save_token.rb 'PASTED_TOKEN'
```

If the script outputs an error, the token is invalid. Ask the user to double-check and try again.

**If setup is not complete, DO NOT proceed to the Flow. Complete all steps first.**

## Flow

The argument `$ARGUMENTS` may contain a contact name, company or deal reference.

### Step 1: Overview

Start by listing contacts, companies or deals based on what the user needs:

```bash
ruby ~/.claude/skills/hubspot/scripts/contacts.rb
ruby ~/.claude/skills/hubspot/scripts/companies.rb
ruby ~/.claude/skills/hubspot/scripts/deals.rb
```

If `$ARGUMENTS` contains a name or keyword, search for it:

```bash
ruby ~/.claude/skills/hubspot/scripts/search.rb contacts "search query"
```

### Step 2: Details

```bash
ruby ~/.claude/skills/hubspot/scripts/contact.rb CONTACT_ID
ruby ~/.claude/skills/hubspot/scripts/company.rb COMPANY_ID
ruby ~/.claude/skills/hubspot/scripts/deal.rb DEAL_ID
```

### Step 3: Actions

**Search CRM objects:**
```bash
ruby ~/.claude/skills/hubspot/scripts/search.rb contacts "john"
ruby ~/.claude/skills/hubspot/scripts/search.rb companies "acme"
ruby ~/.claude/skills/hubspot/scripts/search.rb deals "enterprise"
```

**Create a contact (requires user confirmation):**
```bash
ruby ~/.claude/skills/hubspot/scripts/create_contact.rb "email@example.com" --firstname John --lastname Doe --company "Acme"
```

**Update a contact (requires user confirmation):**
```bash
ruby ~/.claude/skills/hubspot/scripts/update_contact.rb CONTACT_ID '{"phone":"+5511999999999","company":"Acme"}'
```

**Create a deal (requires user confirmation):**
```bash
ruby ~/.claude/skills/hubspot/scripts/create_deal.rb "Deal Name" --stage appointmentscheduled --amount 5000 --closedate 2026-12-31
```

**List pipelines and stages:**
```bash
ruby ~/.claude/skills/hubspot/scripts/pipelines.rb
ruby ~/.claude/skills/hubspot/scripts/pipelines.rb tickets
```

**List owners:**
```bash
ruby ~/.claude/skills/hubspot/scripts/owners.rb
```

**List notes:**
```bash
ruby ~/.claude/skills/hubspot/scripts/notes.rb contacts CONTACT_ID
ruby ~/.claude/skills/hubspot/scripts/notes.rb deals DEAL_ID
```

**Pagination** — use `--after CURSOR` to paginate through results:
```bash
ruby ~/.claude/skills/hubspot/scripts/contacts.rb --limit 20 --after CURSOR_VALUE
```

## Notes

- **Pure Ruby, zero gems** — stdlib only (json, net/http, uri, fileutils)
- Auth via Bearer token (HubSpot private app)
- Token file: `~/.config/hubspot/token` (outside the repo, never commit)
- Creating and updating contacts, companies, and deals require explicit user confirmation
- HubSpot CRM API v3 uses cursor-based pagination
- Rate limit: 100 requests per 10 seconds (private apps)
- Base URL: `https://api.hubapi.com`
