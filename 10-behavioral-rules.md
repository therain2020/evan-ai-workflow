# 10 — Behavioral Rules

The global rules my AI follows across all projects. These live in `~/.claude/CLAUDE.md` and apply to every session.

## Why Global Rules

Without explicit rules, the AI defaults to generic helpfulness — long explanations, excessive comments, asking before every action. These defaults waste time. The rules below are optimizations accumulated over hundreds of sessions.

Each rule exists because I got burned by the default behavior at least once.

## Agent Workflow

### Advisor Strategy (auto-activation)

When a task meets ALL of the following, invoke `/advisor-strategy` before writing any code:
- 5+ distinct steps OR 3+ files OR 8+ change points
- At least one sub-task is simple enough for Haiku
- The task is implementation, not pure research/exploration

Do NOT invoke advisor-strategy when:
- Already inside an orchestrated skill pipeline (`/dev-flow`, `/investigate`, `/ship`, `/qa`, `/autoplan`)
- Single-file single-change, pure research, or user says "don't delegate"
- Reading the files would take more tokens than just doing the work

### Concurrency

When the user says "并发执行任务" or similar, do NOT launch sub-agents directly. Instead:
1. Confirm the concurrency plan (task breakdown, parallelism dependencies, which agent per task)
2. Confirm constraints for each sub-agent
3. Confirm acceptance criteria for each sub-agent
4. Start execution only after user explicitly confirms

3-Strike Rule: If a sub-agent fails the same task 3 times, stop retrying and report to the user.

### Corrective Feedback

When the user corrects a mistake, proactively ask whether to update the relevant configuration to prevent recurrence.

When the user runs `/compact`, proactively ask whether to extract constraints from the current conversation context and update project-level or global configuration.

## Shell Preference

This environment is Windows. Prefer PowerShell for all shell operations. Do NOT use Bash by default.

Use Bash ONLY when: (a) the command requires Bash-specific syntax (grep, find, pipes that PowerShell mangles), or (b) a skill/script explicitly instructs use of Bash.

PowerShell syntax notes: chain with `A; if ($?) { B }` instead of `A && B`. Variables use `$env:VAR`. Escape with backtick. Here-strings use `@'...'@`.

## Git Push Security

Before pushing to GitHub, review every commit's full diff (`git log -p <base>..HEAD`). Check for 6 categories:

1. IP addresses — internal (192.168.x.x, 10.x.x.x, 172.16-31.x.x), public, server IPs
2. Credentials — passwords, API keys, tokens, secrets, access keys, JWT secrets, AES keys
3. Personal information — emails (except git author), phone numbers, ID numbers, real names (if not publicly authorized)
4. Internal URLs — intranet addresses, unpublished domains, URLs with embedded credentials
5. Config files — `.env`, non-example values in `application.yml`, `settings.local.json`
6. System environment variables — both names and values must not be exposed (e.g. `DB_password`, `JWT_SECRET`, `ALI_TONGYI_KEY`, `AES_SECRET_KEY`)

If sensitive information is found, fix it first (git rebase -i, git filter-branch, or rewrite the commit). Never push with secrets and remediate later.

## Skill Creation Standards

When creating a project-level skill, use this format:

```
<repo>\.claude\skills\<skill-name>\SKILL.md
```

Key rules:
- **Directory structure** — a skill must be a directory containing `SKILL.md`, not a single file. `skills/update-workflow/SKILL.md` is correct; `skills/update-workflow.md` is invalid.
- **YAML frontmatter required** — the file must start with a YAML frontmatter block (`---`) containing `name`, `description`, `allowed-tools`, `triggers` fields.
- **Format consistency** — project skills and global skills (`~/.claude/skills/<name>/SKILL.md`) use identical format, only the path prefix differs.
- **skill-creator documentation is wrong** — its described `.claude/skills/<name>.md` flat-file format is NOT recognized by Claude Code. Do not use it.

Global skill path: `~/.claude/skills/<skill-name>/SKILL.md`
Project skill path: `.claude/skills/<skill-name>/SKILL.md`

## gstack

Use `/browse` from gstack for all web browsing. Never use `mcp__claude-in-chrome__*` tools.

Available gstack skills for reference: `/office-hours`, `/plan-ceo-review`, `/plan-eng-review`, `/plan-design-review`, `/design-consultation`, `/design-shotgun`, `/design-html`, `/review`, `/ship`, `/land-and-deploy`, `/canary`, `/benchmark`, `/browse`, `/open-gstack-browser`, `/qa`, `/qa-only`, `/design-review`, `/setup-browser-cookies`, `/setup-deploy`, `/setup-gbrain`, `/sync-gbrain`, `/retro`, `/investigate`, `/document-release`, `/codex`, `/cso`, `/autoplan`, `/pair-agent`, `/careful`, `/freeze`, `/guard`, `/unfreeze`, `/gstack-upgrade`, `/learn`.

## Templates

Copy `templates/CLAUDE.md.global.tmpl` to `~/.claude/CLAUDE.md` as a starting point. Customize the rules for your own preferences. The template captures what I've converged on after hundreds of sessions — your mileage may vary.
