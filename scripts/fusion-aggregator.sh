#!/bin/bash
#
# F-Thread Demo: Aggregate results from parallel agents
#
# Usage: ./fusion-aggregator.sh result1.json result2.json [result3.json ...]
#        ./fusion-aggregator.sh parallel-result-*.json
#
# Example:
#   ./parallel-runner.sh "Review for bugs" 3
#   ./fusion-aggregator.sh parallel-result-*.json
#

set -e

echo "╔════════════════════════════════════════════════════════════╗"
echo "║           F-THREAD: Fusion Aggregation Demo                ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Check arguments
if [ $# -eq 0 ]; then
    echo "ERROR: No input files specified"
    echo ""
    echo "Usage: $0 result1.json result2.json ..."
    echo "       $0 parallel-result-*.json"
    exit 1
fi

# Check if jq is available
if ! command -v jq &> /dev/null; then
    echo "ERROR: 'jq' command not found. Please install jq."
    echo "  macOS:   brew install jq"
    echo "  Ubuntu:  apt install jq"
    echo "  Windows: choco install jq"
    exit 1
fi

# Check if claude is available
if ! command -v claude &> /dev/null; then
    echo "ERROR: 'claude' command not found. Please install Claude Code."
    exit 1
fi

# Count and list input files
FILE_COUNT=$#
echo "Input files: $FILE_COUNT"
for file in "$@"; do
    if [ -f "$file" ]; then
        echo "  ✓ $file"
    else
        echo "  ✗ $file (not found)"
        exit 1
    fi
done
echo ""

echo "Combining results..."

# Combine all JSON files
# Extract just the result/output from each, handling various JSON structures
COMBINED=$(cat "$@" | jq -s '
  [.[] |
    if type == "object" then
      if .result then .result
      elif .output then .output
      elif .content then .content
      else .
      end
    else .
    end
  ]
')

echo "Aggregating with Claude..."
echo ""
echo "════════════════════════════════════════════════════════════"
echo ""

# Use Claude to synthesize results
echo "$COMBINED" | claude -p "
You are aggregating results from $FILE_COUNT parallel agents that analyzed the same problem.

## Your Task

Compare all results and provide a synthesized analysis:

### 1. Consensus Points
What do most/all agents agree on? These are high-confidence findings.

### 2. Unique Insights
Valuable points that only one agent discovered. Don't dismiss these.

### 3. Conflicts
Where do agents disagree? Analyze which perspective is more likely correct.

### 4. Final Synthesis
Combine the best insights into a unified, prioritized recommendation.

## Format

Use clear headers and bullet points. Be concise but thorough.
Prioritize actionable insights over general observations.

---

Results from $FILE_COUNT agents are provided via stdin (JSON array).
"

echo ""
echo "════════════════════════════════════════════════════════════"
echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                    F-THREAD COMPLETE                       ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "The above is a fusion of $FILE_COUNT agent results."
echo "This demonstrates the Best-of-N pattern with intelligent aggregation."
