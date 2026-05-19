# 03 — Daily Pipeline

The loop I run 20 times a day: write code, run the pipeline, ship. Five layers, each with a specific job.

## The Pipeline

```
Write code → /simplify → /review → /health → /qa → /ship
```

Each layer catches a different class of problem. Skipping a layer means that class of problem reaches production.

## Layer 1: `/simplify` — Code Quality

Three agents run in parallel on the diff:

- **Reuse agent** — finds duplicated logic, suggests existing utilities
- **Quality agent** — catches hacky patterns, redundant state, nested conditionals
- **Efficiency agent** — flags unnecessary work, missed concurrency, memory leaks

Run this first. If simplify finds issues, fix them before moving on. There's no point reviewing code that's structurally broken.

## Layer 2: `/review` — Security

Checks the diff for:
- SQL injection (MyBatis `${}` vs `#{}`)
- LLM trust boundaries (user input reaching prompts unfiltered)
- Conditional side effects (auth checks that can be bypassed by code path ordering)

For security-sensitive changes, layer on `/cso` (a full infrastructure security audit).

## Layer 3: `/health` — Correctness

Runs the project's own tools and computes a composite score:
- Type checker
- Linter
- Test suite
- Dead code detector

The score trends over time. A drop from 8.2 to 6.1 on a single PR is a red flag even if individual checks pass.

## Layer 4: `/qa` — User Experience

Headless browser testing via Playwright MCP. Three tiers:
- **Quick** — critical and high-severity paths only
- **Standard** — adds medium-severity checks
- **Exhaustive** — everything, including cosmetic issues

Quick for every PR. Standard before merging to main. Exhaustive before a release.

## Layer 5: `/ship` — Delivery

The final gate:
1. Detect the base branch (main or master)
2. Run the full test suite one more time
3. Bump VERSION if configured
4. Update CHANGELOG
5. Commit with a structured message
6. Push and create a PR

## When to Run Each Layer

| Situation | Layers |
|-----------|--------|
| Bug fix | `/simplify` → `/review` → `/health` |
| New feature (no UI) | `/simplify` → `/review` → `/health` |
| New feature (with UI) | Full pipeline |
| Refactoring | `/simplify` → `/health` |
| Security-sensitive | `/simplify` → `/review` → `/cso` |
| Before merging any PR | At minimum `/review` + `/health` |

## The Shortcut: `/dev-flow`

For standard changes, run `/dev-flow` — it orchestrates simplify → review → health → qa → ship in sequence, committing checkpoints along the way. Supports multi-device handoff (start on desktop, continue on laptop).

## Why Five Layers

A single linter or a single review pass catches one class of problem. The pipeline catches five. The cost of running all five layers is minutes. The cost of a bug reaching production is hours.

Each layer is independent. If `/health` finds something, you fix it and re-run just `/health` — not the whole pipeline.

See [Chapter 7](07-skill-design.md) for the design decisions behind each skill in the pipeline.
