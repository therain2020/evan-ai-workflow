# 06 — Degradation Awareness

Silent failure is worse than a loud crash. Every fallback path in an AI system must signal what happened.

## The Principle

When an AI system hits a limit — context window full, API rate limited, tool unavailable — it has two choices. It can fail loudly, telling the user what happened and what was lost. Or it can degrade silently, switching to a weaker mode without telling anyone.

Silent degradation creates unreliable systems. The user sees intermittent failures, partial results, and "it worked yesterday but not today." They don't know the system downgraded itself. They just know it's flaky.

## The Pattern

Every fallback path needs three things:

1. **Signal** — a machine-readable flag that degradation occurred. Other tools and skills can check this flag and adjust their behavior.
2. **Display** — a visible indicator in the UI. The user should know they're in degraded mode. Not a red alert — a quiet indicator that says "search results are keyword-only today."
3. **Log** — the degradation event logged at WARN level with: what degraded, why, what capability was lost, and when it's expected to recover.

A fallback without these three is an accident waiting to be debugged.

## Taxonomy

| Degradation Type | Example | Capability Lost |
|-----------------|---------|----------------|
| Mode switch | Agent → Chat fallback | Tool use, file access, multi-step reasoning |
| Channel loss | Vector search → Keyword search | Semantic relevance, cross-lingual matching |
| Fake success | LLM failure → Generated fake assistant message | All actual AI capability |
| Stale data | Live query → Cached result from 24h ago | Freshness guarantees |
| Rate limit | Full model → Smaller model | Reasoning depth, context window size |

## Real Examples

### Agent → Chat Fallback

The system tries to spawn an agent for a complex task. The agent launch fails (API error, timeout, context budget exceeded). Instead of telling the user, it falls back to chat mode — which has no tool access and can't complete the task. The user gets a plausible-sounding answer that doesn't actually do the thing they asked for.

Fix: If agent launch fails, surface the error. "Agent launch failed: context budget exceeded. Reduce the scope or split into smaller tasks."

### Vector Search → Keyword Search

The vector database is unreachable. The search system silently falls back to keyword matching. Results are now sorted by token overlap instead of semantic similarity. The user searches for "how to handle errors in async Rust" and gets results about async/await syntax because "async" appears more times.

Fix: Display "Search: keyword mode" with a tooltip explaining the vector DB is temporarily unavailable.

### LLM Failure → Fake Assistant Message

The LLM API returns an error. The system generates a generic "I'm sorry, I couldn't process that" message — but formats it to look like it came from the AI. The user thinks the AI is being unhelpful when in reality the AI never saw the request.

Fix: Distinguish "the AI said X" from "the system generated X." Different styling, different attribution.

## Integration with the Review Pipeline

During `/module-audit`, one of the Phase 3 checks is: "Does every fallback path in this module satisfy Signal + Display + Log?" If a fallback is silent, it's flagged as a degradation risk.

In the daily pipeline ([Chapter 3](03-daily-pipeline.md)), `/review` checks for conditional side effects — code paths where an error handler silently swallows an exception. These are degradation bugs waiting to surface.
