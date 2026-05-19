# Evan's AI Workflow

> How I actually use AI to write code. Principles, pipeline, and configs — in that order. I run everything in here daily.
>
> [中文版本](README_zh.md)

## Who this is for

You're using AI coding tools and want the full workflow — not scattered tips, the end-to-end pipeline from typing to shipping. I wrote this for teammates who kept asking "how do you actually use Claude Code?"

## Chapters

| # | Chapter | What it covers |
|---|---------|----------------|
| 1 | [Quickstart](01-quickstart.md) | Working AI dev environment in 5 minutes. DeepSeek V4 Pro, Claude Code, MCP setup. |
| 2 | [Core MCP Servers](02-core-mcp.md) | The 8 MCP servers I run daily. Tavily, MySQL, Playwright, Semantic Scholar, and 4 more. |
| 3 | [Daily Pipeline](03-daily-pipeline.md) | simplify → review → health → qa → ship. The loop I run 20 times a day. |
| 4 | [Debugging](04-debugging.md) | Root cause first, fix second. The 5-phase loop and the 3-chance rule. |
| 5 | [Agent Orchestration](05-agent-orchestration.md) | One agent or many. When to split, how to coordinate, context budgets. |
| 6 | [Degradation Awareness](06-degradation.md) | Silent failure beats loud crashes. Every fallback needs a signal, a display, and a log. |
| 7 | [Skill Design](07-skill-design.md) | Anatomy of a custom skill. When to build one, when not to. |
| 8 | [Builder's Mindset](08-builders-mindset.md) | Boil-the-lake, AI as junior dev with infinite knowledge but zero common sense, CLAUDE.md as context compression. |
| 9 | [MCP Infrastructure](09-mcp-infrastructure.md) | MCP as architecture. Server selection, configuration rules, onboarding checklist. |
| 10 | [Behavioral Rules](10-behavioral-rules.md) | The global CLAUDE.md my AI follows across every project. |

## Reading order

**Just getting started:** Chapter 1 then 2. You'll have a working environment.

**Environment is already set up:** Chapter 3 then 4. The daily loop and what to do when things break.

Chapters 5 through 10 are deeper dives — jump to whichever one you need. No fixed order.

## Companion files

```
scripts/        install-custom-skills.sh — installs my custom skills in one command
templates/      CLAUDE.md.tmpl, CLAUDE.md.global.tmpl, mcp.json.tmpl — copy and edit to bootstrap your own setup
```

## How this repo works

I use AI a certain way. When that changes — new MCP server, different model, a workflow I no longer run — I fire `/update-workflow`. The skill reads my actual config files, compares them against these docs, and fixes whatever drifted. Behavior is the truth. The docs are a mirror.

No textbook. A living work log that follows what I actually do.
