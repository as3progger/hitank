---
name: stripe
description: Manage Stripe payments, customers, subscriptions, invoices and products via REST API
user-invocable: true
argument-hint: [action or customer email]
---

# /stripe

Connect to Stripe to manage payments, customers, subscriptions, invoices and products. Pure Ruby, zero gems — stdlib only.

## Structure

```
scripts/
├── auth.rb              # Bearer token auth + stripe_request helper (required by all scripts)
├── check_setup.rb       # Check if token exists (outputs OK or SETUP_NEEDED)
├── save_token.rb        # Save and validate an API key
├── customers.rb         # List customers
├── customer.rb          # Get customer details
├── create_customer.rb   # Create a customer
├── charges.rb           # List charges
├── payments.rb          # List payment intents
├── create_payment.rb    # Create a payment intent
├── subscriptions.rb     # List subscriptions
├── subscription.rb      # Get subscription details
├── create_subscription.rb # Create a subscription
├── invoices.rb          # List invoices
├── invoice.rb           # Get invoice details
├── products.rb          # List products
├── create_product.rb    # Create a product
├── prices.rb            # List prices
├── create_price.rb      # Create a price
└── balance.rb           # Get account balance
```

## Setup (check before using)

```bash
ruby ~/.claude/skills/stripe/scripts/check_setup.rb
```

If the output is `OK`, proceed to the Flow section.

If the output is `SETUP_NEEDED`, guide the user step by step. Present ONE step at a time, wait for the user to confirm before moving to the next.

**Step 1** — Ask the user to get their API key:

> You need a Stripe API key.
>
> 1. Go to https://dashboard.stripe.com/apikeys
> 2. Copy your **Secret key** (starts with `sk_test_` or `sk_live_`)
>
> Paste the API key here.

**Step 2** — When the user pastes the key, save it:

```bash
ruby ~/.claude/skills/stripe/scripts/save_token.rb 'PASTED_KEY'
```

If the script outputs an error, the key is invalid. Ask the user to double-check and try again.

**If setup is not complete, DO NOT proceed to the Flow. Complete all steps first.**

## Flow

The argument `$ARGUMENTS` may contain an action or customer email.

### Step 1: Check balance

```bash
ruby ~/.claude/skills/stripe/scripts/balance.rb
```

Present the balance and ask what the user wants to do.

### Step 2: Actions

**List customers:**
```bash
ruby ~/.claude/skills/stripe/scripts/customers.rb
ruby ~/.claude/skills/stripe/scripts/customers.rb --limit 5 --email user@example.com
```

**Get customer details:**
```bash
ruby ~/.claude/skills/stripe/scripts/customer.rb CUSTOMER_ID
```

**Create a customer (requires user confirmation):**
```bash
ruby ~/.claude/skills/stripe/scripts/create_customer.rb "user@example.com" --name "John Doe" --phone "+1234567890"
```

**List charges:**
```bash
ruby ~/.claude/skills/stripe/scripts/charges.rb
ruby ~/.claude/skills/stripe/scripts/charges.rb --limit 10 --customer CUSTOMER_ID
```

**List payment intents:**
```bash
ruby ~/.claude/skills/stripe/scripts/payments.rb
ruby ~/.claude/skills/stripe/scripts/payments.rb --limit 10 --customer CUSTOMER_ID
```

**Create a payment intent (requires user confirmation):**
```bash
ruby ~/.claude/skills/stripe/scripts/create_payment.rb 2000 usd --customer CUSTOMER_ID --description "Order #123"
```

**List subscriptions:**
```bash
ruby ~/.claude/skills/stripe/scripts/subscriptions.rb
ruby ~/.claude/skills/stripe/scripts/subscriptions.rb --limit 10 --customer CUSTOMER_ID --status active
```

**Get subscription details:**
```bash
ruby ~/.claude/skills/stripe/scripts/subscription.rb SUBSCRIPTION_ID
```

**Create a subscription (requires user confirmation):**
```bash
ruby ~/.claude/skills/stripe/scripts/create_subscription.rb CUSTOMER_ID PRICE_ID
```

**List invoices:**
```bash
ruby ~/.claude/skills/stripe/scripts/invoices.rb
ruby ~/.claude/skills/stripe/scripts/invoices.rb --limit 10 --customer CUSTOMER_ID --status paid
```

**Get invoice details:**
```bash
ruby ~/.claude/skills/stripe/scripts/invoice.rb INVOICE_ID
```

**List products:**
```bash
ruby ~/.claude/skills/stripe/scripts/products.rb
ruby ~/.claude/skills/stripe/scripts/products.rb --limit 10 --active true
```

**Create a product (requires user confirmation):**
```bash
ruby ~/.claude/skills/stripe/scripts/create_product.rb "Premium Plan" --description "Full access to all features"
```

**List prices:**
```bash
ruby ~/.claude/skills/stripe/scripts/prices.rb
ruby ~/.claude/skills/stripe/scripts/prices.rb --limit 10 --product PRODUCT_ID
```

**Create a price (requires user confirmation):**
```bash
ruby ~/.claude/skills/stripe/scripts/create_price.rb PRODUCT_ID 2000 usd
ruby ~/.claude/skills/stripe/scripts/create_price.rb PRODUCT_ID 2000 usd --interval month
```

**Get account balance:**
```bash
ruby ~/.claude/skills/stripe/scripts/balance.rb
```

## Notes

- **Pure Ruby, zero gems** — stdlib only (json, net/http, uri, fileutils)
- Auth via Bearer token (API key starting with `sk_test_` or `sk_live_`)
- Token file: `~/.config/stripe/token` (outside the repo, never commit)
- Base URL: `https://api.stripe.com/v1`
- POST/PUT bodies are sent as `application/x-www-form-urlencoded` (not JSON)
- Amounts are in the smallest currency unit (e.g., cents for USD: 2000 = $20.00)
- Creating customers, payments, subscriptions, products, and prices requires explicit user confirmation
