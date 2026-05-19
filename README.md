# Evan's AI Workflow

> How I actually use AI to write code. Principles, pipeline, and configs — in that order. Everything here is something I run daily.
>
> [中文版本](README_zh.md)

## Who This Is For

If you use AI coding tools and want the full workflow — not just tips, but the end-to-end pipeline from typing code to shipping PRs. I wrote this for teammates who asked "how do you actually use Claude Code?"

## Chapters

| # | Chapter | TL;DR |
|---|---------|-------|
| 1 | [Quickstart](01-quickstart.md) | Get a working AI dev environment in 5 minutes. |
| 2 | [Core MCP Servers](02-core-mcp.md) | The 8 MCP servers I run. Why each one, how to configure it. |
| 3 | [Daily Pipeline](03-daily-pipeline.md) | simplify → review → health → qa → ship. The loop I run 20 times a day. |
| 4 | [Debugging](04-debugging.md) | Root cause first, fix second. The 5-phase loop. |
| 5 | [Agent Orchestration](05-agent-orchestration.md) | One agent or many. When to split work, how to coordinate. |
| 6 | [Degradation Awareness](06-degradation.md) | Silent failure is worse than a loud crash. Every fallback needs a signal. |
| 7 | [Skill Design](07-skill-design.md) | When to write a custom skill. Anatomy of one worth keeping. |
| 8 | [Builder's Mindset](08-builders-mindset.md) | AI mental models, boil-the-lake, and communication as a skill. |
| 9 | [MCP Infrastructure](09-mcp-infrastructure.md) | MCP as architectural thinking — server selection, configuration principles. |
| 10 | [Behavioral Rules](10-behavioral-rules.md) | The global rules my AI follows across all projects. |

## Reading Order

If you just want to get started: Chapter 1, then 2. These two get you a working environment.

If you already have your environment set up: Chapter 3, then 4. These cover the daily loop and what to do when things break.

Chapters 5-10 are deeper dives — read them when you're ready to build custom skills, design MCP servers, or set behavioral rules. No hard order.

## Companion Files

```
scripts/        install-custom-skills.sh — one command to install all custom skills
templates/      CLAUDE.md.tmpl, mcp.json.tmpl — starting points you can copy and modify
```

## What This Is

Not a textbook. I change my mind about this stuff regularly. When I do, I run `/update-workflow` and the repo updates itself. Think of it as a living work log rather than a finished guide.
