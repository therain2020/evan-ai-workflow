# 10 — Behavioral Rules

The global rules my AI follows across all projects. These live in `~/.claude/CLAUDE.md` and apply to every session.

## Why Global Rules

Without explicit rules, the AI defaults to generic helpfulness — long explanations, excessive comments, asking before every action. These defaults waste time. The rules below are optimizations accumulated over hundreds of sessions.

Each rule exists because I got burned by the default behavior at least once.

## Communication Style

**Discuss in Chinese, code in English.** Code (variable names, comments, commit messages) stays in English. Discussion and reasoning can be in Chinese. This matches how I think.

**Be direct and specific.** "The memory leak is in `cache.ts:42`" not "There appears to be a potential issue with memory management in the caching layer."

**No emoji in code or documentation.** No rocket ships, no checkmarks, no lightbulbs. They add visual noise without information.

**Reference code as `file:line_number`.** "See `auth/login.ts:42`" not "See the login function in the auth module."

## Tool Preferences

**Prefer Read, Write, Edit, Glob, Grep over Bash.** These tools are faster and provide better UX. Use Bash only for actual shell operations (git commands, npm install, running tests).

**Prefer PowerShell on Windows.** Use Bash only when the command requires Bash-specific syntax.

**Use `/browse` from gstack for all web browsing.** Don't use `mcp__claude-in-chrome__*` tools.

## Agent Workflow

**Use `/advisor-strategy` for complex tasks.** When a task has 5+ distinct steps, 3+ files, or 8+ change points — and at least one sub-task is simple enough for a weaker model — delegate via advisor-strategy.

**Concurrency requires confirmation.** When the user says "do these in parallel," confirm the task breakdown, constraints, and acceptance criteria before launching sub-agents.

**3-Strike Rule.** If a sub-agent fails the same task 3 times, stop and escalate. Don't retry with the same setup.

## Code Style

**No WHAT comments.** Well-named identifiers already say what the code does. Comments should only explain WHY — non-obvious constraints, subtle invariants, workarounds for specific bugs.

**No half-finished implementations.** Don't add features, refactors, or abstractions beyond what the task requires. A bug fix doesn't need surrounding cleanup. Three similar lines is better than a premature abstraction.

**Simple over abstract.** Don't design for hypothetical future requirements. Don't add error handling for scenarios that can't happen. Trust internal code and let it fail at system boundaries.

## Safety Rules

**Never update git config.** `git config` commands are off-limits.

**Never skip hooks.** No `--no-verify`, no `--no-gpg-sign`. If a hook fails, fix the underlying issue.

**Never force-push to main/master.** Warn if the user requests it.

**Never commit secrets.** `.env`, `credentials.json`, `mcp.json`, and any file containing API keys or passwords must not be staged.

**Review before pushing.** Before `git push`, review the full diff (`git log -p <base>..HEAD`) for: IP addresses, credentials, personal information, internal URLs, config files with real values, and unredacted environment variables.

## Skill Usage

**Invoke skills by name.** When the user says "debug this" → `/investigate`. When they say "ship it" → `/ship`. Learn the trigger phrases.

**Don't invoke a skill that's already running.** Check if a skill is active before launching it.

## Templates

Copy `templates/CLAUDE.md.global.tmpl` to `~/.claude/CLAUDE.md` as a starting point. Customize the rules for your own preferences. The template captures what I've converged on after hundreds of sessions — your mileage may vary.
