---
name: shopify
description: Manage Shopify products, orders, customers, inventory and collections via Admin API
user-invocable: true
argument-hint: [action or product title]
---

# /shopify

Connect to Shopify to manage products, orders, customers, inventory and collections. Pure Ruby, zero gems — stdlib only.

## Structure

```
scripts/
├── auth.rb              # Access Token auth + shopify_request helper (required by all scripts)
├── check_setup.rb       # Check if config exists (outputs OK or SETUP_NEEDED)
├── save_token.rb        # Save and validate store name and access token
├── products.rb          # List products
├── product.rb           # Get product details
├── create_product.rb    # Create a product
├── update_product.rb    # Update a product
├── orders.rb            # List orders
├── order.rb             # Get order details
├── customers.rb         # List customers
├── customer.rb          # Get customer details
├── create_customer.rb   # Create a customer
├── inventory_levels.rb  # List inventory levels for a location
├── collections.rb       # List custom collections
└── shop.rb              # Get shop info
```

## Setup (check before using)

```bash
ruby ~/.claude/skills/shopify/scripts/check_setup.rb
```

If the output is `OK`, proceed to the Flow section.

If the output is `SETUP_NEEDED`, guide the user step by step. Present ONE step at a time, wait for the user to confirm before moving to the next.

**Step 1** — Ask the user to create a Shopify custom app:

> Go to your Shopify Admin > **Settings** > **Apps and sales channels** > **Develop apps** > **Create an app**.
>
> Give it a name (e.g. "hitank"), then go to **Configuration** > **Admin API integration** and select the scopes you need (e.g. read/write products, orders, customers, inventory).
>
> Click **Install app**, then copy the **Admin API access token** (starts with `shpat_`).
>
> Also note your store name — if your store URL is `https://mystore.myshopify.com`, the store name is `mystore`.
>
> Paste the store name and access token here.

**Step 2** — When the user provides both values, save them:

```bash
ruby ~/.claude/skills/shopify/scripts/save_token.rb 'STORE' 'TOKEN'
```

If the script outputs an error, the config is invalid. Ask the user to double-check and try again.

**If setup is not complete, DO NOT proceed to the Flow. Complete all steps first.**

## Flow

The argument `$ARGUMENTS` may contain an action or product title.

### Step 1: Get shop info

```bash
ruby ~/.claude/skills/shopify/scripts/shop.rb
```

Present the shop info. Use the context from `$ARGUMENTS` to determine what the user wants to do.

### Step 2: Actions

**List products:**
```bash
ruby ~/.claude/skills/shopify/scripts/products.rb
ruby ~/.claude/skills/shopify/scripts/products.rb --limit 10 --status active
```

**Get product details:**
```bash
ruby ~/.claude/skills/shopify/scripts/product.rb PRODUCT_ID
```

**Create a product (requires user confirmation):**

Ask the user to confirm the details before creating.

```bash
ruby ~/.claude/skills/shopify/scripts/create_product.rb "Product Title"
ruby ~/.claude/skills/shopify/scripts/create_product.rb "Cool T-Shirt" --body "A very cool shirt" --vendor "MyBrand" --product-type "Apparel" --status active
```

**Update a product (requires user confirmation):**

Show current product details first, then ask what to change.

```bash
ruby ~/.claude/skills/shopify/scripts/update_product.rb PRODUCT_ID --title "New Title" --status active
```

**List orders:**
```bash
ruby ~/.claude/skills/shopify/scripts/orders.rb
ruby ~/.claude/skills/shopify/scripts/orders.rb --limit 10 --status open
ruby ~/.claude/skills/shopify/scripts/orders.rb --financial-status paid
```

**Get order details:**
```bash
ruby ~/.claude/skills/shopify/scripts/order.rb ORDER_ID
```

**List customers:**
```bash
ruby ~/.claude/skills/shopify/scripts/customers.rb
ruby ~/.claude/skills/shopify/scripts/customers.rb --limit 20
```

**Get customer details:**
```bash
ruby ~/.claude/skills/shopify/scripts/customer.rb CUSTOMER_ID
```

**Create a customer (requires user confirmation):**
```bash
ruby ~/.claude/skills/shopify/scripts/create_customer.rb "email@example.com"
ruby ~/.claude/skills/shopify/scripts/create_customer.rb "email@example.com" --first-name "John" --last-name "Doe" --phone "+1234567890"
```

**List inventory levels:**
```bash
ruby ~/.claude/skills/shopify/scripts/inventory_levels.rb LOCATION_ID
ruby ~/.claude/skills/shopify/scripts/inventory_levels.rb LOCATION_ID --limit 50
```

**List collections:**
```bash
ruby ~/.claude/skills/shopify/scripts/collections.rb
ruby ~/.claude/skills/shopify/scripts/collections.rb --limit 10
```

**Get shop info:**
```bash
ruby ~/.claude/skills/shopify/scripts/shop.rb
```

## Notes

- **Pure Ruby, zero gems** — stdlib only (json, net/http, uri, fileutils)
- Auth via `X-Shopify-Access-Token` header (custom app access token)
- Config file: `~/.config/shopify/config.json` (outside the repo, never commit)
- Config contains `store` (store name) and `token` (access token starting with `shpat_`)
- Creating products and customers requires explicit user confirmation
- Updating products requires explicit user confirmation
- Shopify Admin API version: `2024-01`
- Base URL: `https://STORE.myshopify.com/admin/api/2024-01`
