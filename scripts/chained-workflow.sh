#!/bin/bash
#
# C-Thread Demo: Multi-phase workflow with human checkpoints
#
# Usage: ./chained-workflow.sh "feature or task description"
#
# Example:
#   ./chained-workflow.sh "Add user authentication"
#   ./chained-workflow.sh "Refactor the database layer"
#

set -e

TASK="${1:-Implement a new feature}"

echo "╔════════════════════════════════════════════════════════════╗"
echo "║           C-THREAD: Chained Workflow Demo                  ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "Task: $TASK"
echo ""
echo "This workflow has 3 phases with human review between each:"
echo "  Phase 1: Planning"
echo "  Phase 2: Implementation"
echo "  Phase 3: Validation"
echo ""
echo "You will review and approve each phase before continuing."
echo ""
echo "════════════════════════════════════════════════════════════"

# Check if claude is available
if ! command -v claude &> /dev/null; then
    echo "ERROR: 'claude' command not found. Please install Claude Code."
    exit 1
fi

# Check if jq is available
if ! command -v jq &> /dev/null; then
    echo "WARNING: 'jq' not found. Session continuation may not work."
    echo "  Install with: brew install jq / apt install jq"
    echo ""
fi

# ============================================================
# PHASE 1: PLANNING
# ============================================================
echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                    PHASE 1: PLANNING                       ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

SESSION_JSON=$(claude -p "
## Task
Create a detailed implementation plan for: $TASK

## Include in Your Plan
1. **Files to Modify**: List specific files that need changes
2. **Step-by-Step Implementation**: Ordered list of changes
3. **Dependencies**: Any new packages or tools needed
4. **Testing Approach**: How to verify the implementation works
5. **Potential Risks**: What could go wrong and how to mitigate

## Format
Use clear markdown headers and bullet points.
Be specific enough that another agent could execute this plan.
" --output-format json 2>&1) || true

# Try to extract session ID
SESSION_ID=""
if command -v jq &> /dev/null; then
    SESSION_ID=$(echo "$SESSION_JSON" | jq -r '.session_id // empty' 2>/dev/null || echo "")
fi

echo ""
echo "════════════════════════════════════════════════════════════"
echo ""
echo "Phase 1 complete."
if [ -n "$SESSION_ID" ]; then
    echo "Session ID: $SESSION_ID"
fi
echo ""

read -p "Review the plan above. Press Enter to continue to Phase 2 (or Ctrl+C to abort)... "

# ============================================================
# PHASE 2: IMPLEMENTATION
# ============================================================
echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                  PHASE 2: IMPLEMENTATION                   ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

if [ -n "$SESSION_ID" ]; then
    claude -p "
Now implement the plan you created in Phase 1.

## Guidelines
- Follow your plan step by step
- Make minimal, focused changes
- Explain each change as you make it
- If you encounter issues, note them but continue

Begin implementation.
" --resume "$SESSION_ID"
else
    claude -p "
Continue implementing the plan for: $TASK

## Guidelines
- Make minimal, focused changes
- Explain each change as you make it
- If you encounter issues, note them but continue
" --continue
fi

echo ""
echo "════════════════════════════════════════════════════════════"
echo ""
echo "Phase 2 complete."
echo ""

read -p "Review the implementation. Press Enter to continue to Phase 3 (or Ctrl+C to abort)... "

# ============================================================
# PHASE 3: VALIDATION
# ============================================================
echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                   PHASE 3: VALIDATION                      ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

if [ -n "$SESSION_ID" ]; then
    claude -p "
Final validation phase.

## Tasks
1. Run any available tests (npm test, pytest, etc.)
2. Check for lint errors
3. Verify the build works
4. Summarize what was accomplished
5. Note any remaining issues or follow-up tasks

Report the validation results.
" --resume "$SESSION_ID"
else
    claude -p "
Validate the implementation for: $TASK

## Tasks
1. Run any available tests
2. Check for lint errors
3. Verify the build works
4. Summarize accomplishments
5. Note any remaining issues
" --continue
fi

echo ""
echo "════════════════════════════════════════════════════════════"
echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                    C-THREAD COMPLETE                       ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "You reviewed at each checkpoint - that's the Chained Thread pattern."
echo ""
echo "The C-Thread is ideal for:"
echo "  - Production-critical changes"
echo "  - Large migrations"
echo "  - High-risk modifications"
echo "  - Work exceeding context window"
echo ""
