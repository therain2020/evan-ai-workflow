#!/bin/bash
# setup.sh — Restore Evan's Claude Code environment from the evan-ai-workflow repo.
# Run from the repo root: bash scripts/setup.sh
# Idempotent. Safe to run multiple times. Never writes secrets to the repo.
#
# Prerequisites: Git Bash on Windows, or bash on Linux/macOS.

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CLAUDE_DIR="$HOME/.claude"
SKILLS_DIR="$CLAUDE_DIR/skills"
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo "============================================"
echo "  Evan's Claude Code Environment Setup"
echo "  Source: $SCRIPT_DIR"
echo "============================================"
echo ""

# ── Phase 0: Prerequisites ──────────────────────────────────────────────

echo "── Checking prerequisites..."

check_cmd() {
    if command -v "$1" &>/dev/null; then
        local ver
        ver=$("$1" "--version" 2>&1 | head -1 || true)
        echo -e "  ${GREEN}✓${NC} $1 — $ver"
        return 0
    else
        echo -e "  ${RED}✗${NC} $1 — not found"
        return 1
    fi
}

MISSING=""
check_cmd node   || MISSING="$MISSING  - Node.js 22+ (https://nodejs.org)\n"
check_cmd python || MISSING="$MISSING  - Python 3.11+ (https://python.org)\n"
check_cmd git    || MISSING="$MISSING  - Git 2.40+ (https://git-scm.com)\n"

if [ -n "$MISSING" ]; then
    echo ""
    echo -e "${RED}Missing prerequisites:${NC}"
    echo -e "$MISSING"
    echo "Install them and re-run this script."
    exit 1
fi

echo ""

# ── Phase 1: Claude Code ─────────────────────────────────────────────────

echo "── Checking Claude Code..."

if command -v claude &>/dev/null; then
    CLAUDE_VER=$(claude --version 2>&1 | head -1 || echo "unknown")
    echo -e "  ${GREEN}✓${NC} claude — $CLAUDE_VER"
else
    echo -e "  ${YELLOW}!${NC} Claude Code not found. Installing via npm..."
    npm install -g @anthropic-ai/claude-code
    if command -v claude &>/dev/null; then
        echo -e "  ${GREEN}✓${NC} claude installed successfully"
    else
        echo -e "  ${RED}✗${NC} Failed to install Claude Code. Check npm and try manually:"
        echo "    npm install -g @anthropic-ai/claude-code"
        exit 1
    fi
fi

echo ""

# ── Phase 2: Config Directory ────────────────────────────────────────────

echo "── Setting up ~/.claude/..."

mkdir -p "$CLAUDE_DIR"
mkdir -p "$SKILLS_DIR"

# ── Phase 3: Global CLAUDE.md ────────────────────────────────────────────

echo "── Installing global CLAUDE.md..."

TEMPLATE_CLAUDE="$SCRIPT_DIR/templates/CLAUDE.md.global.tmpl"
TARGET_CLAUDE="$CLAUDE_DIR/CLAUDE.md"

if [ -f "$TARGET_CLAUDE" ]; then
    echo -e "  ${YELLOW}!${NC} $TARGET_CLAUDE already exists."
    echo "    Diff preview:"
    if command -v diff &>/dev/null; then
        diff "$TARGET_CLAUDE" "$TEMPLATE_CLAUDE" || true
    fi
    echo ""
    read -r -p "  Overwrite? [y/N] " REPLY
    if [[ "$REPLY" =~ ^[Yy]$ ]]; then
        cp "$TEMPLATE_CLAUDE" "$TARGET_CLAUDE"
        echo -e "  ${GREEN}✓${NC} Overwritten."
    else
        echo -e "  ${YELLOW}!${NC} Skipped. Using existing file."
    fi
else
    cp "$TEMPLATE_CLAUDE" "$TARGET_CLAUDE"
    echo -e "  ${GREEN}✓${NC} Installed to $TARGET_CLAUDE"
fi

echo ""

# ── Phase 4: MCP Config ──────────────────────────────────────────────────

echo "── Installing MCP configuration..."

TEMPLATE_MCP="$SCRIPT_DIR/templates/mcp.json.tmpl"
TARGET_MCP="$CLAUDE_DIR/mcp.json"

if [ -f "$TARGET_MCP" ]; then
    echo -e "  ${YELLOW}!${NC} $TARGET_MCP already exists."
    read -r -p "  Overwrite? [y/N] " REPLY
    if [[ "$REPLY" =~ ^[Yy]$ ]]; then
        cp "$TEMPLATE_MCP" "$TARGET_MCP"
        echo -e "  ${GREEN}✓${NC} Overwritten."
    else
        echo -e "  ${YELLOW}!${NC} Skipped. Using existing file."
    fi
else
    cp "$TEMPLATE_MCP" "$TARGET_MCP"
    echo -e "  ${GREEN}✓${NC} Installed to $TARGET_MCP"
fi

# Check for remaining placeholders
if grep -q '\$[A-Z_]\+' "$TARGET_MCP" 2>/dev/null; then
    PLACEHOLDERS=$(grep -o '\$[A-Z_]\+' "$TARGET_MCP" | sort -u)
    echo ""
    echo -e "  ${YELLOW}!${NC} The following placeholders need real values in $TARGET_MCP:"
    for ph in $PLACEHOLDERS; do
        echo "    - $ph"
    done
    echo "  Edit the file and replace each one. Never commit the filled file to the repo."
else
    echo -e "  ${GREEN}✓${NC} No placeholders found — MCP config is fully configured."
fi

echo ""

# ── Phase 5: Skills ──────────────────────────────────────────────────────

echo "── Installing skills..."

# 5a. Install update-workflow from this repo
REPO_SKILL="$SCRIPT_DIR/.claude/skills/update-workflow"
TARGET_SKILL="$SKILLS_DIR/update-workflow"

if [ -d "$TARGET_SKILL" ]; then
    echo -e "  ${GREEN}✓${NC} update-workflow — already installed"
else
    cp -r "$REPO_SKILL" "$TARGET_SKILL"
    echo -e "  ${GREEN}✓${NC} update-workflow — installed from repo"
fi

# 5b. Report external custom skills
echo ""
echo "  Custom skills that need manual installation:"
echo "  (Clone each repo into $SKILLS_DIR/<name>)"
echo ""

declare -A EXTERNAL_SKILLS=(
    ["advisor-strategy"]="Strong/weak model task orchestration"
    ["project-flow"]="6-phase state-driven development pipeline"
    ["software-info-collector"]="Structured project info extraction (phase 1)"
    ["multi-perspective-thinker"]="Multi-angle critique (phase 2)"
    ["plan-auditor"]="Plan audit with cycle detection (phase 4)"
    ["full-context-gatherer"]="Mandatory 4-phase context collection"
    ["agent-reach"]="17-platform cross-platform search"
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

INSTALLED=0
MISSING_SKILLS=0
for skill in "${!EXTERNAL_SKILLS[@]}"; do
    desc="${EXTERNAL_SKILLS[$skill]}"
    if [ -d "$SKILLS_DIR/$skill" ]; then
        echo -e "    ${GREEN}✓${NC} $skill — $desc"
        ((INSTALLED++))
    else
        echo -e "    ${YELLOW}−${NC} $skill — $desc (clone repo to $SKILLS_DIR/$skill)"
        ((MISSING_SKILLS++))
    fi
done

echo ""
echo -e "  External skills: ${GREEN}$INSTALLED installed${NC}, ${YELLOW}$MISSING_SKILLS missing${NC}"

# ── Phase 6: Verify ──────────────────────────────────────────────────────

echo ""
echo "── Verification..."

FAILS=0

if [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
    echo -e "  ${GREEN}✓${NC} ~/.claude/CLAUDE.md"
else
    echo -e "  ${RED}✗${NC} ~/.claude/CLAUDE.md missing"
    ((FAILS++))
fi

if [ -f "$CLAUDE_DIR/mcp.json" ]; then
    echo -e "  ${GREEN}✓${NC} ~/.claude/mcp.json"
else
    echo -e "  ${RED}✗${NC} ~/.claude/mcp.json missing"
    ((FAILS++))
fi

if [ -d "$SKILLS_DIR/update-workflow" ]; then
    echo -e "  ${GREEN}✓${NC} ~/.claude/skills/update-workflow"
else
    echo -e "  ${RED}✗${NC} ~/.claude/skills/update-workflow missing"
    ((FAILS++))
fi

if command -v claude &>/dev/null; then
    echo -e "  ${GREEN}✓${NC} claude CLI available"
else
    echo -e "  ${RED}✗${NC} claude CLI not available"
    ((FAILS++))
fi

echo ""

if [ $FAILS -eq 0 ]; then
    echo -e "${GREEN}Setup complete.${NC}"
    echo ""
    if [ $MISSING_SKILLS -gt 0 ]; then
        echo -e "${YELLOW}Reminder: $MISSING_SKILLS external skill(s) need manual installation.${NC}"
        echo "Clone each one into $SKILLS_DIR/<name>, then run this script again to verify."
    fi
    echo ""
    echo "Next steps:"
    echo "  1. Fill in API keys in ~/.claude/mcp.json (search for \$PLACEHOLDER)"
    echo "  2. Open Claude Code in this repo and follow the restore flow in CLAUDE.md Phase 3-4"
else
    echo -e "${RED}Setup incomplete — $FAILS check(s) failed.${NC}"
    echo "Fix the issues above and re-run this script."
    exit 1
fi
