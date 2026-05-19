# 09 — MCP Infrastructure

MCP as architectural thinking. Server selection criteria, configuration principles, and what I learned from running 8 servers daily.

## What MCP Enables

MCP (Model Context Protocol) gives AI models structured access to external tools. Instead of the AI describing what it would do with a database, it runs a query. Instead of guessing what a webpage looks like, it takes a screenshot.

The protocol itself is simple — JSON-RPC over stdio or HTTP. The complexity is in choosing which servers to run, configuring them safely, and keeping them maintainable.

## Server Selection Criteria

Before adding a server, I check:

1. **Capability gap.** Does this server do something the existing stack can't? Tavily added web search. Semantic Scholar added paper search. Each server earns its place by filling a gap.

2. **Local vs. cloud.** Local servers (MySQL, Playwright) run on my machine. Cloud servers (Tavily, Semantic Scholar) call external APIs. Local servers don't need API keys but need more configuration. Cloud servers are plug-and-play but have rate limits and privacy implications.

3. **Sandboxing.** Can I restrict this server's access? Playwright runs in an isolated Chromium with a pinned binary. MySQL connects read-only to one database. If a server needs unrestricted filesystem or network access, I don't install it.

4. **Maintenance burden.** Each server is a moving part. npm packages update, APIs change, configuration drifts. I run 8 servers. More than that and the maintenance overhead exceeds the capability gain.

## Configuration Principles

### Environment Variables, Never Hardcoded

API keys go in the `env` block of `mcp.json`. Database credentials go in `mcp.json` env block. Never in source code, never in documentation. `mcp.json` is gitignored for this reason.

### Single-Purpose Servers

Each server does one thing. Tavily searches, PlantUML draws sequence diagrams, MySQL queries. Don't combine capabilities — it makes debugging harder when something breaks and you can't tell which part failed.

### Restricted Output Directories

Diagram servers (PlantUML, Mermaid, DrawIO) save to specific directories. Set `PLANTUML_ALLOWED_DIRS` or equivalent to prevent them from writing outside their sandbox.

### Sandboxed Browsers

Playwright runs with `--headless --isolated --no-sandbox` using a pinned Chromium binary. No shared cookies, no shared cache, no shared state with my real browser. If a QA test accidentally navigates to a malicious page, the blast radius is contained.

## The 8-Server Configuration

See `templates/mcp.json.tmpl` for the complete configuration file. Key details per server:

| Server | Transport | Auth | Sandbox |
|--------|-----------|------|---------|
| Tavily | npx, HTTP | API key in env | None needed (read-only search) |
| Semantic Scholar | Local node, stdio | None | None needed |
| PlantUML | Local cmd, stdio | None | `ALLOWED_DIRS` restricted |
| Mermaid | Local node, stdio | None | Output to temp dir |
| DrawIO | Local cmd, stdio | None | Output to temp dir |
| MySQL | Local cmd, stdio | DB password in env | Read-only, one database, error log level |
| Playwright | Local cmd, stdio | None | Headless, isolated, pinned binary, no-sandbox |
| bb-browser | npx, HTTP | None | None |

## Adding a New MCP Server

Checklist before adding:

- [ ] It fills a gap the existing 8 don't cover
- [ ] It runs locally or has an acceptable privacy policy (cloud)
- [ ] Its blast radius is restricted (filesystem, network, database)
- [ ] It uses environment variables for secrets
- [ ] It's maintained (check npm downloads, last publish date, open issues)
- [ ] I've run it manually once to verify it works before wiring it into mcp.json

See [Chapter 2](02-core-mcp.md) for the daily-use perspective on each server — what it does and when to use it.
