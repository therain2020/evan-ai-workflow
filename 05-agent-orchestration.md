# 05 — Agent Orchestration

One agent or many. When to split work, how to coordinate them, and what to do when a sub-agent fails.

## One Brain vs. Many

A single Claude Code session with all tools loaded is a powerful generalist. It can read code, search the web, run tests, and edit files. For most tasks — fixing a bug, adding a small feature — one agent is enough.

Multiple agents make sense when the task is decomposable into independent sub-tasks. Each sub-agent gets a narrower prompt and fewer tools. It runs faster, costs less, and is less likely to get confused.

### When to Use a Single Agent

The task has fewer than 5 distinct steps, touches fewer than 3 files, or has sequential dependencies where each step depends on the output of the previous one.

### When to Use Multiple Agents

The task has 5 or more independent steps, touches 3 or more unrelated files, or benefits from parallel execution. Example: auditing 8 chapters in parallel is faster with 8 sub-agents than one agent reading sequentially.

## The 5-Step Protocol

When launching multiple agents, follow this protocol:

1. **Decompose** — break the task into independent sub-tasks. Each sub-task should be completable by a single agent with a focused prompt.
2. **Define constraints per agent** — what tools it has, what files it can touch, what it must NOT do.
3. **Set acceptance criteria** — what does "done" look like for each sub-agent? Be specific.
4. **Launch in parallel** — all independent sub-agents go out at once. Don't wait for A before launching B unless B depends on A's output.
5. **Review and synthesize** — each sub-agent returns a report. You review, catch contradictions, and synthesize the final result.

## Sub-Agent Prompt Design

A good sub-agent prompt answers, before the agent asks:
- What is the goal of this sub-task?
- What files or data should it work with?
- What is it NOT allowed to change?
- What format should its output take?
- How long should its answer be?

Bad prompt: "Review the authentication module."
Good prompt: "Read `src/auth/login.ts` and `src/auth/session.ts`. Find: SQL injection risks, missing input validation, and hardcoded secrets. Report each finding with line number and suggested fix. Do NOT edit any files. Under 300 words."

## Context Budget

Each sub-agent starts with system overhead (~2K tokens) plus your prompt (~1-3K tokens). The remaining budget goes to file reads. Don't ask a sub-agent to read 50 files — it will hit its context limit and degrade. Split large reading tasks across more sub-agents.

## The 3-Strike Rule

If the same sub-agent fails the same task 3 times, stop retrying and escalate to the user. Three failures means the task is poorly defined, the tools are insufficient, or the agent doesn't understand something fundamental. Retrying with the same setup will not help.

This rule applies in debugging too — see [Chapter 4](04-debugging.md) for the Phase 3 hypothesis testing variant.

## When NOT to Delegate

Don't use sub-agents when:
- The task is a single-file edit
- The user says "just do it" or "don't overthink this"
- Reading the files the sub-agent would need would take more tokens than just doing the work yourself

The overhead of spawning, prompting, and reviewing sub-agents is only worth it when the parallelism gain exceeds the orchestration cost.
