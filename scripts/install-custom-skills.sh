#!/bin/bash
# Install Evan's custom Claude Code skills
# Run from evan-ai-setup repo root

set -e

SKILLS_DIR="$HOME/.claude/skills"
SOURCE_DIR="$(dirname "$0")/../skills"

echo "Installing custom skills to $SKILLS_DIR..."

# Ensure skills directory exists
mkdir -p "$SKILLS_DIR"

# Skill list: directory name -> description
declare -A SKILLS=(
    ["module-audit"]="Module audit (5-phase: ref docs → profile → design → implementation → incremental)"
    ["thesis-editor"]="Thesis docx editing with formatting constraints"
    ["docx-editor"]="Word .docx read/write/edit"
    ["pdf-reader"]="PDF text extraction"
    ["plantuml-diagram"]="PlantUML diagrams (UML, CDM, PDM)"
    ["humanizer-zh"]="Remove AI traces from Chinese text"
    ["skill-creator"]="Create new Claude Code skills"
)

# Install each skill
for skill in "${!SKILLS[@]}"; do
    desc="${SKILLS[$skill]}"
    if [ -d "$SOURCE_DIR/$skill" ]; then
        cp -r "$SOURCE_DIR/$skill" "$SKILLS_DIR/"
        echo "  ✓ $skill — $desc"
    else
        echo "  ✗ $skill — NOT FOUND in $SOURCE_DIR/$skill"
    fi
done

echo ""
echo "Done. Installed skills:"
ls -1 "$SKILLS_DIR" | grep -v gstack
