#!/bin/bash
#
# L-Thread: Ralph Wiggum Stop Hook
#
# This script is called by Claude Code's Stop hook to determine
# if the agent should continue working or stop.
#
# Exit codes:
#   0 = Allow stop (work is complete)
#
# JSON output:
#   {"continue": true, "reason": "..."} = Keep working
#   {"continue": false} = Allow stop
#
# Usage:
#   This script is automatically called by the Stop hook.
#   Configure in hooks.json or .claude/settings.json
#

# Read hook input from stdin (contains session info)
INPUT=$(cat)

# Optional: Extract useful info from input
TRANSCRIPT=$(echo "$INPUT" | jq -r '.transcript_path // empty' 2>/dev/null || echo "")
CWD=$(echo "$INPUT" | jq -r '.cwd // empty' 2>/dev/null || echo "$(pwd)")

# Change to the working directory if specified
if [ -n "$CWD" ] && [ -d "$CWD" ]; then
    cd "$CWD"
fi

# ============================================================
# VALIDATION CHECKS
# ============================================================
# Add or remove checks based on your project needs.
# If ANY check fails, the agent will continue working.
# ============================================================

# Check 1: Are tests passing?
if [ -f "package.json" ]; then
    # Node.js project
    if grep -q '"test"' package.json 2>/dev/null; then
        if ! npm test --silent 2>/dev/null; then
            echo '{"continue": true, "reason": "Tests are failing. Please fix the failing tests before stopping."}'
            exit 0
        fi
    fi
elif [ -f "pytest.ini" ] || [ -f "pyproject.toml" ] || [ -d "tests" ]; then
    # Python project
    if command -v pytest &> /dev/null; then
        if ! pytest --quiet 2>/dev/null; then
            echo '{"continue": true, "reason": "Pytest tests are failing. Please fix them."}'
            exit 0
        fi
    fi
elif [ -f "go.mod" ]; then
    # Go project
    if ! go test ./... 2>/dev/null; then
        echo '{"continue": true, "reason": "Go tests are failing. Please fix them."}'
        exit 0
    fi
fi

# Check 2: Are there TODOs in recently changed files?
if command -v git &> /dev/null && [ -d ".git" ]; then
    # Get files changed in last commit or staged
    CHANGED_FILES=$(git diff --name-only HEAD~1 2>/dev/null || git diff --name-only --cached 2>/dev/null || echo "")

    if [ -n "$CHANGED_FILES" ]; then
        TODO_FILES=$(echo "$CHANGED_FILES" | xargs grep -l "TODO\|FIXME\|XXX" 2>/dev/null || echo "")
        if [ -n "$TODO_FILES" ]; then
            echo "{\"continue\": true, \"reason\": \"TODOs/FIXMEs found in recently changed files: $TODO_FILES\"}"
            exit 0
        fi
    fi
fi

# Check 3: Are there lint errors? (if linter available)
if [ -f "package.json" ] && grep -q '"lint"' package.json 2>/dev/null; then
    LINT_OUTPUT=$(npm run lint --silent 2>&1 || echo "")
    if echo "$LINT_OUTPUT" | grep -qi "error"; then
        echo '{"continue": true, "reason": "Lint errors found. Please fix them before stopping."}'
        exit 0
    fi
fi

# Check 4: Does the build pass? (optional, can be slow)
# Uncomment if you want build verification
# if [ -f "package.json" ] && grep -q '"build"' package.json 2>/dev/null; then
#     if ! npm run build --silent 2>/dev/null; then
#         echo '{"continue": true, "reason": "Build is failing. Please fix build errors."}'
#         exit 0
#     fi
# fi

# Check 5: Are there uncommitted changes that should be committed?
# This is informational - uncomment to enforce
# if command -v git &> /dev/null && [ -d ".git" ]; then
#     if ! git diff --exit-code --quiet 2>/dev/null; then
#         echo '{"continue": true, "reason": "There are uncommitted changes. Consider committing your work."}'
#         exit 0
#     fi
# fi

# ============================================================
# ALL CHECKS PASSED
# ============================================================
# If we get here, all validation checks passed.
# Exit 0 to allow the agent to stop.
# ============================================================

exit 0
