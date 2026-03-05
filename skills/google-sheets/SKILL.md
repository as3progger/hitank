---
name: google-sheets
description: Read and write data on Google Sheets
user-invocable: true
argument-hint: [Spreadsheet URL]
---

# /google-sheets

Connect to Google Sheets to read, analyze and write data. Pure Ruby, zero gems — stdlib only.

## Structure

```
scripts/
├── auth.rb          # JWT auth + sheets_request helper (required by all scripts)
├── check_setup.rb   # Check if key file exists (outputs OK or SETUP_NEEDED)
├── save_key.rb      # Save a Service Account JSON key
├── list_sheets.rb   # List tabs in a spreadsheet
├── read.rb          # Read data (entire tab or specific range)
├── write.rb         # Write to a range
└── append.rb        # Append rows at the end
```

## Setup (check before using)

```bash
ruby ~/.claude/skills/google-sheets/scripts/check_setup.rb
```

If the output is `OK`, proceed to the Flow section.

If the output is `SETUP_NEEDED`, guide the user step by step. Present ONE step at a time, wait for the user to confirm before moving to the next. Use simple, non-technical language.

**Step 1** — Ask the user to open this link and create a new project (or use an existing one):

> Abra este link e crie um projeto no Google Cloud com o nome **Hitank**:
> https://console.cloud.google.com/projectcreate

**Step 2** — After the user confirms, ask them to enable the Sheets API:

> Agora abra este link e clique no botão azul "Ativar" (ou "Enable"):
> https://console.cloud.google.com/apis/library/sheets.googleapis.com

**Step 3** — After the user confirms, guide them to create a Service Account:

> Abra este link e clique em "Criar conta de serviço" (ou "Create Service Account"):
> https://console.cloud.google.com/iam-admin/serviceaccounts
>
> No campo "Nome da conta de serviço", escreva: **Hitank Planilha**
> Clique em "Concluir" (ou "Done").

**Step 4** — After the user confirms, guide them to download the key:

> Na lista que apareceu, clique em **Hitank Planilha** (a conta que você acabou de criar).
> Vá na aba **Chaves** (ou "Keys").
> Clique em **Adicionar chave** → **Criar nova chave** → escolha **JSON** → **Criar**.
> Um arquivo vai ser baixado automaticamente. Abra esse arquivo, copie TODO o conteúdo e cole aqui.

**Step 5** — When the user pastes the JSON, save it:

```bash
ruby ~/.claude/skills/google-sheets/scripts/save_key.rb 'PASTED_JSON_CONTENT'
```

The script outputs the `client_email`. Tell the user:

> Última etapa! Abra sua planilha no Google Sheets, clique em **Compartilhar** (canto superior direito), e cole este email: `<client_email>`
> Escolha a permissão **Editor** e clique em **Enviar**.
> Isso permite que a gente acesse a planilha.

**If setup is not complete, DO NOT proceed to the Flow. Complete all steps first.**

## Flow

The argument `$ARGUMENTS` contains the Google Sheets URL.

### Step 1: Extract the spreadsheet ID

From the Google Sheets URL, extract the ID (the segment between `/d/` and `/edit` or the next `/`).

### Step 2: List tabs

```bash
ruby ~/.claude/skills/google-sheets/scripts/list_sheets.rb SPREADSHEET_ID
```

Present the tabs to the user and ask which one to access (or access the first one by default).

### Step 3: Read data

Entire tab (first by default):
```bash
ruby ~/.claude/skills/google-sheets/scripts/read.rb SPREADSHEET_ID
```

Specific range:
```bash
ruby ~/.claude/skills/google-sheets/scripts/read.rb SPREADSHEET_ID "Sheet1!A1:D50"
```

Output is JSON (array of arrays). Parse and present to the user in a readable format.

If the spreadsheet is large (>100 rows), read only the relevant range.

### Step 4: Analyze

After reading the data, present a summary to the user:
- How many rows/columns
- Headers (columns)
- Data sample
- Ask what the user wants to know or do

### Step 5: Write (with confirmation)

**ALL writes require explicit user confirmation before executing.**

Show exactly what will be written and where (cell, range, tab). Only execute after a "yes".

Write to a range:
```bash
ruby ~/.claude/skills/google-sheets/scripts/write.rb SPREADSHEET_ID "Sheet1!A1:B2" '[["a1","b1"],["a2","b2"]]'
```

Append rows at the end:
```bash
ruby ~/.claude/skills/google-sheets/scripts/append.rb SPREADSHEET_ID "Sheet1" '[["col1","col2","col3"]]'
```

For formulas and dates interpreted by Sheets, pass `USER_ENTERED` as the last argument:
```bash
ruby ~/.claude/skills/google-sheets/scripts/write.rb SPREADSHEET_ID "Sheet1!A1" '[["=SUM(B1:B10)"]]' USER_ENTERED
```

## Notes

- **Pure Ruby, zero gems** — stdlib only (openssl, base64, json, net/http)
- Auth via Service Account JWT → Bearer access token (valid for 1h)
- Key file: `~/.config/gcloud/sheets-sa-key.json` (outside the repo, never commit)
- All writes require user confirmation — reads are free
- If the spreadsheet is not shared with the Service Account, you'll get a 403 error
- Rate limits: Google Sheets API has a limit of 60 requests/minute per user
