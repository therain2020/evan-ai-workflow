# 07 — Skill Design

When to build a custom skill, what makes one worth keeping, and the design decisions that separate a good skill from a waste of time.

## When to Build a Custom Skill

Build one when:

**The workflow repeats.** You run the same sequence of operations more than twice a week. Example: the daily pipeline ([Chapter 3](03-daily-pipeline.md)) was a manual sequence before it became `/dev-flow`.

**The domain has specific constraints that general AI gets wrong.** My MCP servers need specific environment variables and sandboxed output directories. A generic "set up MCP" instruction would miss these. `/update-env` encodes the exact constraints.

**Multiple tools need orchestration.** A skill that reads a file, searches for related papers, generates a diagram, and writes a report touches 4 tools. A skill wraps that into one invocation.

Don't build one when:
- The task is a one-off
- A gstack skill already covers it
- A CLAUDE.md behavioral rule would suffice

## Anatomy of a Good Skill

A skill is a markdown file with YAML frontmatter. The frontmatter tells Claude Code when to suggest it. The body tells Claude what to do.

```markdown
---
name: skill-name
description: One line. Be specific — "Searches academic papers via Semantic Scholar MCP" not "Helps with research."
allowed-tools:
  - Read
  - Write
  - Bash
triggers:
  - trigger phrase 1
  - trigger phrase 2
---

# Skill Title

## When to use
Concrete scenarios. Not "when you need help with X" but "when you see error Y in file Z."

## Pipeline / Instructions
Step-by-step. Each step says what tool to use and what to check.
```

### Design Decisions

**Why YAML frontmatter instead of a separate config file?** One file, one skill. No config drift. If the skill moves, its metadata moves with it.

**Why `allowed-tools` instead of letting the AI decide?** Explicit tool lists prevent the AI from reaching for the wrong tool. A PlantUML diagram skill should not use the Mermaid MCP server, even if both are available.

**Why triggers instead of manual invocation only?** Triggers make the skill discoverable. When the user types "search for papers about X," the skill surfaces without the user remembering its name.

## Trigger Design

Good triggers are specific enough to avoid false positives, conversational enough to match how people actually talk:
- "UML diagram" not "diagram" (too broad)
- "search papers" not "research" (too vague)
- "update project" not "refresh" (ambiguous)

A skill can have multiple trigger groups. `agent-reach` has 8 trigger groups — one per platform category. Each group catches the specific phrases users say for that platform.

## The gstack Boundary

gstack provides 50+ skills for general development tasks (QA, design, planning, deployment). Custom skills fill the gaps gstack doesn't cover:

| Domain | Custom Skill | Why Not gstack |
|--------|-------------|----------------|
| Thesis editing | `/thesis-editor` | Domain-specific docx manipulation |
| AI text polish | `/humanizer-zh` | Chinese-specific AI writing detection |
| PDF reading | `/pdf-reader` | Python-based extraction gstack doesn't do |
| Environment sync | `/update-env` | Scans MY environment, not generic |
| Workflow update | `/update-workflow` | Updates THIS repo, not generic |

The rule: if gstack has it, use gstack. If gstack doesn't have it and it's specific to my workflow, build it.

## The Skill Itself

This chapter was written by observing what makes skills work and what makes them fail. The meta-lesson: a skill about skill design should demonstrate its own principles. The frontmatter above is the actual format. The triggers listed are the actual triggers that work.
