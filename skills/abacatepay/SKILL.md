---
name: abacatepay
description: Manage AbacatePay payments, PIX, customers, coupons and withdrawals via REST API
user-invocable: true
argument-hint: [action or customer name]
---

# /abacatepay

Connect to AbacatePay to manage payments, PIX QR codes, customers, coupons, withdrawals and revenue. Pure Ruby, zero gems — stdlib only.

## Structure

```
scripts/
├── auth.rb              # Bearer token auth + abacate_request helper (required by all scripts)
├── check_setup.rb       # Check if token exists (outputs OK or SETUP_NEEDED)
├── save_token.rb        # Save and validate an API token
├── store.rb             # Get store details and balance
├── customers.rb         # List all customers
├── create_customer.rb   # Create a customer
├── billings.rb          # List all charges
├── create_billing.rb    # Create a charge with payment link
├── pix_create.rb        # Create a PIX QR code
├── pix_check.rb         # Check PIX payment status
├── pix_simulate.rb      # Simulate PIX payment (dev mode)
├── coupons.rb           # List all coupons
├── create_coupon.rb     # Create a discount coupon
├── withdrawals.rb       # List all withdrawals
├── create_withdrawal.rb # Create a withdrawal to PIX key
├── withdrawal.rb        # Get withdrawal details
├── revenue.rb           # Get revenue for a period
└── mrr.rb               # Get Monthly Recurring Revenue
```

## Setup (check before using)

```bash
ruby ~/.claude/skills/abacatepay/scripts/check_setup.rb
```

If the output is `OK`, proceed to the Flow section.

If the output is `SETUP_NEEDED`, guide the user step by step. Present ONE step at a time, wait for the user to confirm before moving to the next.

**Step 1** — Ask the user to get their API token:

> You need an AbacatePay API token.
>
> 1. Go to https://app.abacatepay.com and log in
> 2. Go to **Settings > Security**
> 3. Copy your API token
>
> For development, use the dev mode token. For production, use the production token.
>
> Paste the token here.

**Step 2** — When the user pastes the token, save it:

```bash
ruby ~/.claude/skills/abacatepay/scripts/save_token.rb 'PASTED_TOKEN'
```

If the script outputs an error, the token is invalid. Ask the user to double-check and try again.

**If setup is not complete, DO NOT proceed to the Flow. Complete all steps first.**

## Flow

The argument `$ARGUMENTS` may contain an action or customer reference.

### Step 1: Store overview

```bash
ruby ~/.claude/skills/abacatepay/scripts/store.rb
```

Present the store info and ask what the user wants to do.

### Step 2: Actions

**List customers:**
```bash
ruby ~/.claude/skills/abacatepay/scripts/customers.rb
```

**Create a customer (requires user confirmation):**
```bash
ruby ~/.claude/skills/abacatepay/scripts/create_customer.rb "João Silva" "joao@email.com" "+5511999999999" "12345678900"
```

**List charges:**
```bash
ruby ~/.claude/skills/abacatepay/scripts/billings.rb
```

**Create a charge (requires user confirmation):**
```bash
ruby ~/.claude/skills/abacatepay/scripts/create_billing.rb '{"frequency":"ONE_TIME","methods":["PIX"],"products":[{"externalId":"prod1","name":"Produto","quantity":1,"price":1000}],"returnUrl":"https://example.com/cancel","completionUrl":"https://example.com/success"}'
```

Price is in **centavos** (1000 = R$10,00). Frequency: `ONE_TIME` or `MULTIPLE_PAYMENTS`. Methods: `PIX`, `CARD`.

**Create a PIX QR code (requires user confirmation):**
```bash
ruby ~/.claude/skills/abacatepay/scripts/pix_create.rb 1000
ruby ~/.claude/skills/abacatepay/scripts/pix_create.rb 5000 --description "Pagamento teste" --expires 3600
```

**Check PIX payment status:**
```bash
ruby ~/.claude/skills/abacatepay/scripts/pix_check.rb PIX_ID
```

**Simulate PIX payment (dev mode only):**
```bash
ruby ~/.claude/skills/abacatepay/scripts/pix_simulate.rb PIX_ID
```

**List coupons:**
```bash
ruby ~/.claude/skills/abacatepay/scripts/coupons.rb
```

**Create a coupon (requires user confirmation):**
```bash
ruby ~/.claude/skills/abacatepay/scripts/create_coupon.rb PROMO10 10 PERCENTAGE "10% de desconto"
ruby ~/.claude/skills/abacatepay/scripts/create_coupon.rb FIXO5 500 FIXED "R$5 off" --max-redeems 100
```

**List withdrawals:**
```bash
ruby ~/.claude/skills/abacatepay/scripts/withdrawals.rb
```

**Create a withdrawal (requires user confirmation):**
```bash
ruby ~/.claude/skills/abacatepay/scripts/create_withdrawal.rb "saque-001" 5000 CPF "12345678900"
```

Amount minimum: 350 centavos (R$3,50). PIX types: `CPF`, `CNPJ`, `EMAIL`, `PHONE`, `EVP`.

**Get withdrawal details:**
```bash
ruby ~/.claude/skills/abacatepay/scripts/withdrawal.rb "saque-001"
```

**Get revenue by period:**
```bash
ruby ~/.claude/skills/abacatepay/scripts/revenue.rb 2026-01-01 2026-03-01
```

**Get MRR:**
```bash
ruby ~/.claude/skills/abacatepay/scripts/mrr.rb
```

## Notes

- **Pure Ruby, zero gems** — stdlib only (json, net/http, uri, fileutils)
- Auth via Bearer token (JWT)
- Token file: `~/.config/abacatepay/token` (outside the repo, never commit)
- Creating customers, charges, PIX, coupons, and withdrawals require explicit user confirmation
- All monetary values are in **centavos** (R$10,00 = 1000)
- PIX statuses: PENDING, EXPIRED, CANCELLED, PAID, REFUNDED
- Development mode available for testing with simulated payments
- Base URL: `https://api.abacatepay.com/v1`
