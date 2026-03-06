---
name: trello
description: Manage Trello boards, lists, cards, checklists, labels and members via REST API
user-invocable: true
argument-hint: [board name or card]
---

# /trello

Connect to Trello to manage boards, lists, cards, checklists, labels and more. Pure Ruby, zero gems — stdlib only.

## Structure

```
scripts/
├── auth.rb            # API key + token auth + trello_request helper (required by all scripts)
├── check_setup.rb     # Check if credentials exist (outputs OK or SETUP_NEEDED)
├── save_token.rb      # Save and validate API key + token
├── boards.rb          # List boards for the authenticated member
├── board.rb           # Get a single board by ID
├── lists.rb           # List lists in a board
├── cards.rb           # List cards in a list or board
├── card.rb            # Get a single card by ID
├── create_card.rb     # Create a card in a list
├── update_card.rb     # Update a card (name, desc, due, idList, closed)
├── delete_card.rb     # Delete a card
├── move_card.rb       # Move a card to another list
├── create_list.rb     # Create a list in a board
├── update_list.rb     # Update a list (name, closed, pos)
├── labels.rb          # List labels on a board
├── create_label.rb    # Create a label on a board
├── checklists.rb      # List checklists on a card
├── create_checklist.rb # Create a checklist on a card
├── create_checkitem.rb # Add an item to a checklist
├── update_checkitem.rb # Update a check item (name, state)
├── members.rb         # List members of a board
├── add_member.rb      # Add a member to a card
├── search.rb          # Search cards, boards, members, organizations
└── comments.rb        # List and add comments on a card
```

## Setup (check before using)

```bash
ruby ~/.claude/skills/trello/scripts/check_setup.rb
```

If the output is `OK`, proceed to the Flow section.

If the output is `SETUP_NEEDED`, guide the user step by step. Present ONE step at a time, wait for the user to confirm before moving to the next.

**Step 1** — Ask the user to get their API key and token:

> You need a Trello API key and token. Follow these steps:
>
> 1. Go to https://trello.com/power-ups/admin and log in
> 2. Click **New** to create a new Power-Up (or use an existing one)
> 3. Give it a name (e.g. "HiTank"), fill required fields, then click **Create**
> 4. Go to the **API Key** tab and click **Generate a new API Key**
> 5. Copy the **API Key**
> 6. Next to the API key, click the **Token** link to generate a token — authorize access and copy the **Token**
>
> Paste the API key here first.

**Step 2** — When the user pastes the API key, ask for the token:

> Now paste the Token.

**Step 3** — When the user pastes the token, save both:

```bash
ruby ~/.claude/skills/trello/scripts/save_token.rb 'API_KEY' 'TOKEN'
```

If the script outputs an error, the credentials are invalid. Ask the user to double-check and try again.

**If setup is not complete, DO NOT proceed to the Flow. Complete all steps first.**

## Flow

The argument `$ARGUMENTS` may contain a board name or card reference.

### Step 1: List boards

```bash
ruby ~/.claude/skills/trello/scripts/boards.rb
```

Present the boards. If there is only one, use it automatically. Otherwise ask which board to work with.

### Step 2: List lists

```bash
ruby ~/.claude/skills/trello/scripts/lists.rb BOARD_ID
```

Show the lists. Ask which list to work with or what action to take.

### Step 3: Actions

**List cards in a list:**
```bash
ruby ~/.claude/skills/trello/scripts/cards.rb LIST_ID
ruby ~/.claude/skills/trello/scripts/cards.rb LIST_ID --limit 10
```

**List all cards on a board:**
```bash
ruby ~/.claude/skills/trello/scripts/cards.rb --board BOARD_ID
ruby ~/.claude/skills/trello/scripts/cards.rb --board BOARD_ID --limit 20
```

**Get a single card:**
```bash
ruby ~/.claude/skills/trello/scripts/card.rb CARD_ID
```

**Create a card (requires user confirmation):**

Show the card details first, then ask to confirm before creating.

```bash
ruby ~/.claude/skills/trello/scripts/create_card.rb LIST_ID "Card Name" --desc "Description" --due "2025-12-31" --idLabels "LABEL_ID1,LABEL_ID2"
```

**Update a card (requires user confirmation):**
```bash
ruby ~/.claude/skills/trello/scripts/update_card.rb CARD_ID --name "New Name" --desc "New Desc" --due "2025-12-31" --idList LIST_ID --closed true
```

**Delete a card (requires user confirmation):**

Show the card first, then ask: "Do you want to delete this card?" Only execute after a "yes".

```bash
ruby ~/.claude/skills/trello/scripts/delete_card.rb CARD_ID
```

**Move a card to another list (requires user confirmation):**
```bash
ruby ~/.claude/skills/trello/scripts/move_card.rb CARD_ID TARGET_LIST_ID
```

**Create a list (requires user confirmation):**
```bash
ruby ~/.claude/skills/trello/scripts/create_list.rb BOARD_ID "List Name"
```

**Update a list (requires user confirmation):**
```bash
ruby ~/.claude/skills/trello/scripts/update_list.rb LIST_ID --name "New Name" --closed true --pos top
```

**List labels on a board:**
```bash
ruby ~/.claude/skills/trello/scripts/labels.rb BOARD_ID
```

**Create a label (requires user confirmation):**
```bash
ruby ~/.claude/skills/trello/scripts/create_label.rb BOARD_ID "Label Name" --color green
```

**List checklists on a card:**
```bash
ruby ~/.claude/skills/trello/scripts/checklists.rb CARD_ID
```

**Create a checklist (requires user confirmation):**
```bash
ruby ~/.claude/skills/trello/scripts/create_checklist.rb CARD_ID "Checklist Name"
```

**Add a check item (requires user confirmation):**
```bash
ruby ~/.claude/skills/trello/scripts/create_checkitem.rb CHECKLIST_ID "Item name"
```

**Update a check item (requires user confirmation):**
```bash
ruby ~/.claude/skills/trello/scripts/update_checkitem.rb CARD_ID CHECKITEM_ID --state complete
ruby ~/.claude/skills/trello/scripts/update_checkitem.rb CARD_ID CHECKITEM_ID --name "New name" --state incomplete
```

**List board members:**
```bash
ruby ~/.claude/skills/trello/scripts/members.rb BOARD_ID
```

**Add a member to a card (requires user confirmation):**
```bash
ruby ~/.claude/skills/trello/scripts/add_member.rb CARD_ID MEMBER_ID
```

**Search:**
```bash
ruby ~/.claude/skills/trello/scripts/search.rb "query text"
ruby ~/.claude/skills/trello/scripts/search.rb "query text" --cards --boards
```

**List comments on a card:**
```bash
ruby ~/.claude/skills/trello/scripts/comments.rb CARD_ID
```

**Add a comment (requires user confirmation):**
```bash
ruby ~/.claude/skills/trello/scripts/comments.rb CARD_ID --add "Comment text here"
```

## Notes

- **Pure Ruby, zero gems** — stdlib only (json, net/http, uri, fileutils)
- Auth via API key + token as query params (`?key=KEY&token=TOKEN`)
- Credentials file: `~/.config/trello/credentials.json` (outside the repo, never commit)
- Creating, updating, deleting cards, moving cards, creating lists/labels/checklists, adding members and comments require explicit user confirmation
- Base URL: `https://api.trello.com/1`
- Label colors: yellow, purple, blue, red, green, orange, black, sky, pink, lime
- Checklist item states: `complete` or `incomplete`
- Card positions: `top`, `bottom`, or a positive float
