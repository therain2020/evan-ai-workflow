# 04 — Debugging

Root cause first, fix second. The iron law: no fixes without investigation.

## The Iron Law

AI makes symptom-fixing too easy. Give it a stack trace and it will generate a plausible fix in seconds. The fix will look right. It will probably even pass tests. And it will patch the symptom while leaving the root cause untouched.

The iron law exists because AI accelerates Phase 4 (implementation) but doesn't replace Phases 1-3 (investigation, analysis, hypothesis). Skip those phases and you ship patches, not fixes.

## The 5-Phase Loop

### Phase 1: Root Cause Investigation

Collect everything. Don't guess. Don't fix yet.

1. **Collect symptoms** — error messages, stack traces, reproduction steps, screenshots
2. **Read the code** — trace the code path from symptom back to potential causes
3. **Check recent changes** — `git log --oneline -20 -- <affected-files>`
4. **Reproduce** — can you trigger the bug deterministically? If not, what's the failure rate?

### Phase 2: Pattern Analysis

Match the symptoms against known bug patterns:

| Pattern | Signature |
|---------|-----------|
| Race condition | Intermittent, passes when run alone, fails under load |
| Null propagation | NPE/undefined deep in a chain, origin is an optional that wasn't checked |
| State corruption | Values that drift over time, wrong after concurrent updates |
| Integration failure | Works in isolation, fails when external service responds unexpectedly |
| Stale cache | Old data showing after an update, fixes itself after TTL expires |

Also check: prior investigations from `/learn`, prior audit reports from `/module-audit` on the same files.

### Phase 3: Hypothesis Testing

Form a hypothesis. Test it. If wrong, form another.

**3-Strike Rule:** If 3 hypotheses fail, escalate to the user. You are missing something. See [Chapter 5](05-agent-orchestration.md) for the full reasoning behind this rule.

### Phase 4: Implementation

Only now — with a confirmed root cause — do you write the fix. The fix should address the cause, not the symptom. A symptom fix adds a null check where the null was first observed. A root-cause fix prevents the null from being produced in the first place.

### Phase 5: Verification

Prove the fix worked:
1. The original reproduction case no longer triggers
2. Related edge cases are covered
3. No regression in the test suite
4. The fix doesn't introduce a new degradation path (see [Chapter 6](06-degradation.md))

## How AI Changes Debugging

AI accelerates Phase 1 and Phase 2. An agent can trace a code path across 20 files in seconds — a human would grep for minutes. And it pattern-matches against a larger bug catalog than any developer keeps in their head.

Phase 4 is where it gets dangerous. AI will happily generate a symptom fix if you skip Phase 3. The iron law exists because AI makes symptom-fixing too easy.

## The `/investigate` Skill

The `/investigate` skill encodes this methodology. It adds:
- Automatic git log checks for recent changes
- Prior learning search for related investigations
- Scope locking (`/freeze`) to prevent accidental changes to unrelated files
- Structured debug report output

Use it for any bug that takes more than 5 minutes to understand.
