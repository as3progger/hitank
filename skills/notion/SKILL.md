---
name: notion
description: Manage Notion pages, databases, blocks and users via REST API
user-invocable: true
argument-hint: [action or page title]
---

# /notion

Connect to Notion to search, manage pages, query databases, edit blocks and list users. Pure Ruby, zero gems — stdlib only.

## Structure

```
scripts/
├── auth.rb              # Bearer token auth + notion_request helper (required by all scripts)
├── check_setup.rb       # Check if token exists (outputs OK or SETUP_NEEDED)
├── save_token.rb        # Save and validate an integration token
├── search.rb            # Search pages and databases
├── databases.rb         # List databases
├── database.rb          # Get database details and properties
├── query_database.rb    # Query a database
├── pages.rb             # List pages
├── page.rb              # Get page details
├── create_page.rb       # Create a page
├── update_page.rb       # Update page properties
├── blocks.rb            # List child blocks
├── append_blocks.rb     # Append blocks to a page
├── delete_block.rb      # Delete a block
└── users.rb             # List users
```

## Setup (check before using)

```bash
ruby ~/.claude/skills/notion/scripts/check_setup.rb
```

If the output is `OK`, proceed to the Flow section.

If the output is `SETUP_NEEDED`, guide the user step by step. Present ONE step at a time, wait for the user to confirm before moving to the next.

**Step 1** — Ask the user to create an integration:

> You need a Notion integration token.
>
> 1. Go to https://www.notion.so/my-integrations
> 2. Click **New integration**
> 3. Give it a name, select the workspace
> 4. Copy the **Internal Integration Secret** (starts with `secret_`)
> 5. Share the pages/databases you want to access with the integration (open the page, click `...` > **Connections** > add your integration)
>
> Paste the integration token here.

**Step 2** — When the user pastes the token, save it:

```bash
ruby ~/.claude/skills/notion/scripts/save_token.rb 'PASTED_TOKEN'
```

If the script outputs an error, the token is invalid. Ask the user to double-check and try again.

**If setup is not complete, DO NOT proceed to the Flow. Complete all steps first.**

## Flow

The argument `$ARGUMENTS` may contain an action or page title.

### Step 1: Search or list

```bash
ruby ~/.claude/skills/notion/scripts/search.rb "QUERY"
ruby ~/.claude/skills/notion/scripts/pages.rb
ruby ~/.claude/skills/notion/scripts/databases.rb
```

Present the results and ask what the user wants to do.

### Step 2: Actions

**Search pages and databases:**
```bash
ruby ~/.claude/skills/notion/scripts/search.rb "QUERY" --filter page
ruby ~/.claude/skills/notion/scripts/search.rb "QUERY" --filter database --page-size 10
```

**List databases:**
```bash
ruby ~/.claude/skills/notion/scripts/databases.rb
```

**Get database details:**
```bash
ruby ~/.claude/skills/notion/scripts/database.rb DATABASE_ID
```

**Query a database:**
```bash
ruby ~/.claude/skills/notion/scripts/query_database.rb DATABASE_ID --page-size 20
```

**List pages:**
```bash
ruby ~/.claude/skills/notion/scripts/pages.rb
ruby ~/.claude/skills/notion/scripts/pages.rb "QUERY" --page-size 10
```

**Get page details:**
```bash
ruby ~/.claude/skills/notion/scripts/page.rb PAGE_ID
```

**Create a page under a page (requires user confirmation):**
```bash
ruby ~/.claude/skills/notion/scripts/create_page.rb PARENT_PAGE_ID "My New Page"
```

**Create a page in a database (requires user confirmation):**
```bash
ruby ~/.claude/skills/notion/scripts/create_page.rb DATABASE_ID "New Entry" --database
```

**Update page properties (requires user confirmation):**
```bash
ruby ~/.claude/skills/notion/scripts/update_page.rb PAGE_ID "Name" "New Title"
ruby ~/.claude/skills/notion/scripts/update_page.rb PAGE_ID "Description" "Updated text"
```

**List child blocks:**
```bash
ruby ~/.claude/skills/notion/scripts/blocks.rb PAGE_ID
ruby ~/.claude/skills/notion/scripts/blocks.rb PAGE_ID --page-size 50
```

**Append blocks to a page (requires user confirmation):**
```bash
ruby ~/.claude/skills/notion/scripts/append_blocks.rb PAGE_ID "Hello world"
ruby ~/.claude/skills/notion/scripts/append_blocks.rb PAGE_ID "My Heading" --type heading_1
ruby ~/.claude/skills/notion/scripts/append_blocks.rb PAGE_ID "Buy groceries" --type to_do
ruby ~/.claude/skills/notion/scripts/append_blocks.rb PAGE_ID "console.log('hi')" --type code
```

Block types: `paragraph` (default), `heading_1`, `heading_2`, `heading_3`, `bulleted_list_item`, `numbered_list_item`, `to_do`, `code`

**Delete a block (requires user confirmation):**
```bash
ruby ~/.claude/skills/notion/scripts/delete_block.rb BLOCK_ID
```

**List users:**
```bash
ruby ~/.claude/skills/notion/scripts/users.rb
```

## Notes

- **Pure Ruby, zero gems** — stdlib only (json, net/http, uri, fileutils)
- Auth via Bearer token (Internal Integration Secret starting with `secret_`)
- All requests include the `Notion-Version: 2022-06-28` header
- Token file: `~/.config/notion/token` (outside the repo, never commit)
- Base URL: `https://api.notion.com/v1`
- Pages/databases must be shared with the integration to be accessible
- Creating pages, updating properties, appending/deleting blocks require explicit user confirmation
