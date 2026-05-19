---
name: update-workflow
description: Sync evan-ai-workflow to match actual AI usage — observe real tooling/workflows/habits, then update chapters, READMEs, scripts/templates so the docs reflect reality.
allowed-tools:
  - Read
  - Write
  - Edit
  - Grep
  - Glob
  - PowerShell
  - Agent
triggers:
  - update workflow
  - update the workflow
  - refresh workflow
  - workflow update
---

# Update Workflow

Keep `evan-ai-workflow` in sync with how AI is actually being used right now. Behavior is the truth; docs are a mirror.

## When to use

Run `/update-workflow` when:
- Your actual tooling changes (new MCP server, switched model, npm package change, skill added/removed)
- Your actual workflow changes (a pipeline step you no longer run, a new loop you rely on)
- Your opinions change (a principle evolved, a rule no longer applies) — but only if the opinion changed your behavior first
- You notice the docs say something you haven't done in weeks — the docs are stale, not your behavior

## Pipeline

### Phase 0: Pre-flight

```
git status
git log --oneline -3
```

Warn if working tree is dirty.

### Phase 1: Observe Actual Usage

Read the user's real configuration files to build a snapshot of "what's actually happening right now":

1. **Model and API config** — `~/.claude/settings.json`
   - `ANTHROPIC_MODEL`, `ANTHROPIC_BASE_URL`, `ANTHROPIC_DEFAULT_HAIKU_MODEL`, `ANTHROPIC_DEFAULT_SONNET_MODEL`, `ANTHROPIC_DEFAULT_OPUS_MODEL` env vars
   - `model` field (which Claude model alias is selected)
   - `enabledPlugins`
   - `permissions.allow` and `permissions.deny`

2. **MCP servers** — `~/.claude/mcp.json`
   - Server names, commands, args, environment variables
   - Total count, which servers are configured

3. **Global behavioral rules** — `~/.claude/CLAUDE.md`
   - Full content of the global rules file

4. **Installed skills** — `~/.claude/skills/`
   - List of directory names (each is an installed skill)

5. **Other config** — `~/.claude/` root
   - `settings.local.json`, `keybindings.json`, `mcp.json` variants

Do NOT delegate this phase to agents — reading 5 local files is fast.

### Phase 2: Compare Against Chapters

For each observation from Phase 1, read the corresponding chapter(s) and find drift. Use sub-agents in parallel (one for chapters 01-03, one for 07-10, one for READMEs and templates):

| Observation | Compare against | Key questions |
|-------------|----------------|---------------|
| Model config | Chapter 1 (Quickstart) | Model name match? Base URL correct? Install steps still valid? |
| MCP servers | Chapters 2 + 9 | All running servers documented? Any documented server no longer in use? Config details match? |
| Global rules | Chapter 10 (Behavioral Rules), `templates/CLAUDE.md.global.tmpl` | Rules match? Template synced with actual CLAUDE.md? |
| Installed skills | Chapter 7 (Skill Design) | Skills mentioned still exist? New skill categories not covered? |
| Pipeline skills | Chapter 3 (Daily Pipeline) | simplify/review/health/qa/ship actually available? Any new pipeline steps not documented? |
| Overall environment | Chapter 8 (Builder's Mindset) | Mindset references still relevant to current tooling? |

Report findings grouped by chapter. **Drift findings are highest priority** — the docs must follow the behavior.

### Phase 3: Chapter Internal Audit

Read all 10 chapter files. For each chapter, check:

1. **Broken links** — internal cross-references to other chapters, external links.
2. **Terminology drift** — standard terms must be consistent: "sub-agent", "MCP server", "degradation", "pipeline", "skill".
3. **Stale references** — model names, npm package versions, dates that have passed, tool features that changed.
4. **AI writing traces** — three-item lists, negative-parallelism patterns, AI filler words, em dash overuse (>3 per section), filler phrases, bold+colon list patterns.
5. **Missing cross-references** — if Chapter A explains a concept Chapter B depends on, suggest linking.
6. **Chapter description accuracy** — does the chapter's one-liner in README tables match its actual content?

These are secondary to Phase 2 drift findings. Docs that are internally consistent but describe stale behavior are still wrong.

### Phase 4: README Sync

Read `README.md` and `README_zh.md`:

1. Verify the chapter table has all 10 chapters with correct links.
2. Verify each one-liner matches the chapter's opening paragraph.
3. Both READMEs must have identical structure and link targets.
4. Language switcher links present and correct.
5. Humanizer polish — no AI traces, no offensive language, natural tone per language.

### Phase 5: Scripts and Templates Check

Verify:
1. `scripts/install-custom-skills.sh` is present and references actual installed custom skills (the ones NOT from gstack).
2. `templates/CLAUDE.md.global.tmpl` matches the behavioral rules in Chapter 10 and the actual `~/.claude/CLAUDE.md`.
3. `templates/CLAUDE.md.tmpl` has current placeholder structure.
4. `templates/mcp.json.tmpl` matches the MCP servers described in Chapters 2 and 9 and the actual `~/.claude/mcp.json`.

### Phase 6: Apply Fixes

Priority order:
1. **Drift fixes** (Phase 2) — chapters that describe stale behavior
2. **Internal consistency fixes** (Phase 3) — broken links, stale references, terminology
3. **README/template fixes** (Phases 4-5)

For each finding:
- Use `Edit` for targeted changes.
- Use `Write` only for full rewrites.
- Skip false positives — note and move on.

### Phase 7: Pre-commit Review

```
git diff --stat
git diff
```

Check for sensitive information: no IP addresses, credentials, API keys, personal information beyond git author, internal URLs, unredacted env var values.

### Phase 8: Commit and Push

```
git add <files>
git commit -m "docs: workflow update — <brief summary>"
git push
```

Commit message format: `docs: workflow update — <one-line summary>`.

### Phase 9: Summary

Report: drift findings and fixes, chapters audited, internal issues found/fixed, README sync status, scripts/templates status, commit hash, push confirmation.
