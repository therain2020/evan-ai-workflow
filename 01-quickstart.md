# 01 — Quickstart

Get an AI dev environment running in 5 minutes. This is the exact setup I use daily.

## Prerequisites

| Tool | Minimum Version | Check |
|------|----------------|-------|
| Node.js | 22+ | `node --version` |
| Python | 3.11+ | `python --version` |
| Git | 2.40+ | `git --version` |
| Windows | 11 22H2+ | `winver` |

## Step 1: Install Claude Code

```bash
npm install -g @anthropic-ai/claude-code
```

Verify: `claude --version`

## Step 2: Configure the API

I use DeepSeek as the API backend. Create or edit `~/.claude/settings.json`:

```json
{
  "env": {
    "ANTHROPIC_AUTH_TOKEN": "sk-<your-deepseek-key>",
    "ANTHROPIC_BASE_URL": "https://api.deepseek.com/anthropic",
    "ANTHROPIC_MODEL": "deepseek-v4-pro[1m]",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "deepseek-v4-flash",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "deepseek-v4-pro[1m]",
    "ANTHROPIC_DEFAULT_OPUS_MODEL": "deepseek-v4-pro[1m]"
  },
  "model": "opus",
  "theme": "dark",
  "autoUpdatesChannel": "latest",
  "permissions": {
    "allow": [
      "Bash(git *)",
      "Bash(python *)",
      "PowerShell(Get-ChildItem *)"
    ],
    "deny": [
      "WebFetch",
      "WebSearch"
    ]
  },
  "enabledPlugins": {
    "frontend-design@claude-plugins-official": true
  }
}
```

The `model` field picks the Claude model alias to use. `enabledPlugins` activates plugins like `frontend-design` for UI generation. `permissions` controls which tools auto-run without prompting — start restrictive and open up as needed.

If you use Anthropic directly, skip the `ANTHROPIC_BASE_URL` and set your Anthropic key.

## Step 3: Set Up MCP Servers

Copy the template and customize:

```bash
cp templates/mcp.json.tmpl ~/.claude/mcp.json
```

Edit `~/.claude/mcp.json` — fill in your API keys, adjust paths. See [Chapter 2](02-core-mcp.md) for what each server does and why.

The template includes all 8 servers I use. Start with Tavily (web search) and Playwright (browser) — those two alone cover most needs. Add the rest as you need them.

## Step 4: Install Skills

```bash
bash scripts/install-custom-skills.sh
```

This installs my custom skills into `~/.claude/skills/`. For the full gstack ecosystem of 50+ skills, clone and install separately.

## Step 5: Add Behavioral Rules

Copy the global CLAUDE.md template:

```bash
cp templates/CLAUDE.md.global.tmpl ~/.claude/CLAUDE.md
```

Customize it for your preferences. See [Chapter 10](10-behavioral-rules.md) for the reasoning behind each rule.

## Verify

Run Claude Code in a test project:

```bash
cd ~/test-project
claude
```

Ask: "Search the web for the latest Claude Code changelog." If Tavily MCP works, your environment is ready.

## What's Next

[Chapter 2](02-core-mcp.md) explains each MCP server in detail. [Chapter 3](03-daily-pipeline.md) shows the daily workflow this environment enables.
