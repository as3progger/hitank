# hitank

<div align="center">
  <img src="assets/pilot-program.gif" alt="I need a pilot program for a B-212 helicopter" />
  <p><em>I need a pilot program for a B-212 helicopter.</em></p>
</div>

Claude Code skills in pure Ruby. No dependencies, fewer tokens, just stdlib.

## Available Skills

| Category | Skill | Description |
|----------|-------|-------------|
| Office | google-sheets | Read and write Google Sheets via REST API |

## Installation

### 1. Check if you have Ruby

Open the terminal and run:

```bash
ruby -v
```

If you see something like `ruby 3.x.x`, you're good — skip to step 3.

If the command is not found or the version is below 3.0, follow step 2.

### 2. Install Ruby (if needed)

**Mac** — Ruby comes pre-installed, but it's usually outdated. The easiest way to get Ruby 3+:

```bash
brew install ruby
```

Don't have Homebrew? Install it first: https://brew.sh

After installing, restart your terminal and run `ruby -v` again to confirm.

**Linux (Ubuntu/Debian)**:

```bash
sudo apt update && sudo apt install ruby-full
```

**Windows**:

Download the installer from https://rubyinstaller.org — pick the latest Ruby+Devkit version and follow the wizard.

### 3. Install hitank

```bash
gem install hitank
```

That's it. No other dependencies needed.

## Usage

```bash
# List available skills
hitank list

# Install a skill (global — works in all projects)
hitank add google-sheets

# Install for current project only
hitank add google-sheets --local

# Remove a skill
hitank del google-sheets
```

After installing, use `/google-sheets` (or any skill name) directly in Claude Code.

## Why Ruby

Ruby's stdlib is surprisingly powerful. `net/http`, `openssl`, `json`, `base64` — everything you need to talk to REST APIs is already there. No gem install, no bundler, no dependency hell.

These skills prove a point: you don't need Python or TypeScript to build useful AI tooling. Ruby works. And if you already have Ruby installed (you probably do), these skills just work.

**Token economy** — Less code for Claude to read means fewer tokens per session, which adds up fast if you're watching your usage.

For a skill that reads/writes a REST API with auth (like Google Sheets):

| | Ruby (hitank) | Python + deps | TypeScript (MCP) |
|---|---|---|---|
| Skill files | 8 | ~8-10 | ~12-15 |
| Config files | 0 | 2+ | 3+ |
| Lines of code | 185 ✱ | ~200-350 | ~400-600 |
| Dependencies | 0 | ~5-10 | ~10-20 |
| Est. tokens | **~2,750** ✱ | **~4,000-6,000** | **~6,000-9,000** |

✱ Measured from the Google Sheets skill. Other values are estimates based on minimum setup each stack requires.

## How It Works

Skills are stored in this repository under `skills/`. The `hitank` gem is a thin CLI that fetches individual skills from GitHub and installs them to `~/.claude/skills/` (or `.claude/skills/` with `--local`).

The skills themselves use **zero gems** — pure Ruby stdlib. The gem is just the installer.

## Creating a Skill

Each skill follows this structure:

```
skills/
└── your-skill/
    ├── SKILL.md           # Instructions for Claude
    └── scripts/
        └── your_script.rb # Ruby scripts (stdlib only)
```

### Conventions

- **Ruby stdlib only** — no gems, no Gemfile, no bundler
- **Scripts are self-contained** — each script does one thing
- **SKILL.md is the interface** — Claude reads this to know how to use your skill
- **Paths use `~/.claude/skills/`** — scripts reference their installed location

## License

[MIT](LICENSE)
