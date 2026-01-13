#!/bin/bash
#
# P-Thread Demo: Run multiple Claude instances in parallel
#
# Usage: ./parallel-runner.sh "task description" [count]
#
# Example:
#   ./parallel-runner.sh "Review this codebase for bugs" 3
#   ./parallel-runner.sh "Analyze security of src/" 5
#

set -e

TASK="${1:-Analyze this codebase}"
COUNT="${2:-3}"
OUTPUT_DIR="${3:-.}"

echo "╔════════════════════════════════════════════════════════════╗"
echo "║           P-THREAD: Parallel Execution Demo                ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "Task:   $TASK"
echo "Agents: $COUNT"
echo "Output: $OUTPUT_DIR/parallel-result-*.json"
echo ""

# Check if claude is available
if ! command -v claude &> /dev/null; then
    echo "ERROR: 'claude' command not found. Please install Claude Code."
    exit 1
fi

# Array to store PIDs
PIDS=()

echo "Starting agents..."
echo ""

for i in $(seq 1 "$COUNT"); do
    OUTPUT_FILE="$OUTPUT_DIR/parallel-result-$i.json"
    echo "  Agent $i → $OUTPUT_FILE"

    # Run claude in background
    claude -p "$TASK (parallel instance $i of $COUNT)" \
        --output-format json \
        --max-turns 15 \
        > "$OUTPUT_FILE" 2>&1 &

    PIDS+=($!)
done

echo ""
echo "All agents started. Waiting for completion..."
echo ""

# Wait for all background jobs
FAILED=0
for i in "${!PIDS[@]}"; do
    pid="${PIDS[$i]}"
    agent_num=$((i + 1))

    if wait "$pid"; then
        echo "  ✓ Agent $agent_num completed successfully"
    else
        echo "  ✗ Agent $agent_num failed (exit code: $?)"
        ((FAILED++))
    fi
done

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                    P-THREAD COMPLETE                       ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "Results: $OUTPUT_DIR/parallel-result-*.json"
echo "Success: $((COUNT - FAILED))/$COUNT agents"
echo ""
echo "Next steps:"
echo "  1. Review each result file individually"
echo "  2. Or aggregate with: ./fusion-aggregator.sh parallel-result-*.json"
echo ""

# Exit with failure if any agent failed
if [ "$FAILED" -gt 0 ]; then
    exit 1
fi
