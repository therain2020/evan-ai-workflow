# 02 — Core MCP Servers

The 8 MCP servers I run, why I chose each one, and how they fit into the daily workflow.

## The Stack

| Server | What It Does | Daily Use |
|--------|-------------|-----------|
| Tavily | Web search | Research, checking current docs, finding API changes |
| Semantic Scholar | Academic paper search | Thesis work, finding citations |
| PlantUML | Sequence diagrams (SVG) | Architecture docs, debugging flow visualization |
| Mermaid | Flowcharts, Gantt, mindmaps | Planning, README diagrams |
| DrawIO | Architecture diagrams | System design docs |
| MySQL | Read-only DB queries | Verifying entity fields during audits |
| Playwright | Headless browser | QA testing, screenshots, form verification |
| bb-browser | 36-platform social/search | Multi-platform research |

## Why Each Server

### Tavily — Web Search

The one server I'd keep if I could only have one. AI models have a knowledge cutoff. Tavily bridges that gap. During development, I need to check current docs, verify API signatures, and find solutions to errors. Without search, the AI is working from memory. With it, it's working from the internet.

Configuration is the simplest — just an API key.

### Semantic Scholar — Academic Papers

Thesis-specific. Finding citations, checking references, searching for related work. If you're not writing academic papers, skip this one.

### PlantUML — Sequence Diagrams

Chosen over Mermaid for sequence diagrams because PlantUML handles complex UML better. Sequences of 30+ steps with alt/loop/opt blocks render cleanly. Mermaid's sequence support tops out around 15-20 steps before layout breaks down.

### Mermaid — Flowcharts and Gantt

Chosen for flowcharts, Gantt charts, and mindmaps because the syntax is simpler than PlantUML for these diagram types. Faster to write, faster to render.

### DrawIO — Architecture Diagrams

For system architecture, component layout, and deployment diagrams. The visual editor gives more control than text-to-diagram tools. Good for diagrams that need precise spatial arrangement.

### MySQL — Read-Only Queries

Connects to my `ai_library` database. Read-only. Used during module audits to verify that entity fields match actual database columns. Prevents the "code says one thing, schema says another" class of bugs.

Configuration locks it down: `NODE_ENV=production`, `LOG_LEVEL=error`, `NO_COLOR=1`. No write access.

### Playwright — Headless Browser

QA automation. Takes screenshots, fills forms, verifies page state. Runs in isolated Chromium with `--no-sandbox`. The `/qa` skill depends on it.

### bb-browser — Multi-Platform Search

Searches across 36 platforms (GitHub, Reddit, V2EX, 小红书, Twitter, YouTube, etc.). Used by the `agent-reach` skill for cross-platform research. Heavier than Tavily — use when you need platform-specific results, not general web search.

## Configuration Principles

From [Chapter 9](09-mcp-infrastructure.md):

1. **API keys via environment variables, never hardcoded.** The `env` block in `mcp.json` is the right place.
2. **Single-purpose servers.** Each server does one thing. Don't combine search + diagram + DB into one server.
3. **Restrict output directories.** PlantUML, DrawIO, Mermaid all save to specific directories. Don't let them write anywhere.
4. **Sandbox browsers.** Playwright runs isolated, headless, with a pinned Chromium binary. No shared state with your real browser.

## Adding a New Server

Before adding a new MCP server, answer:
1. What capability gap does it fill that the existing 8 don't cover?
2. Does it need network access? If yes, what's the blast radius?
3. Does it need write access to the filesystem? If yes, restrict it to one directory.
4. Can it run as a local process, or does it phone home to a cloud service?

See `templates/mcp.json.tmpl` for the complete configuration file you can copy and modify.
