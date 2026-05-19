# 08 — Builder's Mindset

AI changes the economics of software development. Marginal cost approaches zero. The constraint shifts from "how much can I produce" to "how well can I specify what I want."

## What Changes When AI Makes Marginal Cost Near Zero

Before AI: writing code was expensive. Each line cost time, attention, and decision-making energy. The natural strategy was to write the minimum — scope down, prioritize, cut features.

After AI: writing code is cheap. The expensive things are specification, verification, and integration. You spend your time describing what you want, checking that what you got is correct, and fitting it into the existing system.

### The Boil-the-Lake Principle

Traditional software engineering says: boil a pot — just enough water for the task. In AI-assisted development, you boil the lake. You do the complete thing because completeness is cheap.

Examples:
- Instead of adding one test for the new function, add tests for the entire module
- Instead of fixing the reported bug, audit the entire error handling path
- Instead of documenting the changed endpoint, update all related documentation

The cost of "do everything" with AI is often lower than the cost of "do the minimum and track what you skipped."

Counterpoint: boiling the lake is cheap in tokens, not in review attention. If you generate 3,000 lines, you must review 3,000 lines. The bottleneck shifts from writing to reviewing. Use boil-the-lake for tasks where review is linear (tests, documentation) and be cautious where review is exponential (architecture changes, security-critical paths).

## The AI Is Not a Junior Developer

A junior developer has common sense but limited knowledge. An AI has seen more code than any human but has zero common sense.

Key implications:

**Over-specify constraints, not steps.** Tell the AI what it CANNOT do, not every step of what it SHOULD do. **Context is currency.** The quality of output is proportional to the quality of context you feed in — this is why CLAUDE.md and memory systems matter. And **verify, don't trust.** AI produces plausible-looking wrong answers. Your job is to design verification gates.

## The Role of CLAUDE.md

CLAUDE.md is not documentation. It is context compression — the minimum information the AI needs to be useful in your codebase without you repeating yourself every session.

A good CLAUDE.md answers, before the AI asks:
- What are we building?
- What technologies are we using?
- How do I run, test, and build?
- Where do things live?
- What are the rules I must never break?

A project with CLAUDE.md gets a working PR on the first attempt. One without needs 3 rounds of clarification.

## Communication as a Skill

The bottleneck in AI-assisted development is not the AI's capability. It's the human's ability to describe what they want. This is a learnable skill:

1. **State the goal, not the steps.** "I need to add rate limiting to the login endpoint" — the AI can figure out which files to touch.
2. **Provide the why.** "We're seeing brute force attempts in the logs" tells the AI what kind of rate limiting (per-IP? per-user? exponential backoff?).
3. **Define done.** "Rate limiting should return 429 after 5 failed attempts within 10 minutes per IP." Specific, testable, unambiguous.
4. **Iterate in public.** Don't perfect the prompt before sending it. Send a draft, see what comes back, refine. The first response is rarely the final answer — it's the start of a conversation.

See [Chapter 5](05-agent-orchestration.md) for how to structure this iteration as a formal sub-agent protocol.
