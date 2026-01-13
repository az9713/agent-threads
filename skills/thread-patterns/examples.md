# Thread Pattern Examples

Detailed code examples for each thread type.

## Base Thread Examples

### Simple Analysis
```bash
claude -p "What does this codebase do?"
```

### With Output Format
```bash
claude -p "List all API endpoints" --output-format json
```

### Limited Turns
```bash
claude -p "Quick overview of src/" --max-turns 5
```

## Parallel Thread Examples

### Multiple Terminals (Manual)
```bash
# Terminal 1
claude -p "Review src/auth/"

# Terminal 2
claude -p "Review src/api/"

# Terminal 3
claude -p "Review src/database/"
```

### Background Jobs (Bash)
```bash
#!/bin/bash
TASKS=("review auth" "review api" "review db")

for task in "${TASKS[@]}"; do
  claude -p "$task" --output-format json > "result-${task// /-}.json" &
done
wait

echo "All complete. Review results:"
ls result-*.json
```

### GNU Parallel
```bash
# Install: apt install parallel / brew install parallel
echo -e "auth\napi\ndatabase" | parallel -j3 'claude -p "Review src/{}" > result-{}.txt'
```

## Chained Thread Examples

### Two-Phase Workflow
```bash
#!/bin/bash
# Phase 1
SESSION=$(claude -p "Plan the refactor" --output-format json | jq -r '.session_id')
read -p "Review plan. Continue? "

# Phase 2
claude -p "Execute the plan" --resume "$SESSION"
```

### Three-Phase with Validation
```bash
#!/bin/bash
echo "=== Phase 1: Plan ==="
SESSION=$(claude -p "Create implementation plan for: $1" --output-format json | jq -r '.session_id')
read -p "Approve plan? "

echo "=== Phase 2: Implement ==="
claude -p "Implement the plan" --resume "$SESSION"
read -p "Review implementation? "

echo "=== Phase 3: Validate ==="
claude -p "Run tests and fix any issues" --resume "$SESSION"
```

## Fusion Thread Examples

### Best-of-3 Code Review
```bash
#!/bin/bash
PROMPT="Review this code for bugs and security issues"

# Spawn 3 reviewers
for i in 1 2 3; do
  claude -p "$PROMPT (reviewer $i)" --output-format json > "review-$i.json" &
done
wait

# Aggregate
cat review-*.json | jq -s '.' | claude -p "
Synthesize these 3 code reviews:
1. What do all reviewers agree on?
2. Unique insights from each?
3. Any conflicts?
4. Final prioritized list of issues.
"
```

### Solution Comparison
```bash
#!/bin/bash
PROBLEM="Design a caching strategy for the API"

# Generate 3 solutions
for i in 1 2 3; do
  claude -p "$PROBLEM (approach $i - be creative)" --output-format json > "solution-$i.json" &
done
wait

# Compare and select
cat solution-*.json | jq -s '.' | claude -p "
Compare these 3 caching strategies:
- Pros and cons of each
- Which is best for our use case?
- Recommended implementation
"
```

## Big Thread Examples

### Sub-Agent Orchestration
```markdown
# In your prompt:
Use the Task tool to orchestrate:
1. @researcher - Map the codebase architecture
2. @reviewer - Analyze code quality
3. @validator - Check test coverage

Synthesize findings into a comprehensive report.
```

### Plan-Build-Validate Pipeline
```bash
claude -p "
Orchestrate a full development cycle:
1. Use @researcher to understand the current implementation
2. Use @reviewer to identify issues
3. Use @builder to fix the top 3 issues
4. Use @validator to verify fixes

Coordinate these agents and report results.
"
```

## Long Thread Examples

### Ralph Wiggum Stop Hook
```json
// hooks.json
{
  "hooks": {
    "Stop": [{
      "hooks": [{
        "type": "command",
        "command": "./scripts/ralph-loop.sh",
        "timeout": 60
      }]
    }]
  }
}
```

```bash
#!/bin/bash
# ralph-loop.sh

# Check tests
if ! npm test --silent 2>/dev/null; then
  echo '{"continue": true, "reason": "Tests failing - fix them"}'
  exit 0
fi

# Check TODOs
if grep -r "TODO" src/ 2>/dev/null | head -1; then
  echo '{"continue": true, "reason": "TODOs remain"}'
  exit 0
fi

# All good
exit 0
```

### Extended Prompt Pattern
```bash
claude -p "
Fix all failing tests in this codebase.

Completion criteria:
- All tests pass (npm test exits 0)
- No new lint errors
- No TODO comments in changed files

Work autonomously until all criteria are met.
"
```

## Zero-Touch Examples

### Comprehensive Validation Script
```bash
#!/bin/bash
set -e

echo "Running Z-Thread validation suite..."

# Quick checks first
npm run lint
npm run typecheck

# Tests
npm test

# Build
npm run build

# Security
npm audit --audit-level=high

# Git state
git diff --exit-code

echo "✓ All validations passed - Z-Thread confidence achieved"
```

### Automated Dependency Update
```bash
#!/bin/bash
# Z-Thread for routine dependency updates

claude -p "
Update all npm dependencies to latest compatible versions.
Run the full test suite after each update.
Only commit if all tests pass.
" --dangerously-skip-permissions

# Z-Thread validation
./scripts/zero-touch-validator.sh
```

## Combining Patterns

### Parallel + Fusion
```bash
# P-Thread for work, F-Thread for aggregation
./scripts/parallel-runner.sh "Review for security issues" 5
./scripts/fusion-aggregator.sh parallel-result-*.json
```

### Chained + Big
```bash
# C-Thread phases with B-Thread sub-agents
claude -p "
Phase 1: Use @researcher to map the codebase
" --output-format json > phase1.json

read -p "Review phase 1..."

claude -p "
Phase 2: Based on research, use @builder to implement improvements
" --continue
```
