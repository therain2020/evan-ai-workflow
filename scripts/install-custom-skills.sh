#!/bin/bash
# Install Evan's custom Claude Code skills
# These are the non-gstack skills I use across projects

set -e

SKILLS_DIR="$HOME/.claude/skills"

echo "Installing custom skills to $SKILLS_DIR..."

mkdir -p "$SKILLS_DIR"

# Skill list: directory name -> description
declare -A SKILLS=(
    ["debug-methodology"]="Systematic debugging methodology (Chinese)"
    ["thesis-editor"]="Thesis docx editing with formatting constraints"
    ["docx-editor"]="Word .docx read/write/edit with XML manipulation"
    ["pdf-reader"]="PDF text extraction, metadata, tables"
    ["plantuml-diagram"]="PlantUML diagrams (UML, CDM, PDM)"
    ["mermaid-diagram"]="Mermaid diagrams (flowchart, gantt, mindmap)"
    ["drawio"]="DrawIO architecture and flow diagrams"
    ["humanizer"]="Remove AI traces from English text"
    ["humanizer-zh"]="Remove AI traces from Chinese text"
    ["readme-updater"]="Humanized dual-language README pipeline"
    ["plan-writer"]="One-shot plan + diagram generation"
    ["github-marketing"]="Open source distribution strategy"
    ["skill-creator"]="Create new Claude Code skills"
    ["module-audit"]="Module audit (5-phase deep-dive)"
)

# Install from cloned repos or local sources
for skill in "${!SKILLS[@]}"; do
    desc="${SKILLS[$skill]}"
    if [ -d "$SKILLS_DIR/$skill" ]; then
        echo "  ✓ $skill — already installed ($desc)"
    else
        echo "  - $skill — clone the repo first: git clone <repo-url> $SKILLS_DIR/$skill ($desc)"
    fi
done

echo ""
echo "Installed custom skills:"
ls -1 "$SKILLS_DIR" 2>/dev/null | grep -v "^gstack" || echo "  (none)"
