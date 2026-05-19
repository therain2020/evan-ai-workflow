---
name: update-workflow
description: Automated update pipeline for evan-ai-workflow — audit chapters, sync READMEs, check scripts/templates, commit and push.
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

Automated update pipeline for `evan-ai-workflow`. Audits 10 chapters, verifies READMEs, checks scripts and templates, commits and pushes.

## When to use

Run `/update-workflow` when:
- Your tooling changes (new MCP server, npm package change, skill added/removed)
- Your opinions change (a principle evolved, a rule no longer applies)
- Periodic maintenance — catch staleness, inconsistency, AI writing traces

## Pipeline

### Phase 0: Pre-flight

```
git status
git log --oneline -3
```

Warn if working tree is dirty.

### Phase 1: Chapter Audit

Read all 10 chapter files. Audit in parallel using sub-agents (chapters 01-05 in one agent, 06-10 in another). For each chapter, check:

1. **Broken links** — internal cross-references to other chapters, external links.
2. **Terminology drift** — standard terms must be consistent: "sub-agent", "MCP server", "degradation", "pipeline", "skill".
3. **Stale references** — model names, npm package versions, dates that have passed, tool features that changed.
4. **AI writing traces** — three-item lists, negative-parallelism patterns, AI filler words, em dash overuse (>3 per section), filler phrases, bold+colon list patterns.
5. **Missing cross-references** — if Chapter A explains a concept Chapter B depends on, suggest linking.
6. **Chapter description accuracy** — does the chapter's one-liner in README tables match its actual content?

Report findings grouped by chapter.

### Phase 2: README Sync

Read `README.md` and `README_zh.md`:

1. Verify the chapter table has all 10 chapters with correct links.
2. Verify each one-liner matches the chapter's opening paragraph.
3. Both READMEs must have identical structure and link targets.
4. Language switcher links present and correct.
5. Humanizer polish — no AI traces, no offensive language, natural tone per language.

### Phase 3: Scripts and Templates Check

Verify:
1. `scripts/install-custom-skills.sh` is present and references actual installed skills.
2. `templates/CLAUDE.md.global.tmpl` matches the behavioral rules in Chapter 10.
3. `templates/CLAUDE.md.tmpl` has current placeholder structure.
4. `templates/mcp.json.tmpl` matches the MCP servers described in Chapters 2 and 9.

### Phase 4: Apply Fixes

For each finding:
- Use `Edit` for targeted changes.
- Use `Write` only for full rewrites.
- Skip false positives — note and move on.

### Phase 5: Pre-commit Review

```
git diff --stat
git diff
```

Check for sensitive information: no IP addresses, credentials, API keys, personal information beyond git author, internal URLs, unredacted env var values.

### Phase 6: Commit and Push

```
git add <files>
git commit -m "docs: workflow update — <brief summary>"
git push
```

Commit message format: `docs: workflow update — <one-line summary>`.

### Phase 7: Summary

Report: chapters audited, issues found/fixed by category, README sync status, scripts/templates status, commit hash, push confirmation.
